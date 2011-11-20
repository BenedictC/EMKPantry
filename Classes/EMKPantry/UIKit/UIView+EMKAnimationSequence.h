//
//  UIView+UIView_EMKAnimationSequence.h
//  EMKPantry
//
//  Created by Benedict Cohen on 17/11/2011.
//  Copyright (c) 2011 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EMKAnimationDescriptionBlock)(UIViewAnimationOptions */*optionsOut*/, NSTimeInterval */*durationOut*/, void (^*/*animationOut*/)(void));

EMKAnimationDescriptionBlock EMKAnimationDescriptionBlockCreate(UIViewAnimationOptions options, NSTimeInterval duration, void (^animations)(void));


@interface UIView (EMKAnimationSequence)

//A delay can be achived by adding an empty animation with the desired delay as the duration

//Show time! These are the methods to use. EMK_animateSequence: is the method which all these methods ultimately call.
+(void)EMK_animateSequenceWithAnimationDescriptionBlocks:(EMKAnimationDescriptionBlock)firstAnimationDescription, ...;
+(void)EMK_animateSequence:(NSArray *)animationDescriptionBlocks;


//These methods were fun to write, but you shouldn't use them.
//They let you write slightly less verbose code, but it is more error prone too. You will get bitten by type 
//conversion of the duration. Vaargs promote floats to doubles but ints stay ints - they can't be converted to doubles.
//When you forget to specify the duration as 0 instead 0.0 (which you will do) things will not go as expected.
+(void)EMK_animateSequenceWithDuration:(NSTimeInterval)duration animations:(void(^)(void))firstAnimation, ...;
+(void)EMK_animateSequenceWithAnimationsOfDurations:(void(^)(void))firstAnimation, ...;
+(void)EMK_animateSequenceWithAnimationsOfDurationsWithOptions:(void(^)(void))firstAnimation, ...;

@end
