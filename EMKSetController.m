//
//  EMKSetController.m
//  Jot
//
//  Created by Benedict Cohen on 06/01/2011.
//  Copyright 2011 Electric Muffin Kitchen. All rights reserved.
//

#import "EMKSetController.h"

@interface EMKSetControllerSection : NSObject <EMKSetControllerSectionInfo>
{
    NSString *_indexTitle; 
    NSString *_name;
    NSArray *_objects;
}

-(id)initWithName:(NSString *)name;
-(void)setObjects:(NSArray *)objects;
-(void)setIndexTitle:(NSString *)indexTitle;

@end

@implementation EMKSetControllerSection

#pragma mark memory management
-(id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        _name = name;
        _objects = [NSArray new];
    }
    
    return self;
}


-(void)dealloc
{
    [_indexTitle release];    
    [_name release];
    [_objects release];
    
    [super dealloc];
}



#pragma mark properties
@synthesize indexTitle = _indexTitle;
@synthesize name = _name;
@synthesize objects = _objects;



-(NSUInteger)numberOfObjects
{
    return [self.objects count];
}





#pragma mark methods
-(void)setIndexTitle:(NSString *)indexTitle
{
    [_indexTitle release];
    _indexTitle = [indexTitle retain];
}




-(void)setObjects:(NSArray *)objects
{
    [_objects release];
    
    _objects = (objects) ? [objects retain] : [NSArray new];
    NSLog(@"section.objects: %@", _objects);
}


@end






@interface EMKSetController ()

@property(nonatomic, retain) NSArray *sortDescriptors;

@end





@implementation EMKSetController

#pragma mark memory management
-(EMKSetController *)initWithSet:(NSSet *)objects sortKeyPaths:(NSArray *)sortKeyPaths sectionNameKeyPath:(NSString *)sectionNameKeyPath
{
    self = [super init];
    if (!self) return nil;

    
    
    //1. Create sort descriptors
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithCapacity:[sortKeyPaths count]];
    for (NSString *keyPath in sortKeyPaths)
    {
        [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:keyPath ascending:YES]];
    }
    _sortDescriptors = [sortDescriptors retain];

    
    
    //2. Sort and store objects
    _objects = (objects) ? [[objects sortedArrayUsingDescriptors:_sortDescriptors] retain] : [NSArray new];
    //TODO: KVO the objects

    

    //3. Create sections
    _sectionNameKeyPath = [sectionNameKeyPath copy];        
    
    if (_sectionNameKeyPath)
    {
        NSArray *sections = [NSArray array];
        
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
        
        _sections = [sections retain];
       
        for (id<EMKSetControllerSectionInfo>section in _sections) NSLog(@"%@: %@", section.name, section.objects);
    }


    
    return self;
}




-(void)dealloc
{
    [_objects release];
    [_sectionNameKeyPath release];
    [_sortDescriptors release];    
    [_sortKeyPaths release];        
    
    [super dealloc];
}





