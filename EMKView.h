//
//  EMKView.h
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EMKView : UIView
{
    NSMutableDictionary *_subViews;
}

@property(readonly, retain) NSMutableDictionary *subViews;

@end




@interface EMKTableViewCell : UITableViewCell
{
    NSMutableDictionary *_subViews;    
}

@property(readonly, retain) NSMutableDictionary *subViews;

@end




#define EMK_COMPOSITE_VIEW_IMPLEMENTION_WITHOUT_PROPERTIES(CLASSNAME) \
@implementation CLASSNAME \
\
+(CLASSNAME*)view  \
{ \
    return (CLASSNAME*)[CLASSNAME EMK_viewWithDefaultNib]; \
} \
@end




#define EMK_COMPOSITE_VIEW_IMPLEMENTION(CLASSNAME, PROPERTIES...) \
@implementation CLASSNAME \
\
@dynamic PROPERTIES;\
\
+(CLASSNAME*)view  \
{ \
return (CLASSNAME*)[CLASSNAME EMK_viewWithDefaultNib]; \
} \
@end




