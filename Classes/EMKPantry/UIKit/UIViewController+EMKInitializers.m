//
//  UIViewController+EMKInitializers.m
//  EMKPantry
//
//  Created by Benedict Cohen on 21/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "UIViewController+EMKInitializers.h"


@implementation UIViewController (EMKInitializers)

+(id)EMK_defaultNibName
{
    return NSStringFromClass(self);
}
                                        


+(id)EMK_viewControllerWithDefaultNib
{
    return [[[[self class] alloc] EMK_initWithDefaultNib] autorelease];
}



-(id)EMK_initWithDefaultNib
{
    return [self initWithNibName:[[self class] EMK_defaultNibName] bundle:nil];
}
                                        
                                        


@end
