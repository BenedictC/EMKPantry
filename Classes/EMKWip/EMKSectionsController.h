//
//  EMKSectionController.h
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

 
 Use cases
 ---------
 reordering the sections, and not diplaying the index √
 showing an index for the active sections only √
 showing a collation index √
 add additional sections (e.g. search) √
 
 
 show a section for a range of dates. The sectionIndex for each section is the date, e.g. 23, 
 except for the first section of the month, which is the (abbreviated) month name, e.g. Sept.
 
 
 
 Problems
 --------
 how do we reorder but not display an index - set sectionIndexTitles, but don't implement sectionIndexTitlesForTableView: √
 what do we do when sectionIndexTitle is not in sectionIndexTitles? Throw exception. √
 how do we only show sections which are active and still reorder them? - set shouldFilterSectionIndexTitlesToActiveSections = YES √ 
 how do we add a search index to fetchedresults backed data? √
 
 
*/



@class EMKSectionsController;
@protocol EMKSectionControllerDelegate <NSObject>
@required
-(NSString *)sectionController:(EMKSectionsController *)sectionController sectionNameForSection:(id)section;

@optional
//the default implementation uses the first letter of the sectionName. Return nil to use the default sectionIndexTitle
-(NSString *)sectionController:(EMKSectionsController *)sectionController sectionIndexTitleForSection:(id)section;
-(NSString *)sectionController:(EMKSectionsController *)sectionController sectionIndexTitleForStaticSectionName:(NSString *)staticSectionName;

//facilitating object access
-(id)sectionController:(EMKSectionsController *)sectionController objectAtIndex:(NSUInteger)row ofSection:(id)section;
@end





@interface EMKSectionsController : NSObject

//+(id)sectionsControllerWithStaticIndex:(NSArray *)index delegate:(id<EMKSectionControllerDelegate>)delegate;


//In
//--
//Data
@property(readwrite, nonatomic, assign) id<EMKSectionControllerDelegate> delegate;
@property(readwrite, nonatomic, copy) NSArray *sections;

//Section sorting
@property(readwrite, nonatomic, copy) NSArray *staticSectionNames;
@property(readwrite, nonatomic, copy) NSComparator sectionNameComparator;  //when set to nil (the default) returns a comparator that sorts on sectionName by staticSectionNames, then asscending by sectionName using localizedStandardCompare:

//Index appearance and behaviour
@property(readwrite, nonatomic, assign) BOOL hidesIndexTitleForStaticSectionNamesAbscentFromSections;
@property(readwrite, nonatomic, copy) NSString *staticSectionNameForIndexTitleHeadSelectionSnapping;


//Out
//---
@property(readonly, nonatomic, retain) NSArray *arrangedSections;
@property(readonly, nonatomic, retain) NSArray *arrangedSectionIndexTitles;


//Handling NSFetchedResultsContoller updates
//@property(readonly, nonatomic, retain) EMKSectionsController *sectionsControllerPriorToUpdate;
//@property(readonly, nonatomic, assign) BOOL isArchive;
//@property(readonly, nonatomic, assign) BOOL hasChangesPending;
//@property(readonly, nonatomic, retain) id updateContext;
//-(void)beginUpdate:(id)updateContext;
//-(void)endUpdate;



//table view related information about sections
-(NSUInteger)sectionForSectionIndexTitleAtIndex:(NSUInteger)sectionIndex;

//get indexTitles
-(NSString *)sectionIndexTitleForSection:(id)section;
-(NSString *)sectionIndexTitleForStaticSectionName:(NSString *)sectionName;

//accessing sections and objects
-(id)sectionAtIndex:(NSUInteger)section;
-(id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end

