//
//  UIView+EMKAnimationSequence.m
//  EMKPantry
//
//  Created by Benedict Cohen on 17/11/2011.
//  Copyright (c) 2011 Benedict Cohen. All rights reserved.
//

#import "UIView+EMKAnimationSequence.h"


#pragma mark block creation
EMKAnimationDescriptionBlock EMKAnimationDescriptionBlockCreate(UIViewAnimationOptions options, NSTimeInterval duration, void (^animations)(void))
{
    return Block_copy(^(UIViewAnimationOptions *optionsOut, NSTimeInterval *durationOut, void (^*animationsOut)(void)){
        *optionsOut = options;
        *durationOut = duration;
        *animationsOut = animations;
    });
}




@implementation UIView (EMKAnimationSequence)

#pragma mark colating methods
+(void)EMK_animateSequenceWithAnimationDescriptionBlocks:(EMKAnimationDescriptionBlock)firstAnimationDescriptionBlock,...
{
    NSMutableArray *animationDescriptionBlocks = [NSMutableArray array];
    
    va_list animationBlocks;
    va_start(animationBlocks, firstAnimationDescriptionBlock);
    EMKAnimationDescriptionBlock animationDescriptionBlock = firstAnimationDescriptionBlock;
    
    while (animationDescriptionBlock != NULL)
    {
        animationDescriptionBlock = Block_copy(animationDescriptionBlock);
        [animationDescriptionBlocks addObject:animationDescriptionBlock];
        Block_release(animationDescriptionBlock);
        
        //fetch next block        
        animationDescriptionBlock = va_arg(animationBlocks, EMKAnimationDescriptionBlock);
    }
    
    
    va_end(animationBlocks);
    
    [self EMK_animateSequence:animationDescriptionBlocks];
}




+(void)EMK_animateSequenceWithDuration:(NSTimeInterval)duration animations:(void(^)(void))firstAnimation, ...
{
    NSMutableArray *animationDescriptions = [NSMutableArray array];
    
    va_list animationBlocks;
    va_start(animationBlocks, firstAnimation);
    
    void *animationBlock = firstAnimation;
//    NSTimeInterval duration = duration;
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone;    
    
    while (animationBlock != NULL)
    {
        id copiedBlock = Block_copy(animationBlock);
        EMKAnimationDescriptionBlock animationDescription = EMKAnimationDescriptionBlockCreate(options, duration, copiedBlock);
        
        [animationDescriptions addObject:animationDescription];
        
        Block_release(animationDescription);
        Block_release(copiedBlock);
        
        //fetch next block        
        animationBlock = va_arg(animationBlocks, void *);
    }
    
    
    va_end(animationBlocks);
    
    [self EMK_animateSequence:animationDescriptions];
}




+(void)EMK_animateSequenceWithAnimationsOfDurations:(void(^)(void))firstAnimation, ...
{
    NSMutableArray *animationDescriptions = [NSMutableArray array];
    
    va_list animationBlocks;
    va_start(animationBlocks, firstAnimation);
    
    void (^animationBlock)(void) = firstAnimation;
    NSTimeInterval duration = 0;    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone;
    
    while (animationBlock != NULL)
    {
        //fetch duration
        duration = va_arg(animationBlocks, NSTimeInterval);            
        //move the animation onto the heap
        id copiedBlock = Block_copy(animationBlock);

        //create and store the animation description
        EMKAnimationDescriptionBlock animationDescription = EMKAnimationDescriptionBlockCreate(options, duration, copiedBlock);
        [animationDescriptions addObject:animationDescription];
        
        //tidy up
        Block_release(copiedBlock);
        Block_release(animationDescription);
        
        //fetch next animation block        
        animationBlock = va_arg(animationBlocks,  void(^)(void));
    }
    
    
    va_end(animationBlocks);
    
    [self EMK_animateSequence:animationDescriptions];
}




+(void)EMK_animateSequenceWithAnimationsOfDurationsWithOptions:(void(^)(void))firstAnimation, ...
{
    NSMutableArray *animationDescriptions = [NSMutableArray array];
    
    va_list animationBlocks;
    va_start(animationBlocks, firstAnimation);
    
    void (^animationBlock)(void) = firstAnimation;
    NSTimeInterval duration = 0;    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone;
    
    while (animationBlock != NULL)
    {
        //fetch duration & options
        duration = va_arg(animationBlocks, NSTimeInterval);            
        options = va_arg(animationBlocks, UIViewAnimationOptions);                    
        //move the animation onto the heap
        id copiedBlock = Block_copy(animationBlock);
        
        //create and store the animation description
        EMKAnimationDescriptionBlock animationDescription = EMKAnimationDescriptionBlockCreate(options, duration, copiedBlock);
        [animationDescriptions addObject:animationDescription];
        
        //tidy up
        Block_release(copiedBlock);
        Block_release(animationDescription);
        
        //fetch next animation block        
        animationBlock = va_arg(animationBlocks,  void(^)(void));
        
    }
    
    
    va_end(animationBlocks);
    
    [self EMK_animateSequence:animationDescriptions];
}






+(void)EMK_animateSequence:(NSArray *)animationDescriptionBlocks
{
    NSInteger count = [animationDescriptionBlocks count];

    //Our work here is done
    if (count < 1) return;
    
    
    //get the animation description block
    EMKAnimationDescriptionBlock animationDescription = [animationDescriptionBlocks objectAtIndex:0];

    //get the animation params from the animation description block
    void (^animations)(void) = NULL;
    NSTimeInterval duration = 0;
    UIViewAnimationOptions options = 0;
    animationDescription(&options, &duration, &animations);
    
    
    
    
    //fire the animaion
    [UIView animateWithDuration:duration delay:0 options:options animations:animations
                     completion:^(BOOL finished) 
     {
         //are there any more animations to fire? If so do, fire them
         if (count > 1)
         {
             [self EMK_animateSequence:[animationDescriptionBlocks subarrayWithRange:NSMakeRange(1, count-1)]];
         }
     }];    
}




@end