#pragma mark properties
@synthesize objects = _objects;
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
    for (NSString *sectionName in _sectionNames)
    {
        sectionIndexTitles = [sectionIndexTitles arrayByAddingObject: [self sectionIndexTitleForSectionName:sectionName]];
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
        NSArray *section = [sections objectAtIndex:sectionIndex];
        int rowIndex = [section indexOfObject:object];
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
    BOOL didIssueWillChangeContent = NO;
    
    
    
    //Add objects
    for (id object in newObjects) 
    {
        if ([self.objects containsObject:object] || [expiredObjects containsObject:object])
        {
            continue; //me thinks this check could be expensive
        }
        
        //tell the delegate we're will be changing
        if (!didIssueWillChangeContent && [(NSObject *)self.delegate respondsToSelector:@selector(setControllerWillChangeContent:)])
        {
            [self.delegate setControllerWillChangeContent:self];
            didIssueWillChangeContent = YES;
        }
        
        
        //check if a section exists for the object...
        NSString *sectionName = [object valueForKeyPath:self.sectionNameKeyPath];
        EMKSetControllerSection *section = [[self.sections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", sectionName]] lastObject];
        int sectionIndex = [self.sections indexOfObject:section];
        
        //...if not, create a new section
        if (!section)
        {
            section = [[[EMKSetControllerSection alloc] initWithName:sectionName] autorelease];
            _sections  = [[[self.sections arrayByAddingObject:section] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]] retain];
            sectionIndex = [self.sections indexOfObject:section];
            
            if ([(NSObject *)self.delegate respondsToSelector:@selector(setController:didChangeSection:atIndex:forChangeType:)])
            {
                [self.delegate setController:self didChangeSection:section atIndex:sectionIndex forChangeType:EMKSetControllerChangeInsert];
            }
        }
        
        
        
        //insert the object into the section
        //TODO: Observe object for sortKeyPaths and secondaryKeyPaths
        [section setObjects:[[section.objects arrayByAddingObject:object] sortedArrayUsingDescriptors:self.sortDescriptors]];
        _objects = [[[self.objects arrayByAddingObject:object] sortedArrayUsingDescriptors:self.sortDescriptors] retain];        
        int rowIndex = [section.objects indexOfObject:object];
        
        
        if ([(NSObject *)self.delegate respondsToSelector:@selector(setController:didChangeObject:atIndexPath:forChangeType:newIndexPath:)])
        {
            [self.delegate setController:self didChangeObject:object atIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex] forChangeType:EMKSetControllerChangeInsert newIndexPath:nil];
        }
    }
    
    
    
    
    
    //Remove objects
    for (id object in expiredObjects)
    {
        if (![self.objects containsObject:object]) continue; //me thinks this check could be expensive
    
        if (!didIssueWillChangeContent && [(NSObject *)self.delegate respondsToSelector:@selector(setControllerWillChangeContent:)])
        {
            [self.delegate setControllerWillChangeContent:self];
            didIssueWillChangeContent = YES;
        }
        
        //1. get the section for the object
        NSString *sectionName = [object valueForKeyPath:self.sectionNameKeyPath];
        EMKSetControllerSection *section = [[self.sections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", sectionName]] lastObject];
        int sectionIndex = [self.sections indexOfObject:section];
        
        
        //2. remove the object
        int rowIndex = [section.objects indexOfObject:object];
        NSPredicate *removeObjectPredicate = [NSPredicate predicateWithFormat:@"self != %@", object];
        [section setObjects:[section.objects filteredArrayUsingPredicate:removeObjectPredicate]];
        _objects = [[self.objects filteredArrayUsingPredicate:removeObjectPredicate] retain];
        
        if ([(NSObject *)self.delegate respondsToSelector:@selector(setController:didChangeObject:atIndexPath:forChangeType:newIndexPath:)])
        {
            [self.delegate setController:self didChangeObject:object atIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex] forChangeType:EMKSetControllerChangeDelete newIndexPath:nil];
        }
        
        
        //3. check if section is empty
        if ([section.objects count] == 0)
        {
            NSPredicate *removeSectionPredicate = [NSPredicate predicateWithFormat:@"self != %@", section];
            _sections = [[_sections filteredArrayUsingPredicate:removeSectionPredicate] retain];
            
            //if yes: remove section
            if ([(NSObject *)self.delegate respondsToSelector:@selector(setController:didChangeSection:atIndex:forChangeType:)])
            {
                [self.delegate setController:self didChangeSection:section atIndex:sectionIndex forChangeType:EMKSetControllerChangeDelete];
            }
        }
    }

    
    if (didIssueWillChangeContent && [(NSObject *)self.delegate respondsToSelector:@selector(setControllerDidChangeContent:)])
    {
        [self.delegate setControllerDidChangeContent:self];
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


@end
