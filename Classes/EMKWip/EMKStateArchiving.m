//
//  EMKStateArchiving.m
//  EMKPantry
//
//  Created by Benedict Cohen on 28/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKStateArchiving.h"

#pragma mark Archiving proxy
@interface EMKViewControllerArchiveProxy : NSObject <NSCoding>
@property(readonly, retain, nonatomic) UIViewController *viewController;
@property(readwrite, copy, nonatomic) NSString *key;
@property(readwrite, copy, nonatomic) NSArray *tabKeys;

-(id)initWithViewController:(UIViewController *)viewController;
@end


@interface EMKViewControllerArchiver : NSObject
+(NSData *)archiveViewController:(UIViewController *)viewController;
+(UIViewController *)unarchiveViewControllerWithArchive:(NSData *)archive;
@end



#pragma mark EMKViewControllerHierarchyArchiver
@interface EMKViewControllerHierarchyArchiver : NSObject <NSKeyedArchiverDelegate>
+(id<NSKeyedArchiverDelegate>)archiverWithRootObject:(id)rootObject delegate:(id<EMKViewControllerHierarchyArchivingDelegate>)archivingDelegate;
@property (readonly, nonatomic) id rootObject;
@property (readonly, nonatomic) id<EMKViewControllerHierarchyArchivingDelegate> archivingDelegate;
-(id)initWithRootObject:(id)rootObject archivingDelegate:(id<EMKViewControllerHierarchyArchivingDelegate>)archivingDelegate;

@end



#pragma mark EMKViewControllerHierarchyUnarchiver
@interface EMKViewControllerHierarchyUnarchiver : NSObject <NSKeyedUnarchiverDelegate>
+(id<NSKeyedUnarchiverDelegate>)unarchiverWithRootObject:(id)rootObject delegate:(id<EMKViewControllerHierarchyUnarchivingDelegate>)unarchivingDelegate;
@property (readonly, nonatomic) id rootObject;
@property (readonly, nonatomic) id<EMKViewControllerHierarchyUnarchivingDelegate> unarchivingDelegate;
-(id)initWithRootObject:(id)rootObject unarchivingDelegate:(id<EMKViewControllerHierarchyUnarchivingDelegate>)unarchivingDelegate;
@end





#pragma mark EMKViewControllerArchiveProxy implementation
@implementation EMKViewControllerArchiveProxy
@synthesize viewController = viewController_;
@synthesize key = key_;
@synthesize tabKeys = tabKeys_;


-(id)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
    {
        viewController_ = [viewController retain];
    }
    return self;
}



-(void)dealloc
{
    [key_ release];
    [tabKeys_ release];
    [viewController_ release];
    
    [super dealloc];
}



-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        //non vc-objects
        key_ = [[aDecoder decodeObjectForKey:@"key"] retain];
        tabKeys_ = [[aDecoder decodeObjectForKey:@"tabKeys"] retain];

        //common vc objects
        viewController_ = [[EMKViewControllerArchiver unarchiveViewControllerWithArchive:[aDecoder decodeObjectForKey:@"viewControllerArchive"]] retain];
        [viewController_ setViewControllers:[aDecoder decodeObjectForKey:@"viewControllers"]];
        
        //class specific vc objects
        if ([self.viewController isKindOfClass:[UITabBarController class]])
        {
            [viewController_ setSelectedIndex: [aDecoder decodeIntegerForKey:@"selectedIndex"]];
        }
    }
    
    return self;
}



-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //non vc-objects
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.tabKeys forKey:@"tabKeys"];

    //common vc objects
    [aCoder encodeObject:[EMKViewControllerArchiver archiveViewController:self.viewController] forKey:@"viewControllerArchive"]; 
    [aCoder encodeObject:[self.viewController viewControllers] forKey:@"viewControllers"];    

    //class specific vc objects
    if ([self.viewController isKindOfClass:[UITabBarController class]])
    {
        [aCoder encodeInteger:[self.viewController selectedIndex] forKey:@"selectedIndex"];
    }
}

@end



#pragma mark EMKViewControllerHierarchyArchiver
@implementation EMKViewControllerHierarchyArchiver

