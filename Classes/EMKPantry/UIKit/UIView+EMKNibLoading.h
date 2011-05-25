//
//  UIView+EMKNibLoading.h
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (EMKNibLoading)

+(NSString *)EMK_defaultNibName;
+(id)EMK_viewWithNibNamed:(NSString *)nibName;
+(id)EMK_viewWithDefaultNib;

//#ifdef IOS4
+(id)EMK_viewWithNib:(UINib *)nib;
//#endif


@end


