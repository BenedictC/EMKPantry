//
//  UILocalizedIndexedCollation+EMKSearchSectionIndexTitles.h
//  EMKPantry
//
//  Created by Benedict Cohen on 07/06/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILocalizedIndexedCollation (EMKSearchSectionIndexTitles)

//section index
-(NSString *)EMK_searchIndexTitle;
-(NSArray *)EMK_sectionIndexTitlesWithSearch;

//group and sort objects by section index
-(NSArray *)EMK_partitionObjects:(NSArray *)objects collationStringSelector:(SEL)selector;

@end
