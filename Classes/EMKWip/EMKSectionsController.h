//
//  EMKSectionsController.h
//  SectionKeyPathDemo
//
//  Created by Benedict Cohen on 04/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 EMKSectionsController provides the following functionality:
    - Simplifies management of table indexes
    - Reordering of sections

 EMKSectionsController does not alert its delegate to changes.
 
 
 Use cases
 ---------
 reordering the sections, and not diplaying the index √
 showing an index for the active sections only √
 showing a collation index √
 add additional sections (e.g. search) √
 
 
 show a section for a range of dates. The sectionIndex for each section is the date, e.g. 23, 
 except for the first section of the month, which is the (abbreviated) month name, e.g. Sept.
 
 
 TODO
 ----
 Test with:
 - un-implemented delegate methods
 - nil returned from delegate methods
 - nil sections
 - Change comparator so that nil returns nil and the default comparator is never exposed
 
 Try putting search in the table header
 
*/



@class EMKSectionsController;
@protocol EMKSectionsControllerDelegate <NSObject>
@required
-(NSString *)sectionsController:(EMKSectionsController *)sectionsController sectionNameForSection:(id)section;

@optional
//indexTitle creation
//the default implementation uses the first letter of the sectionName. Return nil to use the default sectionIndexTitle
-(BOOL)sectionsController:(EMKSectionsController *)sectionsController shouldShowIndexTitleForSection:(id)section;
-(NSString *)sectionsController:(EMKSectionsController *)sectionsController sectionIndexTitleForSection:(id)section;

-(BOOL)sectionsController:(EMKSectionsController *)sectionsController shouldShowIndexTitleForStaticSectionName:(NSString *)staticSectionName;
-(NSString *)sectionsController:(EMKSectionsController *)sectionsController sectionIndexTitleForStaticSectionName:(NSString *)staticSectionName;

//facilitating object access
-(NSUInteger)sectionsController:(EMKSectionsController *)sectionsController numberOfObjectsInSection:(id)section;
-(id)sectionsController:(EMKSectionsController *)sectionsController objectAtIndex:(NSUInteger)row ofSection:(id)section;

@end





@interface EMKSectionsController : NSObject

//Convienince method for create an Contacts.app style table:
//staticSectionNames = [[UILocalizedCollation currentCollation] sectionIndexTitles]
//passiveStaticSectionNames = nil

//To included a 'search' sectionIndex use the category methods on UILocalizedCollation i.e.:
//staticSectionNames = [[UILocalizedCollation currentCollation] EMK_sectionIndexTitlesWithSearch]
//passiveStaticSectionNames = [NSArray withObject: [[UILocalizedCollation currentCollation] EMK_searchIndexTitle]
+(id)sectionsControllerWithStaticSectionNames:(NSArray *)staticSectionNames passiveStaticSectionNames:(NSArray *)passiveStaticSectionNames delegate:(id<EMKSectionsControllerDelegate>)delegate;


//In
//--
//Data
@property(readwrite, nonatomic, assign) id<EMKSectionsControllerDelegate> delegate;
@property(readwrite, nonatomic, copy) NSArray *sections;

//Section sorting
@property(readwrite, nonatomic, copy) NSArray *staticSectionNames;
@property(readwrite, nonatomic, copy) NSComparator sectionNameComparator;  //when set to nil (the default) returns a comparator that sorts on sectionName by staticSectionNames, then asscending by sectionName using localizedStandardCompare:

//Index selection behaviour
@property(readwrite, nonatomic, copy) NSArray *passiveStaticSectionNames;



//Out
//---
@property(readonly, nonatomic, retain) NSArray *arrangedSections;
@property(readonly, nonatomic, retain) NSArray *arrangedSectionIndexTitles;

//get sectionNames
-(NSString *)sectionNameForSection:(id)section; //calls thru to the 1 required delegate method
-(BOOL)showsIndexTitleForSection:(id)section;

//table view related information about sections
// Specifies the section that should be scrolled to for the title at the given index.
// This method allows you to map between a given item in the index
// and a given section where there isn't a one-to-one mapping.
-(NSUInteger)sectionForSectionIndexTitleAtIndex:(NSUInteger)sectionIndex;

//get indexTitles
-(NSString *)sectionIndexTitleForSection:(id)section;
-(NSString *)sectionIndexTitleForStaticSectionName:(NSString *)sectionName;


@end



@interface EMKSectionsController () //facilitating object access
//These are in an anon. category as they provide optional functionality

-(id)sectionAtIndex:(NSUInteger)section;
-(NSString *)sectionNameAtIndex:(NSUInteger)section;

-(NSUInteger)numberOfRowsInSectionAtIndex:(NSUInteger)section;
-(id)objectAtIndexPath:(NSIndexPath *)indexPath;
    
@end
