//
//  EMKTestView.h
//  EMKPantry
//
//  Created by Benedict Cohen on 17/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EMKTestView : EMKView
@end
@interface EMKTestView (subviews)
@property(readwrite, retain) IBOutlet UISlider *slider;
@property(readwrite, retain) IBOutlet UISwitch *switchView;
@property(readwrite, retain) IBOutlet UIProgressView *progress;
@end

