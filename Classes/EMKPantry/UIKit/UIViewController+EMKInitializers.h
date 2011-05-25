//
//  UIViewController(EMKInitializers).h
//  EMKPantry
//
//  Created by Benedict Cohen on 21/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (EMKInitializers)

+(id)EMK_defaultNibName;
+(id)EMK_viewControllerWithDefaultNib;

-(id)EMK_initWithDefaultNib;


@end
