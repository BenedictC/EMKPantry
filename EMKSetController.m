//
//  EMKSetController.m
//  EMKPantry
//
//  Created by Benedict Cohen on 06/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKSetController.h"

#import "EMKSetControllerSectionInfo.h"
#import "EMKSetControllerSection.h"


#import "EMKSetControllerSectionChangeDescription.h"
#import "EMKSetControllerObjectChangeDescription.h"


@interface EMKSetController ()

@property(nonatomic, retain) NSArray *sortDescriptors;
@property(nonatomic, retain) NSArray *secondaryKeyPaths;

-(EMKSetControllerSection *)sectionWithName:(NSString *)sectionName;

-(void)invokePostUpdateDelegateMethodsWithSectionChangeDescriptions:(NSArray *)sectionChangeDescriptions objectChangeDescriptions:(NSArray *)objectChangeDescriptions;

-(void)observeValueForSecondaryKeyPath:(NSString *)keyPath ofObject:(id)object;
-(void)observeValueForSortKeyPath:(NSString *)keyPath ofObject:(id)object;

-(void)observeObject:(id)object;
-(void)unobserveObject:(id)object;

@end




@implementation EMKSetController

#pragma mark memory management
-(EMKSetController *)initWithSet:(NSSet *)objects sortKeyPaths:(NSArray *)sortKeyPaths secondaryKeyPaths:(NSArray *)secondaryKeyPaths sectionNameKeyPath:(NSString *)sectionNameKeyPath
{
    self = [super init];
    if (!self) return nil;

    
    
    //1. Create sort descriptors
    NSMutableArray *sortKeyPathsCopy = [NSMutableArray arrayWithCapacity:[sortKeyPaths count]];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithCapacity:[sortKeyPaths count]];
    for (NSString *keyPath in sortKeyPaths)
    {
        [sortKeyPathsCopy addObject:[[keyPath copy] autorelease]];
        [sortDescriptors addObject:[[[NSSortDescriptor alloc] initWithKey:keyPath ascending:YES] autorelease]];
    }
    _sortKeyPaths = [sortKeyPathsCopy retain];
    _sortDescriptors = [sortDescriptors retain];

    
    //2. store secondaryKeyPaths
    NSMutableArray *secondaryKeyPathsCopy = [NSMutableArray arrayWithCapacity:[secondaryKeyPaths count]];
    for (NSString *secondaryKeyPath in secondaryKeyPaths) 
    {
        [secondaryKeyPathsCopy addObject:[[secondaryKeyPath copy] autorelease]];
    }
    _secondaryKeyPaths = ([secondaryKeyPathsCopy count]) ? [secondaryKeyPathsCopy retain] : nil;
    
    
    //3. Sort, store and observe objects
    _objects = (objects) ? [[objects sortedArrayUsingDescriptors:_sortDescriptors] retain] : [NSArray new];
    for (id object in _objects)
    {
        [self observeObject:object];
    }
    

    //4. Create sections
    NSArray *sections = [NSArray array];
    
    _sectionNameKeyPath = [sectionNameKeyPath copy];        
    if (_sectionNameKeyPath)
    {
        EMKSetControllerSection *currentSection = nil;
        NSString *nextSectionName = nil;            
        
        for (id object in _objects)
        {
            nextSectionName = [object valueForKeyPath:_sectionNameKeyPath];
            if (!currentSection || ![nextSectionName isEqualToString:currentSection.name])
            {
                currentSection = [[[EMKSetControllerSection alloc] initWithName:nextSectionName] autorelease];
                sections = [sections arrayByAddingObject:currentSection];
            }
            
            [currentSection setObjects:[currentSection.objects arrayByAddingObject:object]];                
        }
       
        //for (id<EMKSetControllerSectionInfo>section in _sections) NSLog(@"%@: %@", section.name, section.objects);
    }
    else
    {
        EMKSetControllerSection *singleSection = [[[EMKSetControllerSection alloc] initWithName:nil] autorelease];        
        [singleSection setObjects:_objects];
        sections = [NSArray arrayWithObject:singleSection];
    }
    
    _sections = [sections retain];


    
    return self;
}




-(void)dealloc
{
    for (id object in _objects)
    {
        [self unobserveObject:object];
    }
    
    [_objects release];
    [_sectionNameKeyPath release];
    [_sortDescriptors release];    
    [_sortKeyPaths release];        
    [_sections release];
    
    
    [super dealloc];
}





