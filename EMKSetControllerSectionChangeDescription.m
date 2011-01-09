//
//  EMKSetControllerSectionChangeDescription.m
//  EMKPantry
//
//  Created by Benedict Cohen on 09/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKSetControllerSectionChangeDescription.h"


@interface EMKSetControllerSectionChangeDescription ()

-(id)initWithSection:(id)section index:(NSUInteger)index changeType:(EMKSetControllerChangeType)changeType;


@end


@implementation EMKSetControllerSectionChangeDescription


#pragma mark class methods
+(id)sectionChangeDescriptionWithSection:(id)section index:(NSUInteger)index changeType:(EMKSetControllerChangeType)changeType
{
    return [[[self alloc] initWithSection:section index:index changeType:changeType] autorelease];
}



#pragma mark memory management
-(id)initWithSection:(id)section index:(NSUInteger)index changeType:(EMKSetControllerChangeType)changeType
{
    if ([super init])
    {
        _section = [section retain];
        _index = index;
        _changeType = changeType;
    }
    
    return self;
}



-(void)dealloc
{
    [_section release];
    
    [super dealloc];
}



#pragma mark properties

@synthesize section = _section;
@synthesize index = _index;
@synthesize changeType = _changeType;


@end
