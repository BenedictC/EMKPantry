//
//  EMKStateArchiving.h
//  Jot
//
//  Created by Benedict Cohen on 28/04/2011.
//  Copyright 2011 Electric Muffin Kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark EMKStateRestoration protocol
@protocol EMKStateRestoration <NSObject>
@required
//returns YES if the dependant view controllers were successfully restored.
-(BOOL)restoreDependantViewControllers:(UIViewController *)navStackViewController;

@optional
-(id<EMKStateRestoration>)restorerForViewController:(UIViewController *)viewController;
@end



#pragma mark UINavigationController, EMKStateArchiving protocol
@interface UINavigationController (EMKStateArchiving) 
//Returns NSData to pass to EMK_restoreViewControllersFromArchive
-(NSData *)EMK_archiveViewControllers;
//Returns YES if at least 1 view controller was restored
-(BOOL)EMK_restoreViewControllersFromArchive:(NSData *)navStackData withRootViewControllerRestorer:(id<EMKStateRestoration>)rootRestorer;
@end



#pragma mark UITabBarController, EMKStateArchiving protocol
@interface UITabBarController (EMKStateArchiving)
//Returns NSData to pass to EMK_restoreViewControllersFromArchive
-(NSData *)EMK_archiveViewControllers;
//Returns YES if at least 1 view controller was restored
-(BOOL)EMK_restoreViewControllersFromArchive:(NSData *)navStackData withRootViewControllerRestorer:(id<EMKStateRestoration>)rootRestorer;

/*
//TODO

 - Is it acceptable to leave config until restoration has finished or should there be delegate methods?
 - UINavigationController should not be subclassed but... ???
 - How does the tabbar controller know if it's unarchiving a UINavC or generic UIViewC?
 
*/
@end
