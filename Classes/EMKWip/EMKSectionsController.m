//
//  EMKSectionController.m
//  SectionKeyPathDemo
//
//  Created by Benedict Cohen on 04/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EMKSectionsController.h"


@interface EMKSectionsController ()
@property(readwrite, nonatomic, retain) NSIndexSet *availableIndexes;
@property(readwrite, nonatomic, retain) NSArray *availableSectionNames;

@property(readwrite, nonatomic, retain) NSArray *arrangedSections;
@property(readwrite, nonatomic, retain) NSArray *arrangedSectionIndexTitles;


@property(readwrite, nonatomic, retain) EMKSectionsController *sectionsControllerPriorToUpdate;
@property(readwrite, nonatomic, assign) BOOL isArchive;
@property(readwrite, nonatomic, assign) BOOL hasChangesPending;
@property(readwrite, nonatomic, assign) BOOL isUpdating;
@property(readwrite, nonatomic, retain) id updateContext;
@property(readwrite, nonatomic, assign) int avalibleDelegateMethods;

-(void)calculateArrangedSections;
-(void)invalidateArrangedSections;

-(NSString *)defaultSectionIndexTitleForSectionName:(NSString *)sectionName;
@end


enum EMKSectionControllerDelegateMethods
{
    EMKSectionsControllerDelegateSectionNameForSectionMethod  = 1 << 0,
    
    EMKSectionsControllerDelegateSectionIndexTitleForSectionMethod = 1 << 1,    
    EMKSectionsControllerDelegateSectionIndexTitleForStaticSectionNameMethod = 1 << 2,    
    
    EMKSectionsControllerDelegateObjectAtIndexOfSectionMethod = 1 << 3,
};




@implementation EMKSectionsController

#pragma mark class methods



#pragma mark properties
//In
@synthesize avalibleDelegateMethods = avalibleDelegateMethods_;
@synthesize delegate = delegate_;
-(void)setDelegate:(id<EMKSectionControllerDelegate>)delegate
{
    if (delegate == delegate_) return;

    [self invalidateArrangedSections];    
    
    delegate_ = delegate;
    
    int avalibleDelegateMethods = 0;
    if ([delegate respondsToSelector:@selector(sectionController:sectionNameForSection:)])
    {
        avalibleDelegateMethods = avalibleDelegateMethods | EMKSectionsControllerDelegateSectionNameForSectionMethod;
    }
    else
    {
        NSLog(@"WARNING: %@(%p) does not respond to sectionController:sectionIndexTitleForSection:", NSStringFromClass([delegate class]), delegate);
    }
    
    if ([delegate respondsToSelector:@selector(sectionController:sectionIndexTitleForSection:)])
    {
        avalibleDelegateMethods = avalibleDelegateMethods | EMKSectionsControllerDelegateSectionIndexTitleForSectionMethod;
    }

    if ([delegate respondsToSelector:@selector(sectionController:sectionIndexTitleForStaticSectionName:)])
    {
        avalibleDelegateMethods = avalibleDelegateMethods | EMKSectionsControllerDelegateSectionIndexTitleForStaticSectionNameMethod;
    }

    if ([delegate respondsToSelector:@selector(sectionController:objectAtIndex:ofSection:)])
    {
        avalibleDelegateMethods = avalibleDelegateMethods | EMKSectionsControllerDelegateObjectAtIndexOfSectionMethod;
    }


    self.avalibleDelegateMethods = avalibleDelegateMethods;
}



@synthesize hidesIndexTitleForStaticSectionNamesAbscentFromSections = hidesIndexTitleForStaticSectionNamesAbscentFromSections_;
-(void)setHidesIndexTitleForStaticSectionNamesAbscentFromSections:(BOOL)hidesIndexTitleForStaticSectionNamesAbscentFromSections
{
    if (hidesIndexTitleForStaticSectionNamesAbscentFromSections == hidesIndexTitleForStaticSectionNamesAbscentFromSections_) return;
    
    [self invalidateArrangedSections];
    
    hidesIndexTitleForStaticSectionNamesAbscentFromSections_ = hidesIndexTitleForStaticSectionNamesAbscentFromSections;
}


