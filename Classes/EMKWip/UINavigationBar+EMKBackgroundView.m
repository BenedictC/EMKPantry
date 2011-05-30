//
//  UINavigationBar+EMKBackgroundView.m
//  EMKPantry
//
//  Created by Benedict Cohen on 28/05/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "UINavigationBar+EMKBackgroundView.h"



@implementation UINavigationBar (EMKBackgroundView)

@dynamic emk_backgroundView;
@dynamic emk_shouldDrawDefaultBackground;

+(void)load
{
    //Add the properties
    [self EMK_addObjectProperty:@"emk_backgroundView" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    [self EMK_addScalarProperty:@"emk_shouldDrawDefaultBackground" size:sizeof(BOOL) defaultValue:&(BOOL){YES}];    

    
    SEL insertSubviewAtIndexSelector = @selector(insertSubview:atIndex:);
    IMP originalInsertSubviewAtIndex = [self instanceMethodForSelector:insertSubviewAtIndexSelector];
    [self EMK_replaceInstanceMethodForSelector:insertSubviewAtIndexSelector withImplementationBlock:(void *)^(UINavigationBar *self, UIView *subview, int index)
     {
         UIImageView *backgroundImage = [self EMK_getValueForObjectProperty:@"emk_backgroundView"];
         int backgroundIndex = [[self subviews] indexOfObject:backgroundImage];
         int adjustedIndex = (backgroundIndex != NSNotFound && index <= backgroundIndex) ? backgroundIndex+1 : index;
         
         originalInsertSubviewAtIndex(self, insertSubviewAtIndexSelector, subview, adjustedIndex);
     }];
    
    
    
    SEL drawRectSelector = @selector(drawRect:);
    IMP originalDrawRect = [self instanceMethodForSelector:drawRectSelector];
    [self EMK_replaceInstanceMethodForSelector:drawRectSelector withImplementationBlock:(void *)^(UINavigationBar *self, CGRect rect)
     {
         if (*self.emk_shouldDrawDefaultBackground)
         {
             originalDrawRect(self, drawRectSelector, rect);
         }
     }];
}



-(void)setEmk_backgroundView:(UIView *)backgroundView
{
    //get the background view
    UIView *oldBackgroundView = [self EMK_getValueForObjectProperty:@"emk_backgroundView"];
    
    if (oldBackgroundView == backgroundView) return;
    
    //get rid of old view
    [oldBackgroundView removeFromSuperview];
    
    //store new view
    [self EMK_setValue:backgroundView forObjectProperty:@"emk_backgroundView"];
    [self insertSubview:backgroundView atIndex:0];
}



-(void)setEmk_shouldDrawDefaultBackground:(BOOL *)emk_shouldDrawDefaultBackground
{
    [self EMK_setValue:emk_shouldDrawDefaultBackground forScalarProperty:@"emk_shouldDrawDefaultBackground"];
    [self setNeedsDisplay];
}



@end
