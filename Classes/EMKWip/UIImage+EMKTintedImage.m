//
//  UIImage+EMKTintedImage.m
//  Jot
//
//  Created by Benedict Cohen on 30/05/2011.
//  Copyright 2011 Electric Muffin Kitchen. All rights reserved.
//

#import "UIImage+EMKTintedImage.h"


@implementation UIImage (EMKTintedImage)


-(UIImage *)EMK_tintedImageWithColor:(UIColor *)color
{
    //create a new context and set the area to the size of the base image
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGRect area = (CGRect){.size = self.size, .origin = CGPointZero};
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);            

    //fill the context with tintColor
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, self.CGImage);
    [color set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    
    //blend baseImage into the ctx
    CGContextSetBlendMode(ctx, kCGBlendModeColorBurn);
    CGContextDrawImage(ctx, area, self.CGImage);


    //Get the finished image, pop the context and return
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

@end
