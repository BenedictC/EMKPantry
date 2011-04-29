//
//  EMKPantryAppDelegate.m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "EMKPantryAppDelegate.h"
#import "EMKPantryViewController.h"
#import "EMKTestView.h"




@implementation EMKPantryAppDelegate

@synthesize viewController = _viewController;
@synthesize window = _window;


#pragma mark -
#pragma mark Memory management

- (void)dealloc 
{
    [_viewController release];
    [_window release];
    
    [super dealloc];
}





- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
    // Add the view controller's view to the window and display.
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    [self.window addSubview:navController.view];
//    self.viewController.view.frame = [[UIScreen mainScreen] applicationFrame];
    [self.window makeKeyAndVisible];
    
    
    
    
    
    
    
    //Create an array
    CGPoint points[2] = {CGPointMake(10,10), CGPointMake(20, 20)};
    EMKMutableTypedArray *pointArray = [EMKMutableTypedArray typedArrayWithTypeSizeof:sizeof(CGPoint) bytes:points count:2 defaultValue:&CGPointZero];

    CGPoint value;
    uint i, pointCount;
    for (i = 0, pointCount = [pointArray count]; i < pointCount; i++)
    {
        [pointArray getValue:&value atIndex:i];
        NSLog(@"%i: %f, %f", i, value.x, value.y);
    }
    //0: 10, 10
    //1: 20, 20
    
    
    //add a value
    CGPoint point = (CGPoint){.x = 40, .y = 40};
    [pointArray setValue:&point atIndex:3];
    
    for (i = 0, pointCount = [pointArray count]; i < pointCount; i++)
    {
        [pointArray getValue:&value atIndex:i];
        NSLog(@"%i: %f, %f", i, value.x, value.y);
    }
    //0: 10, 10
    //1: 20, 20
    //2: 0, 0
    //3: 40, 40
    
    
    //shrink the array
    [pointArray trimToLength:2];

    for (i = 0, pointCount = [pointArray count]; i < pointCount; i++)
    {
        [pointArray getValue:&value atIndex:i];
        NSLog(@"%i: %f, %f", i, value.x, value.y);
    }
    //0: 10, 10
    //1: 20, 20
    
    
    
    
    return YES;
}








- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}



@end
