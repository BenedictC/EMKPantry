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
    //TODO: is the memory management for this correct?    
    void *heapBlock = Block_copy(animations);
    return Block_copy(^(UIViewAnimationOptions *optionsOut, NSTimeInterval *durationOut, void (^*animationsOut)(void)){
        *optionsOut = options;
        *durationOut = duration;
        *animationsOut = heapBlock;
    });
    
    Block_release(heapBlock);
}

`


@implementation UIView (EMKAnimationSequence)

#pragma mark colating methods
+(void)EMK_animateSequenceWithDuration:(NSTimeInterval)duration animations:(void(^)(void))firstAnimation, ...
{
    NSMutableArray *animationDescriptions = [NSMutableArray array];
    
    //the varag list will only contain animation blocks and a nil sentinal
    va_list animationBlocks;
    va_start(animationBlocks, firstAnimation);

    //default/first animation description block settings    
    void *animationBlock = firstAnimation;
    //NSTimeInterval duration = duration;
    const UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone;    
    
    while (animationBlock != NULL)
    {
        //create animation description and add it to array
        EMKAnimationDescriptionBlock animationDescription = EMKAnimationDescriptionBlockCreate(options, duration, animationBlock);
        [animationDescriptions addObject:animationDescription];
        Block_release(animationDescription);
        
        //fetch next block        
        animationBlock = va_arg(animationBlocks, void *);
    }

    //tidy up
    va_end(animationBlocks);
    
    [self EMK_animateSequence:animationDescriptions];
}




+(void)EMK_animateSequenceWithAnimationsOfDurations:(void(^)(void))firstAnimation, ...
{
    NSMutableArray *animationDescriptions = [NSMutableArray array];
    
    //the varag list will be animationBlocks1, duration1, animationBlock2, duration2, ... and a nil sentinal    
    //the block must be first as duration can legitmatley by 0.0 which == nil
    va_list animationBlocks;
    va_start(animationBlocks, firstAnimation);
    
    //default/first animation description block settings    
    void (^animationBlock)(void) = firstAnimation;        
    NSTimeInterval duration = 0;    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone;

    
    while (animationBlock != NULL)
    {
        //fetch duration
        duration = va_arg(animationBlocks, NSTimeInterval);            

        //create and store the animation description
        EMKAnimationDescriptionBlock animationDescription = EMKAnimationDescriptionBlockCreate(options, duration, animationBlock);
        [animationDescriptions addObject:animationDescription];
        Block_release(animationDescription);
        
        //fetch next animation block        
        animationBlock = va_arg(animationBlocks, void(^)(void));
    }
    
    //tidy up    
    va_end(animationBlocks);
    
    [self EMK_animateSequence:animationDescriptions];
}




+(void)EMK_animateSequenceWithAnimationsOfDurationsWithOptions:(void(^)(void))firstAnimation, ...
{
    NSMutableArray *animationDescriptions = [NSMutableArray array];
    
    //the varag list will be animationBlocks1, duration1, animationBlock2, duration2, ... and a nil sentinal    
    //the block must be first as duration can legitmatley by 0.0 which == nil    
    va_list animationBlocks;
    va_start(animationBlocks, firstAnimation);
    
    //default/first animation description block settings        
    void (^animationBlock)(void) = firstAnimation;
    NSTimeInterval duration = 0;    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone;
    
    while (animationBlock != NULL)
    {
        //fetch duration & options
        duration = va_arg(animationBlocks, NSTimeInterval);            
        options = va_arg(animationBlocks, UIViewAnimationOptions);                    

        //create and store the animation description
        EMKAnimationDescriptionBlock animationDescription = EMKAnimationDescriptionBlockCreate(options, duration, animationBlock);
        [animationDescriptions addObject:animationDescription];
        Block_release(animationDescription);        
        
        //fetch next animation block        
        animationBlock = va_arg(animationBlocks,  void(^)(void));
        
    }
    
    //tidy up    
    va_end(animationBlocks);
    
    [self EMK_animateSequence:animationDescriptions];
}




+(void)EMK_animateSequenceWithAnimationDescriptionBlocks:(EMKAnimationDescriptionBlock)firstAnimationDescriptionBlock,...
{
    NSMutableArray *animationDescriptionBlocks = [NSMutableArray array];
    
    //the varag list will only contain animationDescriptionBlocks and a nil sentinal    
    va_list animationBlocks;
    va_start(animationBlocks, firstAnimationDescriptionBlock);
    EMKAnimationDescriptionBlock animationDescriptionBlock = firstAnimationDescriptionBlock;
    
    while (animationDescriptionBlock != NULL)
    {
        //ensure the block is on the heap and store it
        animationDescriptionBlock = Block_copy(animationDescriptionBlock);
        [animationDescriptionBlocks addObject:animationDescriptionBlock];
        Block_release(animationDescriptionBlock);
        
        //fetch next block        
        animationDescriptionBlock = va_arg(animationBlocks, EMKAnimationDescriptionBlock);
    }
    
    //tidy up
    va_end(animationBlocks);
    
    [self EMK_animateSequence:animationDescriptionBlocks];
}




#pragma mark animation method
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
