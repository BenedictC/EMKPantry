//
//  UINavigationController(EMKRootViewController).m
//  EMKPantry
//
//  Created by Benedict Cohen on 27/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "UINavigationController(EMKRootViewController).h"


@implementation UINavigationController (EMKRootViewController)

-(UIViewController *)EMK_rootViewController
{
    NSArray *viewControllers = self.viewControllers;
    return ([viewControllers count]) ? [viewControllers objectAtIndex:0] : nil;
}

@end
