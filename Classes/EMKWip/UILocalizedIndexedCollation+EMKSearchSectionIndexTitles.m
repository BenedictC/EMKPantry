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


@end
