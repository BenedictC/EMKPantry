//
//  UIView(EMKViewSearching).m
//  EMKPantry
//
//  Created by Benedict Cohen on 01/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "UIView(EMKViewSearching).h"


@implementation UIView (EMKViewSearching)


-(UIView *)EMK_subviewMatchingPredicate:(NSPredicate *)predicate
{
    NSArray *subviews = [self subviews];
    
    NSMutableArray *nonMatchingSubviews = [NSMutableArray arrayWithCapacity:[subviews count]];
    
    //search direct subviews
    for (UIView *subview in subviews)
    {
        if ([predicate evaluateWithObject: subview])
        {
            return subview;
        }
        
        [nonMatchingSubviews addObject:subview];
    }
    
    
    //search subviews of the non matching subviews
    for (UIView *nonMatchingSubview in nonMatchingSubviews)
    {
        UIView *subSubView = [nonMatchingSubview EMK_subviewMatchingPredicate:predicate];
        if (subSubView) return subSubView;
    }

    return nil;
}



-(UIView *)EMK_superViewOfClass:(Class)superviewClass
{
    UIView *superview = [self superview];
    
    while (superview && ![superview isKindOfClass:superviewClass])
    {
        superview = [superview superview];

    } 
    
    return superview;
}



@end
