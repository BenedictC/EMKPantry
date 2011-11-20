//
//  EMKSectionsController.m
//  SectionKeyPathDemo
//
//  Created by Benedict Cohen on 04/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EMKSectionsController.h"


@interface EMKSectionsController ()
@property(readwrite, nonatomic, assign) int avalibleDelegateMethods;
@property(readwrite, nonatomic, retain) NSIndexSet *availableIndexes;
@property(readwrite, nonatomic, retain) NSIndexSet *availableNonPassiveIndexes;

@property(readwrite, nonatomic, retain) NSArray *arrangedSections;
@property(readwrite, nonatomic, retain) NSArray *arrangedSectionIndexTitles;


-(void)calculateArrangedSections;
-(void)invalidateArrangedSections;

-(NSString *)defaultSectionIndexTitleForSectionName:(NSString *)sectionName;
@end


enum EMKSectionsControllerDelegateMethods
{
    EMKSectionsControllerDelegateSectionNameForSectionMethod  = 1 << 0,
    
    EMKSectionsControllerDelegateSectionIndexTitleForSectionMethod = 1 << 1,    
    EMKSectionsControllerDelegateSectionIndexTitleForStaticSectionNameMethod = 1 << 2,    
    
    EMKSectionsControllerDelegateNumberOfObjectsInSectionMethod = 1 << 3,    
    EMKSectionsControllerDelegateObjectAtIndexOfSectionMethod = 1 << 4,
    
};




@implementation EMKSectionsController

#pragma mark class methods
+(id)sectionsControllerWithStaticSectionNames:(NSArray *)staticSectionNames passiveStaticSectionNames:(NSArray *)passiveStaticSectionNames delegate:(id<EMKSectionsControllerDelegate>)delegate
{
    EMKSectionsController *sectionController = [[self new] autorelease];
    sectionController.staticSectionNames = staticSectionNames;
    sectionController.passiveStaticSectionNames = passiveStaticSectionNames;
    sectionController.delegate = delegate;
    
    return sectionController;    
}



#pragma mark properties
//In
@synthesize avalibleDelegateMethods = avalibleDelegateMethods_;
@synthesize availableNonPassiveIndexes = availableNonPassiveIndexes_;
@synthesize delegate = delegate_;
-(void)setDelegate:(id<EMKSectionsControllerDelegate>)delegate
{
    if (delegate == delegate_) return;

    [self invalidateArrangedSections];    
    
    delegate_ = delegate;
    
    int avalibleDelegateMethods = 0;
    if ([delegate respondsToSelector:@selector(sectionsController:sectionNameForSection:)])
    {
        avalibleDelegateMethods = avalibleDelegateMethods | EMKSectionsControllerDelegateSectionNameForSectionMethod;
    }
    else
    {
        NSLog(@"WARNING: %@(%p) does not respond to sectionsController:sectionIndexTitleForSection:", NSStringFromClass([delegate class]), delegate);
    }
    
    if ([delegate respondsToSelector:@selector(sectionsController:sectionIndexTitleForSection:)])
    {
        avalibleDelegateMethods = avalibleDelegateMethods | EMKSectionsControllerDelegateSectionIndexTitleForSectionMethod;
    }

    if ([delegate respondsToSelector:@selector(sectionsController:sectionIndexTitleForStaticSectionName:)])
    {
        avalibleDelegateMethods = avalibleDelegateMethods | EMKSectionsControllerDelegateSectionIndexTitleForStaticSectionNameMethod;
    }
    
    if ([delegate respondsToSelector:@selector(sectionsController:numberOfObjectsInSection:)])
    {
        avalibleDelegateMethods = avalibleDelegateMethods | EMKSectionsControllerDelegateNumberOfObjectsInSectionMethod;
    }

    if ([delegate respondsToSelector:@selector(sectionsController:objectAtIndex:ofSection:)])
    {
        avalibleDelegateMethods = avalibleDelegateMethods | EMKSectionsControllerDelegateObjectAtIndexOfSectionMethod;
    }


    self.avalibleDelegateMethods = avalibleDelegateMethods;
}



//@synthesize hidesIndexTitleForStaticSectionNamesAbscentFromSections = hidesIndexTitleForStaticSectionNamesAbscentFromSections_;
//-(void)setHidesIndexTitleForStaticSectionNamesAbscentFromSections:(BOOL)hidesIndexTitleForStaticSectionNamesAbscentFromSections
//{
//    if (hidesIndexTitleForStaticSectionNamesAbscentFromSections == hidesIndexTitleForStaticSectionNamesAbscentFromSections_) return;
//    
//    [self invalidateArrangedSections];
//    
//    hidesIndexTitleForStaticSectionNamesAbscentFromSections_ = hidesIndexTitleForStaticSectionNamesAbscentFromSections;
//}


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

