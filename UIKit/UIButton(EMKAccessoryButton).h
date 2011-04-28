//
//  UIButton(EMKAccessoryButton).h
//  EMKPantry
//
//  Created by Benedict Cohen on 03/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIButton (EMKAccessoryButton)

+(UIButton *)EMK_accessoryButtonWithImage:(UIImage *)defaultImage;
-(IBAction)EMK_invokeTableViewAccessoryButtonTappedForRowWithIndexPath:(id)sender;

@end
