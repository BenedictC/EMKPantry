//
//  EMKSetController.h
//  EMKPantry
//
//  Created by Benedict Cohen on 06/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMKSetControllerSectionInfo.h"

@protocol EMKSetControllerDelegate;

@interface EMKSetController : NSObject 
{
    NSArray *objects_;
    NSString *sectionNameKeyPath_;
    NSArray *sortDescriptors_;    
    NSArray *sortKeyPaths_;  
    NSArray *secondaryKeyPaths_;      
    id delegate_; 

    NSArray *sections_;
    
    /*
     id _sections; //Array
     id _sectionsByName; //Dict?
     id _sectionIndexTitles; //Array?
     id _sectionIndexTitlesSections;  //Dict?

     NSString *_sectionNameKey;
     
     */
    
    
    /*

     struct _fetchResultsControllerFlags {
     unsigned int _sendObjectChangeNotifications:1;
     unsigned int _sendSectionChangeNotifications:1;
     unsigned int _sendDidChangeContentNotifications:1;
     unsigned int _sendWillChangeContentNotifications:1;
     unsigned int _sendSectionIndexTitleForSectionName:1;
     unsigned int _changedResultsSinceLastSave:1;
     unsigned int _hasMutableFetchedResults:1;
     unsigned int _hasBatchedArrayResults:1;
     unsigned int _hasSections:1;
     unsigned int _usesNonpersistedProperties:1;
     unsigned int _includesSubentities:1;
     unsigned int _reservedFlags:21;
     } _flags;

     */
}


-(EMKSetController *)initWithSet:(NSSet *)objects sortKeyPaths:(NSArray *)sortKeyPaths secondaryKeyPaths:(NSArray *)secondaryKeyPaths sectionNameKeyPath:(NSString *)sectionNameKeyPath;

@property(nonatomic, assign) id< EMKSetControllerDelegate > delegate;


//Sorting
@property(nonatomic, readonly) NSString *sectionNameKeyPath;
@property(nonatomic, readonly) NSArray *sortKeyPaths;


//Data fetching
@property(nonatomic, readonly) NSArray *objects;
@property(nonatomic, readonly) NSArray *sections;
-(NSIndexPath *)indexPathForObject:(id)object;
-(id)objectAtIndexPath:(NSIndexPath *)indexPath;


//These are intended to be optionally overriden
-(NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName;
-(NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex;
@property(nonatomic, readonly) NSArray *sectionIndexTitles;


//data setting
-(void)addObject:(id)object;
-(void)removeObject:(id)object;
-(void)addObjects:(NSSet *)newObjects removeObjects:(NSSet *)expiredObjects;
-(void)setObjects:(NSSet *)objects;


@end





// ================== PROTOCOLS ==================

@protocol EMKSetControllerDelegate <NSObject>

enum {
	EMKSetControllerChangeInsert = 1,
	EMKSetControllerChangeDelete = 2,
	EMKSetControllerChangeMove = 3,
	EMKSetControllerChangeUpdate = 4
	
};
typedef NSUInteger EMKSetControllerChangeType;

@optional
- (void)setController:(EMKSetController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(EMKSetControllerChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)setController:(EMKSetController *)controller didChangeSection:(id <EMKSetControllerSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(EMKSetControllerChangeType)type;
- (void)setControllerWillChangeContent:(EMKSetController *)controller;
- (void)setControllerDidChangeContent:(EMKSetController *)controller;
- (NSString *)setController:(EMKSetController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName;

@end
