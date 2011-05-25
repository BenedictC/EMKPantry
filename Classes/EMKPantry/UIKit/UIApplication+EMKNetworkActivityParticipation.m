//
//  UIApplication+EMKNetworkActivityParticipation.m
//  EMKPantry
//
//  Created by Benedict Cohen on 09/11/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "UIApplication+EMKNetworkActivityParticipation.h"


int EMKNetworkActivityParticipantCount = 0;



@implementation UIApplication (EMKNetworkActivityParticipation)


-(void)EMK_addNetworkActivityParticipant
{
    EMKNetworkActivityParticipantCount++;        
    
    [self setNetworkActivityIndicatorVisible:(EMKNetworkActivityParticipantCount > 0)];
}



-(void)EMK_removeNetworkActivityParticipant
{
    EMKNetworkActivityParticipantCount--;
    
    [self setNetworkActivityIndicatorVisible:(EMKNetworkActivityParticipantCount > 0)];
}



@end
