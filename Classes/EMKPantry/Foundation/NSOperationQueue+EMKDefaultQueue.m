//
//  NSOperationQueue+EMKDefaultQueue.m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "NSOperationQueue+EMKDefaultQueue.h"



@implementation NSOperationQueue (EMKDefaultQueue)


+(NSOperationQueue*)EMK_defaultQueue
{
    static NSOperationQueue *defaultOperationQueue = nil;
    
    @synchronized (self)
    {
        if (defaultOperationQueue == nil)
        {
            defaultOperationQueue = [NSOperationQueue new];   
        }
    }

    
    return defaultOperationQueue;
}


@end