+(id<NSKeyedArchiverDelegate>)archiverWithRootObject:(id)rootObject delegate:(id<EMKViewControllerHierarchyArchivingDelegate>)archivingDelegate
{
    return [[[EMKViewControllerHierarchyArchiver alloc] initWithRootObject:rootObject archivingDelegate:archivingDelegate] autorelease];
}



@synthesize rootObject = rootObject_;
@synthesize archivingDelegate = archivingDelegate_;


-(id)initWithRootObject:(id)rootObject archivingDelegate:(id<EMKViewControllerHierarchyArchivingDelegate>)archivingDelegate
{
    self = [super init];
    
    if (self)
    {
        rootObject_ = rootObject; //we're not retaining!        
        archivingDelegate_ = archivingDelegate;
    }
    
    return self;
}



-(id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object
{
    NSLog(@"archiving: %@", object);
    
    //we don't archive views or barItems as they don't support NSCoding
    if ([object isKindOfClass:[UIView class]] || [object isKindOfClass:[UIBarItem class]]) return nil;

    
    if ([object isKindOfClass:[UISplitViewController class]])
    {
        //1.create proxy and         //2.add viewController to proxy
        EMKViewControllerArchiveProxy *archiveProxy = [[[EMKViewControllerArchiveProxy alloc] initWithViewController:object] autorelease];
        
        //3.add key for the tab bar controller to proxy
        NSString *splitControllerKey = (object != self.rootObject && [self.archivingDelegate respondsToSelector:@selector(viewController:keyForSplitViewController:)]) 
                                        ? [self.archivingDelegate viewController:self.rootObject keyForSplitViewController:object] : nil;
        archiveProxy.key = splitControllerKey;
        
        //4.done!
        return archiveProxy;
    }
    
    
    
    if ([object isKindOfClass:[UINavigationController class]])
    {
        //1.create proxy and //2.add viewController to proxy
        EMKViewControllerArchiveProxy *archiveProxy = [[[EMKViewControllerArchiveProxy alloc] initWithViewController:object] autorelease];
        
        //3.add key for the tab bar controller to proxy
        NSString *navControllerKey = (object != self.rootObject && [self.archivingDelegate respondsToSelector:@selector(viewController:keyForNavigationController:)]) 
                                      ? [self.archivingDelegate viewController:self.rootObject keyForNavigationController:object] : nil;
        archiveProxy.key = navControllerKey;
        
        //4.done!
        return archiveProxy;
    }

    
    
    if ([object isKindOfClass:[UITabBarController class]])
    {
        //1.create proxy and //2.add viewController to proxy
        EMKViewControllerArchiveProxy *archiveProxy = [[[EMKViewControllerArchiveProxy alloc] initWithViewController:object] autorelease];
        
        //3.add key for the tab bar controller to proxy
        NSString *tabBarControllerKey = (object != self.rootObject && [self.archivingDelegate viewController:self.rootObject keyForTabBarController:object]) 
                                        ? [self.archivingDelegate viewController:self.rootObject keyForTabBarController:object] : nil;
        archiveProxy.key = tabBarControllerKey;            
        
        //4.add the key for each tab to the proxy
        NSMutableArray *tabKeys = [NSMutableArray array];
        BOOL canFetchKey = [self.archivingDelegate respondsToSelector:@selector(viewController:keyForTab:ofTabBarController:withKey:)];
        for (UIViewController *vc in [object viewControllers])
        {
            NSString *tabKey = (!canFetchKey) ? @"" : [self.archivingDelegate viewController:self.rootObject keyForTab:vc ofTabBarController:object withKey:tabBarControllerKey];
            [tabKeys addObject:tabKey];
        }
        archiveProxy.tabKeys = tabKeys;
        
        //5.done!
        return archiveProxy;
    }
    
    return object;
}

@end



#pragma mark EMKViewControllerHierarchyUnarchiver
@implementation EMKViewControllerHierarchyUnarchiver

+(id<NSKeyedUnarchiverDelegate>)unarchiverWithRootObject:(id)rootObject delegate:(id<EMKViewControllerHierarchyUnarchivingDelegate>)unarchivingDelegate
{
    return [[[EMKViewControllerHierarchyUnarchiver alloc] initWithRootObject:rootObject unarchivingDelegate:unarchivingDelegate] autorelease];
}


@synthesize rootObject = rootObject_;
@synthesize unarchivingDelegate = unarchivingDelegate_;



-(id)initWithRootObject:(id)rootObject unarchivingDelegate:(id<EMKViewControllerHierarchyUnarchivingDelegate>)unarchivingDelegate
{
    self = [super init];
    
    if (self)
    {
        rootObject_ = rootObject; //we're not retaining!        
        unarchivingDelegate_ = unarchivingDelegate;
    }
    
    return self;
}



-(id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object
{

    
    if ([object isKindOfClass:[EMKViewControllerArchiveProxy class]])
    {
        UIViewController *vc = [object viewController];
        if ([vc isKindOfClass:[UITabBarController class]] && [self.unarchivingDelegate respondsToSelector:@selector(viewController:restoreTabViewController:withTabKey:ofTabBarControllerWithKey:)]) 
        {
            [self.unarchivingDelegate viewController:vc didUnarchiveTabBarControllerWithKey:[object key]];
            //TODO: restore each tab
        }
        
        if ([vc isKindOfClass:[UINavigationController class]] && [self.unarchivingDelegate respondsToSelector:@selector(viewController:didUnarchiveNavigationControllerWithKey:)])
        {
            [self.unarchivingDelegate viewController:vc didUnarchiveNavigationControllerWithKey:[object key]];
        }
        
        if ([vc isKindOfClass:[UISplitViewController class]] && [self.unarchivingDelegate respondsToSelector:@selector(viewController:didUnarchiveSplitViewControllerWithKey:)])
        {
            [self.unarchivingDelegate viewController:vc didUnarchiveSplitViewControllerWithKey:[object key]];
        }
        
        return vc;
    }
    
    NSLog(@"unarchiving: %@", object);        
    return object;
}



@end









#pragma mark UIViewController (EMKViewControllerHierarchyArchiving) 
@implementation NSObject (EMKViewControllerHierarchyArchiving) 
//Returns NSData which can be passed to EMK_unarchiveViewControllersFromArchive
-(NSData *)EMK_archivedViewControllerHierarchyWithArchivingDelegate:(id<EMKViewControllerHierarchyArchivingDelegate>)delegate;
{
    NSMutableData *viewControllerArchive = [NSMutableData data];
    
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:viewControllerArchive] autorelease];
    [archiver setDelegate:[EMKViewControllerHierarchyArchiver archiverWithRootObject:self delegate:delegate]];
    [archiver encodeObject:self forKey:@"rootViewController"];
    [archiver finishEncoding];

    return viewControllerArchive;
}



