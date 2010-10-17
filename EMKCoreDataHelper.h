//
//  EMKCoreDataHelper.h
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <CoreData/CoreData.h>



@interface EMKCoreDataHelper : NSObject 
{
    @private
    id _coreDataProvider;
}


+(EMKCoreDataHelper*)sharedHelper;
#define EMKSharedCoreDataHelper [EMKCoreDataHelper sharedHelper]

@property (retain) id coreDataProvider;


@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSManagedObjectContext*)newContext;



@end