//
//  UILocalizedIndexedCollation+EMKSearchSectionIndexTitles.m
//  EMKPantry
//
//  Created by Benedict Cohen on 07/06/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "UILocalizedIndexedCollation+EMKSearchSectionIndexTitles.h"


@implementation UILocalizedIndexedCollation (EMKSearchSectionIndexTitles)


-(NSString *)EMK_searchIndexTitle
{
    static NSString * const searchIndexTitle = @"{search}";
    
    return searchIndexTitle;
}



-(NSArray *)EMK_sectionIndexTitlesWithSearch
{
    //create an array containing the search section
    NSArray *search = [[NSArray alloc] initWithObjects:[self EMK_searchIndexTitle], nil];
    //append the other section to it
    NSArray *sectionIndexTitles = [search arrayByAddingObjectsFromArray:self.sectionIndexTitles];
    [search release];
    
    return sectionIndexTitles;
}



-(NSArray *)EMK_partitionObjects:(NSArray *)objects collationStringSelector:(SEL)selector
{
    NSInteger sectionCount = [[self sectionIndexTitles] count];
    
    //create a bucket for each section
    //we have to use arrays (as opposed to sets) because an object may be in a section more than once
    NSMutableArray *sectionBuckets = [NSMutableArray arrayWithCapacity:sectionCount];
    for(int i = 0; i < sectionCount; i++)
    {
        [sectionBuckets addObject:[NSMutableArray array]];
    }
    
    //put each object into a bucket
    for (id object in objects)
    {
        NSInteger sectionIndex = [self sectionForObject:object collationStringSelector:selector];
        NSArray *bucket = [sectionBuckets objectAtIndex:sectionIndex];
        [bucket addObject:object];
    }
    
    //sort the contents of each bucket
    NSMutableArray *sortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    for (NSMutableArray *bucket in sectionBuckets)
    {
        [sortedSections addObject:[self sortedArrayFromArray:bucket collationStringSelector:selector]];
    }
    
    return sortedSections;
}


@end