#pragma mark properties
@synthesize objects = _objects;
@synthesize secondaryKeyPaths = _secondaryKeyPaths;
@synthesize sectionNameKeyPath = _sectionNameKeyPath;
@synthesize sortDescriptors = _sortDescriptors;
@synthesize sortKeyPaths = _sortKeyPaths;
@synthesize delegate = _delegate;
@synthesize sections = _sections;




//The default implementation returns the array created by calling sectionIndexTitleForSectionName: on all the known sections. 
//You should override this method if you want to return a different array for the section index.            
-(NSArray *)sectionIndexTitles
{
    NSArray *sectionIndexTitles = [NSArray array];
    for (id<EMKSetControllerSectionInfo> section in self.sections)
    {
        sectionIndexTitles = [sectionIndexTitles arrayByAddingObject: [self sectionIndexTitleForSectionName:section.name]];
    }
    
    return sectionIndexTitles;
}



#pragma mark --
#pragma mark public methods
//object access methods
-(NSIndexPath *)indexPathForObject:(id)object
{
    NSArray *sections = self.sections;
    
    for (int sectionIndex = 0; sectionIndex < [sections count]; sectionIndex++)
    {
        EMKSetControllerSection *section = [sections objectAtIndex:sectionIndex];
        int rowIndex = [section.objects indexOfObject:object];
        if (rowIndex != NSNotFound)
        {
            return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
        }
    }

    return nil;
}




-(id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.sections objectAtIndex:indexPath.section] objects] objectAtIndex:indexPath.row];
}




//section methods
- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex
{
    //TODO: What the hell does this do?!
    //    //The section number for the given section title and index in the section index
    return NSNotFound;
}




- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName
{
    //The default implementation returns the capitalized first letter of the section name.
    return [sectionName length] ? [[sectionName substringToIndex:1] uppercaseString] : @"";
}






//objects manipulation methods


//TODO: KVO all objects for ANY changes?
    //KVO for changes to sort keys?
     //Replace sortDescriptors with sortKeyPaths and observe each key path
