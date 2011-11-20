//
//  UINavigationBar+EMKBackgroundView.h
//  EMKPantry
//
//  Created by Benedict Cohen on 28/05/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationBar (EMKBackgroundView)

@property(readwrite, retain, nonatomic) UIView *emk_backgroundView;
@property(readwrite, assign, nonatomic) BOOL *emk_shouldDrawDefaultBackground;

@end
