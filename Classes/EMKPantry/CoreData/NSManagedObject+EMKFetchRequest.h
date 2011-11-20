//
//  NSManagedObject+EMKFetchRequest.h
//  EMKPantry
//
//  Created by Benedict Cohen on 17/03/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef NSCoreDataVersionNumber_iPhoneOS_3_0
@interface NSManagedObject (EMKFetchRequest)

+(NSFetchRequest *)EMK_fetchRequestForDefaultEntityWithSortKey:(NSString *)sortKey inContext:(NSManagedObjectContext *)context;
+(NSFetchRequest *)EMK_fetchRequestForDefaultEntityWithSortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;
+(NSEntityDescription *)EMK_defaultEntityInContext:(NSManagedObjectContext *)context;
+(NSString *)EMK_defaultEntityName;

+(id)EMK_insertNewDefaultEntityInContext:(NSManagedObjectContext *)context;
@end


@interface NSManagedObject (EMKFetchRequestInformalProtocol)

+(NSString *)defaultEntityName; //informal protocol

@end
#endif