-(void)addObjects:(NSSet *)newObjects removeObjects:(NSSet *)expiredObjects
{
    BOOL didInvokeWillChangeContent = NO;
    

    //0. do we actually need to add these object?
    NSPredicate *cleanExpiredObjectsPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@) || !(SELF IN %@)", self.objects, newObjects];
    NSSet *cleanExpiredObjects = [expiredObjects filteredSetUsingPredicate:cleanExpiredObjectsPredicate];
    
    NSPredicate *cleanNewObjectsPredicate = [NSPredicate predicateWithFormat:@"!(SELF IN %@)", self.objects];
    NSSet *cleanNewObjects = [newObjects filteredSetUsingPredicate:cleanNewObjectsPredicate];
    
    NSArray *confirmedSectionNames = (self.sectionNameKeyPath) ? [cleanNewObjects valueForKeyPath:[@"@distinctUnionOfObjects." stringByAppendingString:self.sectionNameKeyPath]] : [NSArray array];

    const int changeCount = [cleanNewObjects count] + [cleanExpiredObjects count];
    NSMutableArray *sectionChangeDescriptions = [NSMutableArray arrayWithCapacity:changeCount];    
    NSMutableArray *objectChangeDescriptions = [NSMutableArray arrayWithCapacity:changeCount];        
    
    
    //Remove objects
    NSEnumerator *reversedExpiredObjects = [[cleanExpiredObjects sortedArrayUsingDescriptors:self.sortDescriptors] reverseObjectEnumerator];
    for (id object in reversedExpiredObjects)
    {
        //1. tell the delegate we're will be changing        
        if (!didInvokeWillChangeContent && [(NSObject *)self.delegate respondsToSelector:@selector(setControllerWillChangeContent:)])
        {
            [self.delegate setControllerWillChangeContent:self];
            didInvokeWillChangeContent = YES;
        }
        
        //2. get the section for the object
        NSString *sectionName = (self.sectionNameKeyPath) ? [object valueForKeyPath:self.sectionNameKeyPath] : nil;
        EMKSetControllerSection *section = [self sectionWithName:sectionName];
        int sectionIndex = [self.sections indexOfObject:section];
        
        //3. remove the object
        int rowIndex = [section.objects indexOfObject:object];
        [objectChangeDescriptions addObject:[EMKSetControllerObjectChangeDescription objectChangeDescriptionWithObject:object preIndex:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex] postIndex:nil changeType:EMKSetControllerChangeDelete]];
        NSPredicate *removeObjectPredicate = [NSPredicate predicateWithFormat:@"self != %@", object];
        [section setObjects:[section.objects filteredArrayUsingPredicate:removeObjectPredicate]];
        _objects = [[self.objects filteredArrayUsingPredicate:removeObjectPredicate] retain];        
        [self unobserveObject:object];        
        
        //4. if the section is empty and will not be required when adding objects, then remove it
        if ([section.objects count] == 0 && ![confirmedSectionNames containsObject:section.name])
        {
            NSPredicate *removeSectionPredicate = [NSPredicate predicateWithFormat:@"SELF != %@", section];
            _sections = [[self.sections filteredArrayUsingPredicate:removeSectionPredicate] retain];
            [sectionChangeDescriptions addObject:[EMKSetControllerSectionChangeDescription sectionChangeDescriptionWithSection:section index:sectionIndex changeType: EMKSetControllerChangeDelete]];
        }
    }
    

    
    //Add objects
    for (id object in [cleanNewObjects sortedArrayUsingDescriptors:self.sortDescriptors]) 
    {
        //1. tell the delegate we're will be changing
        if (!didInvokeWillChangeContent && [(NSObject *)self.delegate respondsToSelector:@selector(setControllerWillChangeContent:)])
        {
            [self.delegate setControllerWillChangeContent:self];
            didInvokeWillChangeContent = YES;
        }
        
        //2. get section exists for the object...
        NSString *sectionName = (self.sectionNameKeyPath) ? [object valueForKeyPath:self.sectionNameKeyPath] : nil;
        EMKSetControllerSection *section = [self sectionWithName:sectionName];
        int sectionIndex = [self.sections indexOfObject:section];
        
        //3. ...if the section doesn't exist, create a new section
        if (!section)
        {
            section = [[[EMKSetControllerSection alloc] initWithName:sectionName] autorelease];
            NSSortDescriptor *sortBySectionName = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
            _sections = [[[self.sections arrayByAddingObject:section] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortBySectionName]] retain];
            sectionIndex = [self.sections indexOfObject:section];
            [sectionChangeDescriptions addObject:[EMKSetControllerSectionChangeDescription sectionChangeDescriptionWithSection:section index:sectionIndex changeType:EMKSetControllerChangeInsert]];
        }
        
        //4. add the object to the added section objects
        _objects = [[[self.objects arrayByAddingObject:object] sortedArrayUsingDescriptors:self.sortDescriptors] retain];
        [section setObjects:[[section.objects arrayByAddingObject:object] sortedArrayUsingDescriptors:self.sortDescriptors]];
        int rowIndex = [section.objects indexOfObject:object];
        [objectChangeDescriptions addObject:[EMKSetControllerObjectChangeDescription objectChangeDescriptionWithObject:object preIndex:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex] postIndex:nil changeType:EMKSetControllerChangeInsert]];
        [self observeObject:object];
    }
    
    
        
    
    if ([objectChangeDescriptions count])
    {
        [self invokePostUpdateDelegateMethodsWithSectionChangeDescriptions:sectionChangeDescriptions objectChangeDescriptions:objectChangeDescriptions];
    }
    
}




-(void)addObject:(id)object
{
    [self addObjects:[NSSet setWithObject:object] removeObjects:nil];
}





-(void)removeObject:(id)object
{
    [self addObjects:nil removeObjects:[NSSet setWithObject:object]];
}
     
     



     
-(void)setObjects:(NSSet *)objects
{
    //We assume that all current objects are expired unless proven otherwise
    NSMutableSet *currentObjects, *expiredObjects;
    currentObjects = expiredObjects = [NSMutableSet setWithArray:self.objects];
    
    NSMutableSet *newObjects = [NSMutableSet setWithCapacity:[objects count]];

    for (id object in objects)
    {
        if ([currentObjects containsObject:object])
        {
            [expiredObjects removeObject:object];
        }
        else
        {
            [newObjects addObject:object];
        }
    }
    
    [self addObjects:newObjects removeObjects:expiredObjects];
}