//Returns non-nil if the hierarchy is functionaly sufficent
+(id)EMK_viewControllerHierarchyFromArchive:(NSData *)viewControllerArchive unarchivingDelegate:(id<EMKViewControllerHierarchyUnarchivingDelegate>)delegate;
{
    //0. prep archiver
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:viewControllerArchive] autorelease];
    [unarchiver setDelegate:[EMKViewControllerHierarchyUnarchiver unarchiverWithRootObject:self delegate:delegate]];
    
    
    //1. unarchive
    UIViewController *rootViewController = [unarchiver decodeObjectForKey:@"rootViewController"];    
    [unarchiver finishDecoding];
    
    
    //2. restore
    
    
    //3. done!
    return rootViewController;
}

@end


@implementation EMKViewControllerArchiver

+(NSData *)archiveViewController:(UIViewController *)viewController
{
    NSMutableData *archive = [NSMutableData data];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:archive] autorelease];
    [archiver setDelegate:self];
    [archiver encodeObject:viewController forKey:@"vc"];
    [archiver finishEncoding];
    
    return archive;
}


+(id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object
{
    if ([object isKindOfClass:[UIView class]] || [object isKindOfClass:[UIBarItem class]]) return nil;
    
    return object;
}


+(UIViewController *)unarchiveViewControllerWithArchive:(NSData *)archive
{
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:archive] autorelease];
    UIViewController *vc = [unarchiver decodeObjectForKey:@"vc"];
    [unarchiver finishDecoding];
    
    return vc;
}
@end


