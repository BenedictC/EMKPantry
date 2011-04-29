//
//  EMKStateArchiving.m
//  Jot
//
//  Created by Benedict Cohen on 28/04/2011.
//  Copyright 2011 Electric Muffin Kitchen. All rights reserved.
//

#import "EMKStateArchiving.h"


#pragma mark EMKNavigationStackArchiverDelegate
//TODO: This is pretty dirty.
//The delegate methods are implemented as class methods. We should provide a proper instance.
@interface EMKNavigationStackArchiverDelegate : NSObject <NSKeyedArchiverDelegate>
+(id<NSKeyedArchiverDelegate>)sharedArchiverDelegate;
+(NSString *)archiverKey;
@end;





#pragma mark EMKNavigationStackArchiverDelegate
@implementation EMKNavigationStackArchiverDelegate
/*
 This implementation is pretty dirty.
 If you can figure out what's going on then "well done, you!"
 If you can't figure out what's going on then that's all the evidence you need to know it's dirty.
 
 */


+(id<NSKeyedArchiverDelegate>)sharedArchiverDelegate
{
    return (id<NSKeyedArchiverDelegate>)self;
}



+ (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object
{
    //TODO: This needs to exclude anything that contains a UIView
    
    return ([object isKindOfClass:[UIView class]]) ? nil : object;
}



+(NSString *)archiverKey
{
    static NSString *key = @"EMKNavigationStackArchiveRootKey";
    
    return key;
}

@end





#pragma mark UINavigationController (EMKStateArchiving)
@implementation UINavigationController (EMKStateArchiving)



-(NSData *)EMK_archiveViewControllers
{
    NSMutableData *stackData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:stackData] autorelease];

    [archiver setDelegate:[EMKNavigationStackArchiverDelegate sharedArchiverDelegate]];
    [archiver encodeObject:self.viewControllers forKey:[EMKNavigationStackArchiverDelegate archiverKey]];
    [archiver finishEncoding];
    
    return stackData;
}




//Returns YES if at least 1 view controller was restored
-(BOOL)EMK_restoreViewControllersFromArchive:(NSData *)navStackData withRootViewControllerRestorer:(id<EMKStateRestoration>)rootRestorer
{
    if (navStackData == nil) return NO;
    
    
    //1. get the view controllers from the archive
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:navStackData] autorelease];
    NSArray *viewControllers = [unarchiver decodeObjectForKey:[EMKNavigationStackArchiverDelegate archiverKey]];
    [unarchiver finishDecoding];
    
    
    //2. restore and validate
    SEL restoreDependantViewControllersSelector = @selector(restoreDependantViewControllers:);
    UIViewController<EMKStateRestoration> *lastValidViewController = nil;
    id<EMKStateRestoration> restorer = rootRestorer;
    
    for (UIViewController<EMKStateRestoration> *viewController in viewControllers)
    {
        //we only restore valid view controllers (as determined by the result of restoreDependantViewControllers: from their restorer)
        if ([restorer respondsToSelector:restoreDependantViewControllersSelector] && [restorer restoreDependantViewControllers:viewController])
        {
            lastValidViewController = viewController;
            restorer = viewController; //TODO: do we want to be more flexible?
        }
        else
        {
            break;
        }
    }
    
    
    //3. reinstate the view controllers
    NSUInteger indexOfLastValidVC = [viewControllers indexOfObject:lastValidViewController];
    self.viewControllers = (indexOfLastValidVC == NSNotFound) ? [NSArray array] : [viewControllers subarrayWithRange:NSMakeRange(0, 1+indexOfLastValidVC)];
    
    
    return (indexOfLastValidVC != NSNotFound);
}



@end





#pragma mark UINavigationController (EMKStateArchiving)
@implementation UITabBarController (EMKStateArchiving)

-(NSData *)EMK_archiveViewControllers
{
    NSArray *customizableViewControllers = self.customizableViewControllers;
    NSMutableArray *tabContent = [NSMutableArray arrayWithCapacity:10];//10 is arbitary
    NSMutableIndexSet *customizableIndexes = [NSMutableIndexSet indexSet];
    
    int currentIndex = 0;
    for (UIViewController *vc in self.viewControllers)
    {
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            [tabContent addObject:[(UINavigationController *)vc EMK_archiveViewControllers]];
        }
        else
        {
            [tabContent addObject:vc];
        }
        
        if ([customizableViewControllers containsObject:vc])
        {
            [customizableIndexes addIndex:currentIndex];
        }
        
        currentIndex++;
    }
    
    NSMutableData *archivedContent = [NSMutableData data];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:archivedContent] autorelease];

    [archiver setDelegate:[EMKNavigationStackArchiverDelegate sharedArchiverDelegate]];
    [archiver encodeObject:tabContent forKey:[EMKNavigationStackArchiverDelegate archiverKey]];
    [archiver encodeInteger:self.selectedIndex forKey:@"selectedIndex"];
    [archiver encodeObject:customizableIndexes forKey:@"customizableIndexes"];    
    [archiver finishEncoding];
    
    //TODO: we also need to archive the selected tab and customizableViewControllers    
    
    return archivedContent;
}



-(BOOL)EMK_restoreViewControllersFromArchive:(NSData *)tabContentsArchive withRootViewControllerRestorer:(id<EMKStateRestoration>)rootRestorer
{
    if (tabContentsArchive == nil) return NO;

    
    //1. get the view controllers from the archive
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:tabContentsArchive] autorelease];
    NSArray *tabContents = [unarchiver decodeObjectForKey:[EMKNavigationStackArchiverDelegate archiverKey]];
    NSIndexSet *customizableIndexes = [unarchiver decodeObjectForKey:@"customizableIndexes"];
    NSUInteger selectedIndex = [unarchiver decodeObjectForKey:@"selectedIndex"];    
    [unarchiver finishDecoding];
    
    
    //2. restore and validate
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:10]; //10 is arbitary
    SEL restoreDependantViewControllersSelector = @selector(restoreDependantViewControllers:);
    UIViewController<EMKStateRestoration> *lastValidViewController = nil;
    id<EMKStateRestoration> restorer = rootRestorer;
    
    for (id tabContent in tabContents)
    {
        if ([tabContent isKindOfClass:[UIViewController class]])
        {
            [viewControllers addObject:tabContent];
            //who's the restorer?            
        }
        else
        {
            //create a nav controller and EMK_restoreViewControllers with tabContent
            //who's the restorer?
        }
    }
    
    
    //3. reinstate the view controllers
    NSUInteger indexOfLastValidVC = [viewControllers indexOfObject:lastValidViewController];
    self.viewControllers = (indexOfLastValidVC == NSNotFound) ? [NSArray array] : [viewControllers subarrayWithRange:NSMakeRange(0, 1+indexOfLastValidVC)];
    
    
    return (indexOfLastValidVC != NSNotFound);
}


@end
//How do we restore non-nav tabs?
//-(void)EMK_tabBarController:(UITabBarController *)tabBarController restoreViewController:(UIViewController *)vc atIndex:(NSUInteger)index;


//How do we get the restorer for each nav stack?
//How do we distingush between nav stacks?

//-(id<EMKStateRestorer>)EMK_tabBarController:(UITabBarController *)tabBarController rootRestorerForNavigationController:(UIViewController *)vc atIndex:(NSUInteger)index;

//-(void)EMK_tabBarController:(UITabBarController *)tabBarController didRestoreNavigationController:(UINavigationController *)navController forTabAtIndex:(NSUInteger)index;

//-(void)EMK_tabBarController:(UITabBarController *)tabBarController restorerViewController:(UIViewController *)vc withIndex:(NSUInteger)index;

