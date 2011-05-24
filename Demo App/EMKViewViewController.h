//
//  EMKViewViewController.h
//  EMKPantry
//
//  Created by Benedict Cohen on 29/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMKTestView;
@interface EMKViewViewController : UIViewController 
{
    
}

@property(readwrite, retain) IBOutlet EMKTestView *testView;
-(void)testAccessors;
-(void)testViewLoading;
@end
