//
//  NSOperationQueue(EMKDefaultQueue).m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "NSOperationQueue(EMKDefaultQueue).h"

    NSOperationQueue *EMK_defaultOperationQueue;


@implementation NSOperationQueue (EMKDefaultQueue)


+(NSOperationQueue*)EMK_defaultQueue
{
    @synchronized (self)
    {
        if (!EMK_defaultOperationQueue) EMK_defaultOperationQueue = [NSOperationQueue new];
    }

    
    return EMK_defaultOperationQueue;
}


//EMK_defaultOperationQueue could observe itself and release its self when the queue is empty but that seems unnecassery.

@end
