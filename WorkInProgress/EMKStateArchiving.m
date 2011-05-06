//
//  EMKStateArchiving.m
//  EMKPantry
//
//  Created by Benedict Cohen on 28/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKStateArchiving.h"


#pragma mark EMKNavigationStackArchiverDelegate
//TODO: This is pretty dirty.
//The delegate methods are implemented as class methods. We should provide a proper instance.
@interface EMKStateArchivingDelegate : NSObject <NSKeyedArchiverDelegate>
+(id<NSKeyedArchiverDelegate>)sharedArchivingDelegate;
+(NSString *)navigationStackKey;
+(NSString *)tabContentsKey;
+(NSString *)tabKeysKey;    
+(NSString *)customizableIndexesKey;
+(NSString *)selectedIndexKey;    
@end;





#pragma mark EMKNavigationStackArchiverDelegate
@implementation EMKStateArchivingDelegate
/*
 This implementation is pretty dirty.
 If you can figure out what's going on then "well done, you!"
 If you can't figure out what's going on then that's all the evidence you need to know it's dirty.
 
 */

#pragma mark singleton
+(id<NSKeyedArchiverDelegate>)sharedArchivingDelegate
{
    return (id<NSKeyedArchiverDelegate>)self;
}



#pragma mark delegate methods
+ (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object
{
    //TODO: This needs to exclude anything that contains a UIView
    
    return ([object isKindOfClass:[UIView class]]) ? nil : object;
}



#pragma mark archiving keys
+(NSString *)navigationStackKey
{
    static NSString *key = @"EMKStateArchivingNavigationStackKey";
    return key;
}

+(NSString *)tabContentsKey
{
    static NSString *key = @"EMKStateArchivingTabContentsKey";
    return key;
}

+(NSString *)tabKeysKey
{
    static NSString *key = @"EMKStateArchivingTabKeysKey";
    return key;
}

+(NSString *)customizableIndexesKey
{
    static NSString *key = @"EMKStateArchivingCustomizableIndexesKey";
    return key;
}

+(NSString *)selectedIndexKey
{
    static NSString *key = @"EMKStateArchivingSelectedIndexKey";
    return key;
}

@end





#pragma mark UINavigationController (EMKStateArchiving)
@implementation UINavigationController (EMKStateArchiving)



-(NSData *)EMK_archiveViewControllers
{
    NSMutableData *stackData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:stackData] autorelease];

    [archiver setDelegate:[EMKStateArchivingDelegate sharedArchivingDelegate]];
    [archiver encodeObject:self.viewControllers forKey:[EMKStateArchivingDelegate navigationStackKey]];
    [archiver finishEncoding];
    
    return stackData;
}




//Returns YES if at least 1 view controller was restored
-(BOOL)EMK_restoreViewControllersFromArchive:(NSData *)navStackData withRootViewControllerRestorer:(id<EMKStateRestoration>)rootRestorer
{
    if (navStackData == nil) return NO;
    
    
    //1. get the view controllers from the archive
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:navStackData] autorelease];
    NSArray *viewControllers = [unarchiver decodeObjectForKey:[EMKStateArchivingDelegate navigationStackKey]];
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

