//
//  UIView(EMKNibLoading).m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "UIView(EMKNibLoading).h"


@implementation UIView (EMKNibLoading)


+(NSString *)EMK_defaultNibName
{
    return NSStringFromClass(self);
}



+(id)EMK_viewWithNibNamed:(NSString *)nibName
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    
    for (id<NSObject> nibItem in nibContents)
    {
        if ([nibItem isKindOfClass:self]) return nibItem;
    }
    
    return nil;
}



+(id)EMK_viewWithDefaultNib
{
    return [self EMK_viewWithNibNamed:[self EMK_defaultNibName]];
}



//#ifdef >IOS4
+(id)EMK_viewWithNib:(UINib *)nib
{
    NSArray *nibContents = [nib instantiateWithOwner:nil options:nil];
    
    for (id<NSObject> nibItem in nibContents)
    {
        if ([nibItem isKindOfClass:self]) return nibItem;
    }
    
    return nil;
}
//#endif



@end
