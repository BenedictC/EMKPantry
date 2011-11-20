//
//  EMKViewAnimationSequencesViewController.m
//  EMKPantry
//
//  Created by Benedict Cohen on 17/11/2011.
//  Copyright (c) 2011 Benedict Cohen. All rights reserved.
//

#import "EMKViewAnimationSequencesViewController.h"

@implementation EMKViewAnimationSequencesViewController

@synthesize testView = _testView;


#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.testView = nil;
}



-(void)viewDidAppear:(BOOL)animated
{
    UIView *testView = self.testView;
    
    [UIView EMK_animateSequenceWithAnimationDescriptionBlocks:
     EMKAnimationDescriptionBlockCreate(0, 2.0, ^{
        testView.transform = CGAffineTransformMakeScale(2, 2);
    }),
     EMKAnimationDescriptionBlockCreate(0, 1.0, ^{
        //pause
    }),
     EMKAnimationDescriptionBlockCreate(0, 5.0, ^{
        testView.transform = CGAffineTransformRotate(testView.transform, M_PI);
    }),
     EMKAnimationDescriptionBlockCreate(0, 2.0, ^{
        testView.transform = CGAffineTransformScale(testView.transform, 5, 5);
    }),
     EMKAnimationDescriptionBlockCreate(0, 1.0, ^{
        testView.transform = CGAffineTransformIdentity;
    }),
     nil];
}

@end
