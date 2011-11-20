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
    NSArray *search = [[NSArray alloc] initWithObjects:[self EMK_searchIndexTitle], nil];
    NSArray *sectionIndexTitles = [search arrayByAddingObjectsFromArray:self.sectionIndexTitles];
    [search release];
    
    return sectionIndexTitles;
}



-(NSArray *)EMK_partitionObjects:(NSArray *)objects collationStringSelector:(SEL)selector
{
    NSInteger sectionCount = [[self sectionIndexTitles] count];
    
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    for(int i = 0; i < sectionCount; i++)
    {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    for (id object in objects)
    {
        NSInteger index = [self sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    for (NSMutableArray *section in unsortedSections)
    {
        [sections addObject:[self sortedArrayFromArray:section collationStringSelector:selector]];
    }
    
    return sections;
}


@end
