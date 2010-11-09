//
//  UIApplication(EMKNetworkActivityParticipation).h
//  EMKPantry
//
//  Created by Benedict Cohen on 09/11/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIApplication (EMKNetworkActivityParticipation)

-(void)EMK_addNetworkActivityParticipant:(id)participant;
-(void)EMK_removeNetworkActivityParticipant:(id)participant;

@end
