//
//  NSManagedObject(EMKFetchRequest).h
//  Jot
//
//  Created by Benedict Cohen on 17/03/2011.
//  Copyright 2011 Electric Muffin Kitchen. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObject (EMKFetchRequest)

+(NSFetchRequest *)EMK_fetchRequestForDefaultEntityWithSortKey:(NSString *)sortKey inContext:(NSManagedObjectContext *)context;
+(NSFetchRequest *)EMK_fetchRequestForDefaultEntityWithSortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;
+(NSEntityDescription *)EMK_defaultEntityInContext:(NSManagedObjectContext *)context;
+(NSString *)EMK_defaultEntityName;

@end


@interface NSManagedObject (EMKFetchRequestInformalProtocol)

+(NSString *)defaultEntityName; //informal protocol

@end
