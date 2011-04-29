//
//  EMKPantryAppDelegate.h
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMKPantryAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *_window;
    UIViewController *_viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;

@end