#pragma mark section fetching
-(EMKSetControllerSection *)sectionWithName:(NSString *)sectionName
{
    if (self.sectionNameKeyPath == nil)
    {
        return [self.sections lastObject];
    }
    
    NSPredicate *sectionWithNamePredicate = [NSPredicate predicateWithFormat:@"name == %@", sectionName];
    
    return [[self.sections filteredArrayUsingPredicate:sectionWithNamePredicate] lastObject];
    
}





#pragma mark delegate invocation (private)
-(void)invokePostUpdateDelegateMethodsWithSectionChangeDescriptions:(NSArray *)sectionChangeDescriptions objectChangeDescriptions:(NSArray *)objectChangeDescriptions
{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(setController:didChangeObject:atIndexPath:forChangeType:newIndexPath:)])
    {
        //delete objects        
        for (EMKSetControllerObjectChangeDescription *deleteObjectChangeDescription in [objectChangeDescriptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"changeType == %i", EMKSetControllerChangeDelete]])
        {
            [self.delegate setController:self didChangeObject:deleteObjectChangeDescription.object atIndexPath:deleteObjectChangeDescription.preIndexPath forChangeType:EMKSetControllerChangeDelete newIndexPath:nil];
        }
    }
    
    
    if ([(NSObject *)self.delegate respondsToSelector:@selector(setController:didChangeSection:atIndex:forChangeType:)])
    {
        //delete sections
        for (EMKSetControllerSectionChangeDescription *sectionChangeDescription in [sectionChangeDescriptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"changeType == %i", EMKSetControllerChangeDelete]])
        {
            [self.delegate setController:self didChangeSection:sectionChangeDescription.section atIndex:sectionChangeDescription.index forChangeType:EMKSetControllerChangeDelete];
        }

        //insert sections        
        for (EMKSetControllerSectionChangeDescription *sectionChangeDescription in [sectionChangeDescriptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"changeType == %i", EMKSetControllerChangeInsert]])
        {
            [self.delegate setController:self didChangeSection:sectionChangeDescription.section atIndex:sectionChangeDescription.index forChangeType:EMKSetControllerChangeInsert];
        }
    }
    
    
    if ([(NSObject *)self.delegate respondsToSelector:@selector(setController:didChangeObject:atIndexPath:forChangeType:newIndexPath:)])
    {
        //update objects        
        for (EMKSetControllerObjectChangeDescription *insertObjectChangeDescription in [objectChangeDescriptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"changeType == %i", EMKSetControllerChangeUpdate]])
        {
            [self.delegate setController:self didChangeObject:insertObjectChangeDescription.object atIndexPath:insertObjectChangeDescription.preIndexPath forChangeType:EMKSetControllerChangeUpdate newIndexPath:insertObjectChangeDescription.postIndexPath];
        }
        
        
        //move objects        
        for (EMKSetControllerObjectChangeDescription *insertObjectChangeDescription in [objectChangeDescriptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"changeType == %i", EMKSetControllerChangeMove]])
        {
            [self.delegate setController:self didChangeObject:insertObjectChangeDescription.object atIndexPath:insertObjectChangeDescription.preIndexPath forChangeType:EMKSetControllerChangeMove newIndexPath:insertObjectChangeDescription.postIndexPath];
        }
        
        
        //insert objects        
        for (EMKSetControllerObjectChangeDescription *insertObjectChangeDescription in [objectChangeDescriptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"changeType == %i", EMKSetControllerChangeInsert]])
        {
            [self.delegate setController:self didChangeObject:insertObjectChangeDescription.object atIndexPath:insertObjectChangeDescription.preIndexPath forChangeType:EMKSetControllerChangeInsert newIndexPath:nil];
        }
    }    
    

    if ([(NSObject *)self.delegate respondsToSelector:@selector(setControllerDidChangeContent:)])
    {
        //finalize        
        [self.delegate setControllerDidChangeContent:self];
    }
}





#pragma mark object observation methods (private)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"Change at %@ of %@", keyPath, object);
    
    if ([self.secondaryKeyPaths containsObject:keyPath]) //TODO: it wouldbe cheaper to use context
    {
        [self observeValueForSecondaryKeyPath:keyPath ofObject:object];
    }
    else
    {
        [self observeValueForSortKeyPath:keyPath ofObject:object];
    }


}





