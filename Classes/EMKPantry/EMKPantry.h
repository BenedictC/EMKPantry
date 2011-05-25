/*
 *  EMKPantry.h
 *  EMKPantry
 *
 *  Created by Benedict Cohen on 16/10/2010.
 *  Copyright 2010 Benedict Cohen. All rights reserved.
 *
 */

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#endif


//TODO: Wrap imports inside #ifdef that check availabilty of required APIs. 
//The checks should probably be added to the .h/.m files too.



//Foundation.framework
//====================
//iOS * and Mac *
#import "EMKTypedArray.h"
#import "EMKMutableTypedArray.h"
#import "NSObject+EMKAccessors.h"
#import "NSObject+EMKKVOSelector.h"
#import "NSMethodSignature+EMKMethodTypeEncoding.h"
#import "NSInvocation+EMKActionInitializer.h"

//iOS 2.0+ and Mac 10.5+
#import "NSOperationQueue+EMKDefaultQueue.h"

//iOS 4.3+ and Mac ?
#import "EMKAssociateDelegate.h"



//CoreData.framework
//==================
//#ifdef _COREDATADEFINES_H
#import "NSManagedObject+EMKFetchRequest.h"
//#endif



//UIKit.framework
//===============
#import "EMKTableViewCell.h"
#import "EMKView.h"
#import "UIApplication+EMKNetworkActivityParticipation.h"
#import "UIButton+EMKAccessoryButton.h"
#import "UILabel+EMKResizing.h"
#import "UINavigationController+EMKRootViewController.h"
#import "UIView+EMKNibLoading.h"
#import "UIView+EMKViewSearching.h"
#import "UIViewController+EMKInitializers.h"
