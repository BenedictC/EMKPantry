//
//  EMKSetControllerObjectChangeDescription.m
//  EMKPantry
//
//  Created by Benedict Cohen on 09/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKSetControllerObjectChangeDescription.h"



@interface EMKSetControllerObjectChangeDescription ()

-(id)initWithObject:(id)object preIndex:(NSIndexPath *)preIndex postIndex:(NSIndexPath *)postIndex changeType:(EMKSetControllerChangeType)changeType;


@end


@implementation EMKSetControllerObjectChangeDescription


#pragma mark class methods
+(id)objectChangeDescriptionWithObject:(id)object preIndex:(NSIndexPath *)preIndex postIndex:(NSIndexPath *)postIndex changeType:(EMKSetControllerChangeType)changeType;
{
    return [[[self alloc] initWithObject:object preIndex:preIndex postIndex:postIndex changeType:changeType] autorelease];
}



#pragma mark memory management
-(id)initWithObject:(id)object preIndex:(NSIndexPath *)preIndexPath postIndex:(NSIndexPath *)postIndexPath changeType:(EMKSetControllerChangeType)changeType;
{
    if ([super init])
    {
        _object = [object retain];
        _preIndexPath = [preIndexPath retain];
        _postIndexPath = [postIndexPath retain];
        _changeType = changeType;
    }
    
    return self;
}



-(void)dealloc
{
    [_object release];
    [_preIndexPath release];
    [_postIndexPath release];
    
    [super dealloc];
}



#pragma mark properties

@synthesize object = _object;
@synthesize preIndexPath = _preIndexPath;
@synthesize postIndexPath = _postIndexPath;
@synthesize changeType = _changeType;


@end
