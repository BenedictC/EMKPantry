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
    NSMutableDictionary *_dynamicProperties;
}


@end



id EMKViewDynamicGetter(id self, SEL _cmd);
void EMKViewDynamicSetter(id self, SEL _cmd, id value);