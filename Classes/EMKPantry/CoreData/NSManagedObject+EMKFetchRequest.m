//
//  NSManagedObject(EMKFetchRequest).m
//  EMKPantry
//
//  Created by Benedict Cohen on 17/03/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//



#import "NSManagedObject(EMKFetchRequest).h"


@implementation NSManagedObject (EMKFetchRequest)

+(NSFetchRequest *)EMK_fetchRequestForDefaultEntityWithSortKey:(NSString *)sortKey inContext:(NSManagedObjectContext *)context
{
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES] autorelease];
    
    return [self EMK_fetchRequestForDefaultEntityWithSortDescriptors:[NSArray arrayWithObject:sortDescriptor] inContext:context];
}



+(NSFetchRequest *)EMK_fetchRequestForDefaultEntityWithSortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest new] autorelease];
    
    [fetchRequest setEntity:[self EMK_defaultEntityInContext:context]];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    return fetchRequest;
}




+(NSEntityDescription *)EMK_defaultEntityInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:[self EMK_defaultEntityName] inManagedObjectContext:context]; 
}



+(NSString *)EMK_defaultEntityName
{
    SEL defaultEntityNameSelector = @selector(defaultEntityName);
    return([self respondsToSelector:defaultEntityNameSelector]) ? [self performSelector:defaultEntityNameSelector] : NSStringFromClass(self);
}



+(id)EMK_insertNewDefaultEntityInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self EMK_defaultEntityName] inManagedObjectContext:context];
}

@end