-(void)observeValueForSecondaryKeyPath:(NSString *)keyPath ofObject:(id)object
{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(setControllerWillChangeContent:)])
    {
        [self.delegate setControllerWillChangeContent:self];
    }    
    
    NSIndexPath *preIndexPath = [self indexPathForObject:object];
    EMKSetControllerObjectChangeDescription *objectChangeDescription = [EMKSetControllerObjectChangeDescription objectChangeDescriptionWithObject:object preIndex:preIndexPath postIndex:nil changeType:EMKSetControllerChangeUpdate];
    
    [self invokePostUpdateDelegateMethodsWithSectionChangeDescriptions:nil objectChangeDescriptions:[NSArray arrayWithObject:objectChangeDescription]];
}






-(void)observeValueForSortKeyPath:(NSString *)keyPath ofObject:(id)object
{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(setControllerWillChangeContent:)])
    {
        [self.delegate setControllerWillChangeContent:self];
    }    
    
    
    NSIndexPath *preIndexPath = [self indexPathForObject:object];
    EMKSetControllerSection *preSection = [self.sections objectAtIndex:preIndexPath.section];
    NSString *postSectionName = (self.sectionNameKeyPath) ? [object valueForKey:self.sectionNameKeyPath] : nil;

    NSMutableArray *sectionChangeDescriptions = [NSMutableArray arrayWithCapacity:2];
    //if the object is in the same section, just resort the section
    if ([preSection.name isEqualToString:postSectionName])
    {
        [preSection setObjects:[preSection.objects sortedArrayUsingDescriptors:self.sortDescriptors]];
    }
    else
    {
        //remove object from preSection
        [preSection  setObjects:[preSection.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", object]]];
        if ([preSection.objects count] == 0)
        {
            _sections = [[self.sections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", preSection]] retain];
            [sectionChangeDescriptions addObject:[EMKSetControllerSectionChangeDescription sectionChangeDescriptionWithSection:preSection index:preIndexPath.section changeType:EMKSetControllerChangeDelete]];
        }
        
        EMKSetControllerSection *postSection = [self sectionWithName:postSectionName];
        if (postSection == nil)
        {
            //create new section and added to _sections and sort
            postSection = [[[EMKSetControllerSection alloc] initWithName:postSectionName] autorelease];
            NSSortDescriptor *sortBySectionName = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
            _sections = [[[self.sections arrayByAddingObject:postSection] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortBySectionName]] retain];
            int postSectionIndex = [self.sections indexOfObject:postSection];
            
            [sectionChangeDescriptions addObject:[EMKSetControllerSectionChangeDescription sectionChangeDescriptionWithSection:postSection index:postSectionIndex changeType:EMKSetControllerChangeInsert]];
        }
        
        //add object to postSection
        [postSection setObjects:[[postSection.objects arrayByAddingObject:object] sortedArrayUsingDescriptors:self.sortDescriptors]];
    }
    
    //add object to objects
    _objects = [[self.objects sortedArrayUsingDescriptors:self.sortDescriptors] retain];

    
    //create the object change description
    NSIndexPath *postIndexPath = [self indexPathForObject:object];
    EMKSetControllerObjectChangeDescription *objectChangeDescription = [EMKSetControllerObjectChangeDescription objectChangeDescriptionWithObject:object preIndex:preIndexPath postIndex:postIndexPath changeType:EMKSetControllerChangeMove];

    //tell the delegate what we did
    [self invokePostUpdateDelegateMethodsWithSectionChangeDescriptions:sectionChangeDescriptions objectChangeDescriptions:[NSArray arrayWithObject:objectChangeDescription]];
}





-(void)observeObject:(id)object
{
    for (NSString *keyPath in self.sortKeyPaths)
    {
        [object addObserver:self forKeyPath:keyPath options:0 context:NULL];
    }
    
    for (NSString *keyPath in self.secondaryKeyPaths)
    {
        [object addObserver:self forKeyPath:keyPath options:0 context:NULL];
    }
}





-(void)unobserveObject:(id)object
{
    for (NSString *keyPath in self.sortKeyPaths)
    {
        [object removeObserver:self forKeyPath:keyPath];
    }

    for (NSString *keyPath in self.secondaryKeyPaths)
    {
        [object removeObserver:self forKeyPath:keyPath];
    }
    
}


@end