//        return (NSComparisonResult)[obj1 localizedStandardCompare:obj2];
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
                index2 = 1+[[UILocalizedIndexedCollation currentCollation] sectionForObject:obj2 collationStringSelector:@selector(description)];
                return (index1 < index2) ? NSOrderedAscending : NSOrderedDescending;                
                return NSOrderedAscending;
            }
        }
        else
        {
            if (index2 != NSNotFound)
            {
                //Only index2 is in staticSectionNames
                index1 = 1+[[UILocalizedIndexedCollation currentCollation] sectionForObject:obj1 collationStringSelector:@selector(description)];
                return (index1 < index2) ? NSOrderedAscending : NSOrderedDescending;                
                return NSOrderedDescending;
            }
            else
            {
                //neither are in staticSectionNames
                return [(NSString *)obj1 localizedStandardCompare:obj2];
            }
        }
        
        
        return NSOrderedSame;
    };
    
    self.sectionNameComparator = comparator;
    
    return sectionNameComparator_;
}



@synthesize sections = sections_;
-(void)setSections:(NSArray *)sections
{
    if ([sections isEqualToArray:sections_]) return;
    
    [self invalidateArrangedSections];    

    [sections_ release];
    sections_ = [sections copy];
}


@synthesize passiveStaticSectionNames = passiveStaticSectionNames_;
-(void)setPassiveStaticSectionNames:(NSArray *)passiveStaticSectionNames
{
    if (passiveStaticSectionNames == passiveStaticSectionNames_) return;
    
    [self invalidateArrangedSections];

    [passiveStaticSectionNames_ release];
    passiveStaticSectionNames_ = [passiveStaticSectionNames copy];
}



//Out
@synthesize availableIndexes = availableIndexes_; //private

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





#pragma mark memory managment
-(id)copy
{
    EMKSectionsController *clone = [[self class] new];
    clone->arrangedSectionIndexTitles_ = [self.arrangedSectionIndexTitles copy];
    clone->arrangedSections_ = [self.arrangedSections copy];
    clone->availableIndexes_ = [self.availableIndexes copy];
    clone->availableNonPassiveIndexes_ = [self.availableNonPassiveIndexes copy];
    
    clone->delegate_ = self.delegate;
//    clone->hidesIndexTitleForStaticSectionNamesAbscentFromSections_ = self.hidesIndexTitleForStaticSectionNamesAbscentFromSections;
    clone->staticSectionNames_ = [self.staticSectionNames copy];
    clone->sections_ = [self.sections copy];
    clone->passiveStaticSectionNames_ = [self.passiveStaticSectionNames copy];
    
    //Out
    clone->arrangedSections_ = [self.arrangedSections copy];
    
    return clone;
}



-(void)dealloc
{
    [staticSectionNames_ release];
    [sections_ release];
    [arrangedSectionIndexTitles_ release];
    [arrangedSections_ release];
    [availableIndexes_ release];
    [availableNonPassiveIndexes_ release];
    
    [super dealloc];
}



#pragma mark arrangedSections calculation
//TODO: Rename these so that the name reflects the fact that the invalidate arrangedSectionIndexTitles and arrangedSections.
-(void)invalidateArrangedSections
{
    self.arrangedSections = nil;
}



-(void)calculateArrangedSections
{
    BOOL shouldCalculateArrangedSections = arrangedSections_ == nil;
    
    if (shouldCalculateArrangedSections == NO) return;

    NSUInteger sectionCount = [self.sections count];

    
    //1. store the sections so that we can efficently access them by sectionName
    NSMutableDictionary *sectionsBySectionName = [NSMutableDictionary dictionaryWithCapacity:sectionCount];
    for (id section in self.sections)
    {
        NSString *sectionName = [self sectionNameForSection:section];
        [sectionsBySectionName setObject:section forKey:sectionName];
    }
    

    //get the sectionNames for all the indexesTitles
    NSArray *allSectionNames = [[NSSet setWithArray:[[sectionsBySectionName allKeys] arrayByAddingObjectsFromArray:self.staticSectionNames]] allObjects];
    NSArray *arrangedSectionNames = [allSectionNames sortedArrayUsingComparator:self.sectionNameComparator];
    
    NSMutableArray *arrangedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    NSMutableArray *arrangedSectionIndexTitles = [NSMutableArray arrayWithCapacity:sectionCount];

    NSMutableIndexSet *availableIndexes = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *availableNonPassiveIndexes = [NSMutableIndexSet indexSet];

    int sectionIndex = 0;
    for (NSString *sectionName in arrangedSectionNames)
    {
        id section = [sectionsBySectionName objectForKey:sectionName];

        if (section)
        {
            [arrangedSections addObject:section];

//            BOOL arf = [self.delegate sectionController:self shouldShowIndexTitleForSection:section];
            BOOL arf = [self.staticSectionNames containsObject:sectionName];
            
            if (arf) 
            {
                [arrangedSectionIndexTitles addObject:[self sectionIndexTitleForSection:section]];            
                [availableIndexes addIndex:sectionIndex];
                if (![self.passiveStaticSectionNames containsObject:sectionName])
                {
                    [availableNonPassiveIndexes addIndex:sectionIndex];
                }
            }
            
            
        }
        else if (YES || [self.delegate sectionsController:self shouldShowIndexTitleForStaticSectionName:sectionName])
        {
            [arrangedSectionIndexTitles addObject:[self sectionIndexTitleForStaticSectionName:sectionName]];            
        }
        
        sectionIndex++;
    }
    
    

    //done!
    self.arrangedSections = arrangedSections;
    self.arrangedSectionIndexTitles = arrangedSectionIndexTitles;
    
    self.availableIndexes = availableIndexes;
    self.availableNonPassiveIndexes = availableNonPassiveIndexes;
}