@synthesize staticSectionNames = staticSectionNames_;
-(void)setStaticSectionNames:(NSArray *)staticSectionNames
{
    if (staticSectionNames == staticSectionNames_) return;

    [self invalidateArrangedSections];    
    
    [staticSectionNames_ release];
    staticSectionNames_ = [staticSectionNames copy];
}


@synthesize sectionNameComparator = sectionNameComparator_;
-(NSComparator)sectionNameComparator
{
    if (sectionNameComparator_) return sectionNameComparator_;
    
    NSComparator comparator = ^(id obj1, id obj2)
    {
        //TODO: Check for retain cycles
        NSArray *staticSectionNames = self.staticSectionNames;
        NSUInteger index1 = [staticSectionNames indexOfObject:obj1];
        NSUInteger index2 = [staticSectionNames indexOfObject:obj2];

        
        if (index1 != NSNotFound)
        {
            if (index2 != NSNotFound)
            {
                //Both are in staticSectionNames
                return (index1 < index2) ? NSOrderedAscending : NSOrderedDescending;
            }
            else
            {
                //Only index1 is in staticSectionNames
                return NSOrderedAscending;
            }
        }
        else
        {
            if (index2 != NSNotFound)
            {
                //Only index2 is in staticSectionNames
                return NSOrderedDescending;
            }
            else
            {
                //neither are in staticSectionNames
                return [(NSString *)obj1 localizedStandardCompare:obj2];
            }
        }
        
        
        return 0;
    };
    
    self.sectionNameComparator = comparator;
    
    return sectionNameComparator_;
}


@synthesize sections = sections_;
-(void)setSections:(NSArray *)sections
{
    if (sections == sections_) return;
    
    [self invalidateArrangedSections];    

    [sections_ release];
    sections_ = [sections copy];
}


@synthesize staticSectionNameForIndexTitleHeadSelectionSnapping = staticSectionNameForIndexTitleHeadSelectionSnapping_;
-(void)setStaticSectionNameForIndexTitleHeadSelectionSnapping:(NSString *)staticSectionNameForIndexTitleHeadSelectionSnapping
{
    if (staticSectionNameForIndexTitleHeadSelectionSnapping == staticSectionNameForIndexTitleHeadSelectionSnapping_) return;
    
    [self invalidateArrangedSections];

    [staticSectionNameForIndexTitleHeadSelectionSnapping_ release];
    staticSectionNameForIndexTitleHeadSelectionSnapping_ = [staticSectionNameForIndexTitleHeadSelectionSnapping copy];
}



//Out
@synthesize availableIndexes = availableIndexes_; //private
@synthesize availableSectionNames = arrangedSectionNames_; //private
-(NSArray *)availableSectionNames
{
    [self calculateArrangedSections];
    return arrangedSectionNames_;
}


@synthesize arrangedSections = arrangedSections_;
-(NSArray *)arrangedSections
{
    [self calculateArrangedSections];
    return arrangedSections_;
}

@synthesize arrangedSectionIndexTitles = arrangedSectionIndexTitles_;
-(NSArray *)arrangedSectionIndexTitles
{
    [self calculateArrangedSections];
    return arrangedSectionIndexTitles_;
}




//Updating
@synthesize isUpdating = isUpdating_;
@synthesize isArchive = isArchive_;
@synthesize updateContext = updateContext_;
@synthesize hasChangesPending = hasChangesPending_;
-(BOOL)hasChangesPending
{
    if (!self.isUpdating)
    {
        NSLog(@"WARNING: Accessed hasChangesPending while not updating");
        return NO;
    }
    
    return hasChangesPending_;
}



@synthesize sectionsControllerPriorToUpdate = sectionsControllerPriorToUpdate_;
-(EMKSectionsController *)sectionsControllerPriorToUpdate
{
    if (!self.isUpdating)
    {
        NSLog(@"WARNING: Accessed sectionsControllerPriorToUpdate while not updating");
        return nil;
    }
    
    return sectionsControllerPriorToUpdate_;
}



