//
//  EMKCoreDataHelper.m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "EMKCoreDataHelper.h"


static EMKCoreDataHelper *EMK_sharedCoreDataHelper = nil;

@implementation EMKCoreDataHelper

#pragma mark class methods
+(EMKCoreDataHelper*)sharedHelper
{
    @synchronized(self)
    {
        if (!EMK_sharedCoreDataHelper) EMK_sharedCoreDataHelper = [EMKCoreDataHelper new];
    }

    
    return EMK_sharedCoreDataHelper;
}




+ (id)allocWithZone:(NSZone *)zone
{ 
    @synchronized(self) 
    { 
        if (!EMK_sharedCoreDataHelper) 
        { 
            EMK_sharedCoreDataHelper = [super allocWithZone:zone]; 
            return EMK_sharedCoreDataHelper; 
        } 
    } 
    
    return nil; 
} 




#pragma mark properties
@synthesize coreDataProvider = _coreDataProvider;

@dynamic managedObjectContext;
-(NSManagedObjectContext*)managedObjectContext
{
    id coreDataProvider = self.coreDataProvider;
   
    return ([coreDataProvider respondsToSelector:@selector(managedObjectContext)]) ? [coreDataProvider managedObjectContext] : nil;
}




@dynamic managedObjectModel;
-(NSManagedObjectModel*)managedObjectModel
{
    id coreDataProvider = self.coreDataProvider;
    
    return ([coreDataProvider respondsToSelector:@selector(managedObjectModel)]) ? [coreDataProvider managedObjectModel] : nil;
}




@dynamic persistentStoreCoordinator;
-(NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    id coreDataProvider = self.coreDataProvider;
    
    return ([coreDataProvider respondsToSelector:@selector(persistentStoreCoordinator)]) ? [coreDataProvider persistentStoreCoordinator] : nil;
}


#pragma mark init, dealloc and memory management


- (id)copyWithZone:(NSZone *)zone
{ 
    return self;
} 



- (id)retain
{ 
    return self;
} 



- (NSUInteger)retainCount 
{ 
    return NSUIntegerMax;
} 


- (void)release
{ 
} 


- (id)autorelease
{ 
    return self;
}




#pragma mark instance methods
-(NSManagedObjectContext*)newContext
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    if (!persistentStoreCoordinator) return nil;
    //We create newContext with NSClassFromString so that this will compile even when the project is not linked to CoreData.framework
    id newContext = [NSClassFromString(@"NSManagedObjectContext") performSelector:@selector(new)]; 
    [newContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return newContext;
}


@end







