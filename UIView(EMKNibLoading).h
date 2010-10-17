//
//  UIView(EMKNibLoading).h
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (EMKNibLoading)

+(NSString*)EMK_defaultNibName;

+(id)EMK_viewWithNib:(NSString*)nibName;

+(id)EMK_viewWithDefaultNib;




@end