-(void)beginUpdate:(id)context
{
    if (self.isUpdating)
    {
		NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Attempted to beginUpdate before ending pervious update", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        return;
    }
    
    //update self
    self.updateContext = context;
    self.isUpdating = YES;
    
    //create clone
    EMKSectionsController *clone = [[self copy] autorelease];
    clone.isUpdating = NO;
    clone.isArchive = YES;
    self.sectionsControllerPriorToUpdate = clone;
}



-(void)endUpdate
{
    self.isUpdating = NO;
    self.hasChangesPending = NO;
    self.updateContext = nil;    
    self.sectionsControllerPriorToUpdate = nil;
}






#pragma mark memory managment
-(id)copy
{
    EMKSectionsController *clone = [[self class] new];
    clone->arrangedSectionIndexTitles_ = [self.arrangedSectionIndexTitles copy];
    clone->arrangedSections_ = [self.arrangedSections copy];
    clone->availableIndexes_ = [self.availableIndexes copy];
    clone.isArchive = self.isArchive;
    clone.isUpdating = self.isUpdating;
    clone.updateContext = self.updateContext;
    
    clone->delegate_ = self.delegate;
    clone->hidesIndexTitleForStaticSectionNamesAbscentFromSections_ = self.hidesIndexTitleForStaticSectionNamesAbscentFromSections;
    clone->staticSectionNames_ = [self.staticSectionNames copy];
    clone->sections_ = [self.sections copy];
    clone->staticSectionNameForIndexTitleHeadSelectionSnapping_ = [self.staticSectionNameForIndexTitleHeadSelectionSnapping copy];
    
    //Out
    clone->arrangedSections_ = [self.arrangedSections copy];
    
    return clone;
}



-(void)dealloc
{
    [arrangedSectionNames_ release];
    [staticSectionNames_ release];
    [sections_ release];
    [arrangedSectionIndexTitles_ release];
    [arrangedSections_ release];
    [availableIndexes_ release];
    [updateContext_ release];
    
    [super dealloc];
}



#pragma mark arrangedSections calculation
//TODO: Rename these so that the name reflects the fact that the invalidate arrangedSectionIndexTitles and arrangedSections.
-(void)invalidateArrangedSections
{
    if (self.isUpdating)
    {
        self.hasChangesPending = YES;
        //TODO: ensure that ALL setters trigger invalidateArrangedSections
    }
    
    self.arrangedSections = nil;
}



-(void)calculateArrangedSections
{
    BOOL shouldCalculateArrangedSections = arrangedSections_ == nil;
    
    if (shouldCalculateArrangedSections == NO) return;

    NSUInteger sectionCount = [self.sections count];
    id<EMKSectionControllerDelegate> delegate = self.delegate;

    
    //1. store the sections so that we can efficently access them by sectionName
    NSMutableDictionary *sectionsBySectionName = [NSMutableDictionary dictionaryWithCapacity:sectionCount];
    for (id section in self.sections)
    {
        NSString *sectionName = [delegate sectionController:self sectionNameForSection:section];
        [sectionsBySectionName setObject:section forKey:sectionName];
    }
    

    //get the sectionNames for all the indexesTitles
    NSArray *allSectionNames = (self.hidesIndexTitleForStaticSectionNamesAbscentFromSections) ? 
                                 [sectionsBySectionName allKeys] 
                               : [[NSSet setWithArray:[[sectionsBySectionName allKeys] arrayByAddingObjectsFromArray:self.staticSectionNames]] allObjects];
    NSArray *arrangedSectionNames = [allSectionNames sortedArrayUsingComparator:self.sectionNameComparator];
    
    NSMutableArray *arrangedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    NSMutableArray *arrangedSectionIndexTitles = [NSMutableArray arrayWithCapacity:sectionCount];

    NSMutableIndexSet *availableIndexes = [NSMutableIndexSet indexSet];
    NSMutableArray *availableSectionNames = [NSMutableArray arrayWithCapacity:sectionCount];
    

    int sectionIndex = 0;
    for (NSString *sectionName in arrangedSectionNames)
    {
        id section = [sectionsBySectionName objectForKey:sectionName];

        if (section)
        {
            [arrangedSectionIndexTitles addObject:[self sectionIndexTitleForSection:section]];
            [arrangedSections addObject:section];
            
            [availableIndexes addIndex:sectionIndex];
            [availableSectionNames addObject:sectionName];
        }
        else
        {
            [arrangedSectionIndexTitles addObject:[self sectionIndexTitleForStaticSectionName:sectionName]];            
        }
        
        sectionIndex++;
    }
    
    

    //done!
    self.arrangedSections = arrangedSections;
    self.arrangedSectionIndexTitles = arrangedSectionIndexTitles;
    
    self.availableIndexes = availableIndexes;
    self.availableSectionNames = availableSectionNames;
}





