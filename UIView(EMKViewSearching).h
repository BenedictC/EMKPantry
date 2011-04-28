//
//  UIView(EMKViewSearching).h
//  EMKPantry
//
//  Created by Benedict Cohen on 01/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (EMKViewSearching)
//returns the closest sub view that matches predicate
//the following are ordered by 'closest':
// 1. first subview
// 2. second subview
// 3. first subview of first subview
// 4. second subview of first subview
// 5. first subview of second subview
// 6. second subview of second subview
-(UIView *)EMK_subviewMatchingPredicate:(NSPredicate *)predicate;


//returns the closest superview that isKindOfClass superviewClass
-(UIView *)EMK_superViewOfClass:(Class)superviewClass;
@end
