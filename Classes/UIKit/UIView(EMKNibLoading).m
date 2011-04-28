//
//  UIView(EMKNibLoading).m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "UIView(EMKNibLoading).h"
#import <objc/runtime.h>


@implementation UIView (EMKNibLoading)



+(NSString*)EMK_defaultNibName
{
    return NSStringFromClass(self);
}



+(id)EMK_viewWithNib:(NSString*)nibName
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];

    for (id nibItem in nibContents)
    {
        if ([nibItem isKindOfClass:[UIView class]]) return nibItem;
    }
    
    return nil;
}




+(id)EMK_viewWithDefaultNib
{
    return [self EMK_viewWithNib:[[self class] EMK_defaultNibName]];
}


@end