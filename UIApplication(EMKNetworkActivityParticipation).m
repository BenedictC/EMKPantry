//
//  UIApplication(EMKNetworkActivityParticipation).m
//  EMKPantry
//
//  Created by Benedict Cohen on 09/11/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "UIApplication(EMKNetworkActivityParticipation).h"


//we use an array instead of a set so that we can have multiple instances of a particpant
NSMutableArray *EMKNetworkActivityParticipants;


@implementation UIApplication (EMKNetworkActivityParticipation)

-(void)EMK_addNetworkActivityParticipant:(id)participant
{
    if (!EMKNetworkActivityParticipants)
    {
        EMKNetworkActivityParticipants = [[NSMutableArray arrayWithCapacity:5] retain]; //5 is an arbitary number. Can you think of a better approach?
    }
    
    [EMKNetworkActivityParticipants addObject:participant];

    [self setNetworkActivityIndicatorVisible:YES];
}



-(void)EMK_removeNetworkActivityParticipant:(id)participant
{
    int indexOfFirstInstance = [EMKNetworkActivityParticipants indexOfObject:participant];
    
    if (indexOfFirstInstance == NSNotFound) return;
    
    [EMKNetworkActivityParticipants removeObjectAtIndex:indexOfFirstInstance];
    
    [self setNetworkActivityIndicatorVisible:[EMKNetworkActivityParticipants count]];
}



@end
