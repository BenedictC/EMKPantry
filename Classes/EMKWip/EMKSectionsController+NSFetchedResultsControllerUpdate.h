//
//  EMKSectionsController+NSFetchedResultsControllerUpdate.h
//  EMKPantry
//
//  Created by Benedict Cohen on 06/06/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKSectionsController.h"

/*
 
 This category integrates EMKSectionsContoller with the NSFetchedResultsControllerDelegate update mechanism.
 
 These methods are not implemented directly in the class because:
 1. It avoids coupling the core functionality of EMKSectionsController with CoreData
 2. I'm not entirely happy with the implementation, and I don't want to infect EMKSectionsController with ugly code (yet).
 
 */


#ifdef NSCoreDataVersionNumber_iPhoneOS_3_0
@protocol EMKSectionsControllerNSFetchedResultsControllerUpdate <NSObject>
@optional
-(void)beginUpdateFromFetchedResultsController:(NSFetchedResultsController *)controller;
-(void)updateSections:(NSArray *)sections;
-(void)endUpdate;

-(NSUInteger)indexForSectionInfo:(id)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;

-(NSIndexPath *)indexPathForObjectAtIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath *)indexPathForObjectAtNewIndexPath:(NSIndexPath *)newIndexPath;

@end


@interface EMKSectionsController () <EMKSectionsControllerNSFetchedResultsControllerUpdate>
@end
#endif