#pragma mark data access
//table view related information about sections
-(NSUInteger)sectionForSectionIndexTitleAtIndex:(NSUInteger)sectionIndex
{
    //if the index only shows avaible sections then it's a simple 1 to 1 mapping of index to sections
    if (self.hidesIndexTitleForStaticSectionNamesAbscentFromSections) return sectionIndex;

    NSIndexSet *availableIndexes = self.availableIndexes;
    
    //Determine the target index...
    NSUInteger targetIndex = NSNotFound;
    //1. if the request index is availble then use requested index
    if ([availableIndexes containsIndex:sectionIndex])
    {
        targetIndex = sectionIndex;
    }
    else
    {
        //'closest' means greatest index in the set 'avalibleIndexes smaller than requestIndex'
        NSUInteger closestIndex = [availableIndexes indexLessThanIndex:sectionIndex];
        NSUInteger indexFloor = [self.staticSectionNames indexOfObject:self.staticSectionNameForIndexTitleHeadSelectionSnapping];
        //2. else if closest index is great than indexFloor use closest index
        if (closestIndex > indexFloor && closestIndex != NSNotFound)
        {
            targetIndex = closestIndex;
        }
        else
        {
            //3. else use index floor
            targetIndex = [availableIndexes indexGreaterThanOrEqualToIndex:indexFloor];
        }
    }

    //return the index of target section in arrangedSectionIndexTitles
    return (targetIndex == NSNotFound) ? NSNotFound : [availableIndexes countOfIndexesInRange:NSMakeRange(0, targetIndex)];
}




//get indexTitles
-(NSString *)sectionIndexTitleForSection:(id)section
{
    NSString *sectionIndexTitle = nil;
    if (self.avalibleDelegateMethods & EMKSectionsControllerDelegateSectionIndexTitleForSectionMethod)
    {
        sectionIndexTitle = [self.delegate sectionController:self sectionIndexTitleForSection:section];
    }

    if (sectionIndexTitle) return sectionIndexTitle;
        
    NSString *sectionName = [self.delegate sectionController:self sectionNameForSection:section];
        
    return [self defaultSectionIndexTitleForSectionName:sectionName];
}



-(NSString *)sectionIndexTitleForStaticSectionName:(NSString *)staticSectionName
{
    NSString *sectionIndexTitle = nil;
    if (self.avalibleDelegateMethods & EMKSectionsControllerDelegateSectionIndexTitleForStaticSectionNameMethod)
    {
        sectionIndexTitle =  [self.delegate sectionController:self sectionIndexTitleForStaticSectionName:staticSectionName];
    }

    return (sectionIndexTitle) ?: [self defaultSectionIndexTitleForSectionName:staticSectionName];    
}



-(NSString *)defaultSectionIndexTitleForSectionName:(NSString *)sectionName
{
    return [sectionName substringToIndex:1];    
}


//accessing sections and objects
-(id)sectionAtIndex:(NSUInteger)section
{
    return [self.arrangedSections objectAtIndex:section];
}



-(id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.avalibleDelegateMethods & EMKSectionsControllerDelegateObjectAtIndexOfSectionMethod) == 0) 
    {
		NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: delegate does not respond to sectionController:objectAtIndex:ofSection:", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        return nil;
    }
    
    id section = [self.arrangedSections objectAtIndex:indexPath.section];
    
    return [self.delegate sectionController:self objectAtIndex:indexPath.row ofSection:section];
}


@end