#pragma mark sectionName method
//this is fundamental
-(NSString *)sectionNameForSection:(id)section
{
    //we don't check for that delegate responds because this is a required method
    return [self.delegate sectionsController:self sectionNameForSection:section];    
}


-(BOOL)showsSectionInSectionIndex:(id)section
{
    return NO;
//    return [self.delegate sectionController:self shouldShowSectionInIndex:section];
}



#pragma mark sectionIndexTitle methods
//table view related information about sections
-(NSUInteger)sectionForSectionIndexTitleAtIndex:(NSUInteger)sectionIndex
{
    //if the index only shows avaible sections then it's a simple 1 to 1 mapping of index to sections
//    if (self.hidesIndexTitleForStaticSectionNamesAbscentFromSections) return sectionIndex;

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
        //'closest' means greatest index in the set 'nonPassiveAvailableIndexes that is smaller than requestIndex'
        NSIndexSet *nonPassiveAvailableIndexes = self.availableNonPassiveIndexes;
        NSUInteger closestIndex = [nonPassiveAvailableIndexes indexLessThanIndex:sectionIndex];

        //2. if there is no 'closest index', use the lowest available non-passive index
        targetIndex = (closestIndex != NSNotFound) ? closestIndex : [nonPassiveAvailableIndexes firstIndex];
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
        sectionIndexTitle = [self.delegate sectionsController:self sectionIndexTitleForSection:section];
    }

    if (sectionIndexTitle) return sectionIndexTitle;
        
    NSString *sectionName = [self.delegate sectionsController:self sectionNameForSection:section];
        
    return [self defaultSectionIndexTitleForSectionName:sectionName];
}



-(NSString *)sectionIndexTitleForStaticSectionName:(NSString *)staticSectionName
{
    NSString *sectionIndexTitle = nil;
    if (self.avalibleDelegateMethods & EMKSectionsControllerDelegateSectionIndexTitleForStaticSectionNameMethod)
    {
        sectionIndexTitle =  [self.delegate sectionsController:self sectionIndexTitleForStaticSectionName:staticSectionName];
    }

    return (sectionIndexTitle) ?: [self defaultSectionIndexTitleForSectionName:staticSectionName];    
}



-(NSString *)defaultSectionIndexTitleForSectionName:(NSString *)sectionName
{
    return [sectionName substringToIndex:1];    
}



#pragma mark facilitating object access
//accessing sections and objects
-(id)sectionAtIndex:(NSUInteger)section
{
    return [self.arrangedSections objectAtIndex:section];
}



-(NSString *)sectionNameAtIndex:(NSUInteger)section
{
    return [self sectionNameForSection:[self sectionAtIndex:section]];
}



-(NSUInteger)numberOfRowsInSectionAtIndex:(NSUInteger)index
{
//    if ((self.avalibleDelegateMethods & EMKSectionsControllerDelegateNumberOfObjectsInSectionMethod) == 0) 
//    {
//		NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: delegate does not respond to sectionsController:numberOfObjectsInSection:", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
//        [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
//        return nil;
//    }
    
    id section = [self sectionAtIndex:index];
    
    return [self.delegate sectionsController:self numberOfObjectsInSection:section];
}



-(id)objectAtIndexPath:(NSIndexPath *)indexPath
{
//    if ((self.avalibleDelegateMethods & EMKSectionsControllerDelegateObjectAtIndexOfSectionMethod) == 0) 
//    {
//		NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: delegate does not respond to sectionsController:objectAtIndex:ofSection:", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
//        [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
//        return nil;
//    }
    
    id section = [self sectionAtIndex:indexPath.section];
    
    return [self.delegate sectionsController:self objectAtIndex:indexPath.row ofSection:section];
}


@end
