//
//  EMKStateArchiving.h
//  EMKPantry
//
//  Created by Benedict Cohen on 28/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark protocols for supporting EMKViewControllerHierarchyArchiving
@protocol EMKViewControllerHierarchyArchivingDelegate <NSObject>
-(NSString *)viewController:(UIViewController *)viewController keyForNavigationController:(UINavigationController *)navViewController;
-(NSString *)viewController:(UIViewController *)viewController keyForSplitViewController:(UISplitViewController *)splitViewController;
-(NSString *)viewController:(UIViewController *)viewController keyForTabBarController:(UITabBarController *)tabBarController;

-(NSString *)viewController:(UIViewController *)viewController keyForTab:(UIViewController *)tabViewController ofTabBarController:(UITabBarController *)tabBarController withKey:(NSString *)key;
@end


@protocol EMKViewControllerHierarchyUnarchivingDelegate <NSObject>
//Can these be merged with the following set of methods?
//the only sticking point is tabBarController which would be called multiple times
-(void)viewController:(UIViewController *)rootViewController didUnarchiveNavigationControllerWithKey:(NSString *)key;
-(void)viewController:(UIViewController *)rootViewController didUnarchiveSplitViewControllerWithKey:(NSString *)key;
-(void)viewController:(UIViewController *)rootViewController didUnarchiveTabBarControllerWithKey:(NSString *)key;

//returns YES if the view controllers were successfully restored.
//These needs to be called from leaf down to root. Consider what would happen if a split view with a navigation as a master was not able to fully restore itself.
//if a method is not implemented return NO and log a warning.
-(BOOL)restoreViewController:(UIViewController *)viewController;
-(BOOL)viewController:(UIViewController *)rootViewController restoreRootViewController:(UIViewController *)rootViewController forNavigationControllerWithKey:(NSString *)key;
-(BOOL)viewController:(UIViewController *)rootViewController restoreMasterViewController:(UIViewController *)masterViewController detailViewController:(UIViewController *)detailViewController forSplitViewControllerWithKey:(NSString *)key;
-(BOOL)viewController:(UIViewController *)rootViewController restoreTabViewController:(UIViewController *)viewController withTabKey:(NSString *)tabKey ofTabBarControllerWithKey:(NSString *)key;
@end



@protocol EMKDependentViewControllerRestoration <NSObject>
@required
//returns YES if the dependant view controllers were successfully restored.
-(BOOL)restoreDependantViewControllers:(UIViewController *)nextNavStackViewController;
@end




#pragma mark EMKViewControllerHierarchyArchiving category
@interface NSObject (EMKViewControllerHierarchyArchiving) 
//Returns NSData which can be passed to EMK_unarchiveViewControllersFromArchive
-(NSData *)EMK_archivedViewControllerHierarchyWithArchivingDelegate:(id<EMKViewControllerHierarchyArchivingDelegate>)delegate;
//Returns non-nil if the hierarchy is functionaly sufficent
+(id)EMK_viewControllerHierarchyFromArchive:(NSData *)viewControllerArchive unarchivingDelegate:(id<EMKViewControllerHierarchyUnarchivingDelegate>)delegate;
@end
