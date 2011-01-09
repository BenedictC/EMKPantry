//
//  EMKSetControllerSection.m
//  EMKPantry
//
//  Created by Benedict Cohen on 08/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKSetControllerSection.h"



@implementation EMKSetControllerSection

#pragma mark memory management
-(id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        _name = name;
        _objects = [NSArray new];
    }
    
    return self;
}



-(void)dealloc
{
    [_indexTitle release];    
    [_name release];
    [_objects release];
    
    [super dealloc];
}




-(id)copyWithZone:(NSZone *)zone
{
    EMKSetControllerSection *copy = [[EMKSetControllerSection alloc] initWithName:[[self.name copyWithZone:zone] autorelease]];
    [copy setIndexTitle:[[self.indexTitle copyWithZone:zone] autorelease]];
    [copy setObjects:[[self.objects copyWithZone:zone] autorelease]];
    
    return copy;
}




#pragma mark properties
@synthesize indexTitle = _indexTitle;
@synthesize name = _name;
@synthesize objects = _objects;



-(NSUInteger)numberOfObjects
{
    return [self.objects count];
}





#pragma mark methods
-(void)setIndexTitle:(NSString *)indexTitle
{
    [_indexTitle release];
    _indexTitle = [indexTitle retain];
}




-(void)setObjects:(NSArray *)objects
{
    [_objects release];
    
    _objects = (objects) ? [objects retain] : [NSArray new];
}


@end