-(NSData *)EMK_archiveViewControllersWithArchivingDelegate:(id<UITabBarController_EMKArchivingDelegate>)delegate
{
    NSArray *customizableViewControllers = self.customizableViewControllers;
    NSUInteger capacity = [customizableViewControllers count];
    NSMutableArray *tabKeys = [NSMutableArray arrayWithCapacity:capacity];//10 is arbitary
    NSMutableArray *tabContents = [NSMutableArray arrayWithCapacity:capacity];//10 is arbitary
    NSMutableIndexSet *customizableIndexes = [NSMutableIndexSet indexSet];
    
    //Get the state of each tab
    int currentIndex = 0;
    for (UIViewController *vc in self.viewControllers)
    {
        //tab key
        NSString *tabKey = ([delegate respondsToSelector:@selector(EMK_tabBarController:keyForTab:)]) ? [delegate EMK_tabBarController:self keyForTab:vc]: nil;
        [tabKeys addObject:(tabKey)?: [NSNull null]];
        
        //tab content
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            [tabContents addObject:[(UINavigationController *)vc EMK_archiveViewControllers]];
        }
        else
        {
            [tabContents addObject:vc];
        }
        
        //is tab customizable
        if ([customizableViewControllers containsObject:vc])
        {
            [customizableIndexes addIndex:currentIndex];
        }
        
        //prep for next vc
        currentIndex++;
    }
    
    //create the archiver...
    NSMutableData *archivedContent = [NSMutableData data];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:archivedContent] autorelease];
    [archiver setDelegate:[EMKStateArchivingDelegate sharedArchivingDelegate]];
    
    //...and archive the tabs
    [archiver encodeObject:tabContents forKey:[EMKStateArchivingDelegate tabContentsKey]];
    [archiver encodeObject:tabKeys forKey:[EMKStateArchivingDelegate tabKeysKey]];    
    [archiver encodeObject:customizableIndexes forKey:[EMKStateArchivingDelegate customizableIndexesKey]];
    [archiver encodeInteger:self.selectedIndex forKey:[EMKStateArchivingDelegate selectedIndexKey]];    
    [archiver finishEncoding];
    
    return archivedContent;
}



-(BOOL)EMK_restoreViewControllersFromArchive:(NSData *)tabContentsArchive withUnarchivingDelegate:(id<UITabBarController_EMKUnarchivingDelegate>)delegate
{
    if (tabContentsArchive == nil) return NO;

    //1. unarchive the tabs
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:tabContentsArchive] autorelease];
    NSArray *tabContents = [unarchiver decodeObjectForKey:[EMKStateArchivingDelegate tabContentsKey]];
    NSArray *tabKeys = [unarchiver decodeObjectForKey:[EMKStateArchivingDelegate tabKeysKey]];    
    NSIndexSet *customizableIndexes = [unarchiver decodeObjectForKey:[EMKStateArchivingDelegate customizableIndexesKey]];
    NSUInteger selectedIndex = [unarchiver decodeIntegerForKey:[EMKStateArchivingDelegate selectedIndexKey]];    
    [unarchiver finishDecoding];
    
    
    //2. restore and validate tabs
    SEL restoreDependantViewControllersSelector = @selector(EMK_tabBarController:rootRestorerForTabWithKey:);
    SEL didRestoreTabSelector = @selector(EMK_tabBarController:didRestoreTab:forKey:);
    NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:[tabContents count]]; //10 is arbitary    
    
    int tabIndex = 0;
    for (id tabContent in tabContents)
    {
        id key = [tabKeys objectAtIndex:tabIndex];
        BOOL isRestorationPossible = key != [NSNull null] && [delegate respondsToSelector:restoreDependantViewControllersSelector];
        
        id<EMKStateRestoration> restorer = (isRestorationPossible) ? [delegate EMK_tabBarController:self rootRestorerForTabWithKey:key] : nil;
        
        //the content of navigation controllers is stored as an array
        //if tabContent is a viewController then we do not have a navController
        if ([tabContent isKindOfClass:[UIViewController class]])
        {
            [restorer restoreDependantViewControllers:tabContent];            
            [tabs addObject:tabContent];
        }
        else
        {
            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:nil] autorelease];
            [navController EMK_restoreViewControllersFromArchive:tabContent withRootViewControllerRestorer:restorer];
            [tabs addObject:navController];
            if ([delegate respondsToSelector:didRestoreTabSelector])
            {
                [delegate EMK_tabBarController:self didRestoreTab:navController withKey:key];
            }
        }
             
         //prep for next vc
         tabIndex++;
    }
    
    
    //3. reconstruct customizableViewControllers
    int i = [customizableIndexes firstIndex];
    NSMutableArray *customizableViewControllers = [NSMutableArray arrayWithCapacity:[tabContents count]]; 
    while (i != NSNotFound)
    {
        [customizableViewControllers addObject:[tabs objectAtIndex:i]];
        i = [customizableIndexes indexGreaterThanIndex:i];
    }


    //4. reinstate the tabs
    self.viewControllers = tabs;    
    self.customizableViewControllers = customizableViewControllers;
    self.selectedIndex = selectedIndex;

         
    //TODO: we need to do some validation!
    return YES;
}


@end

