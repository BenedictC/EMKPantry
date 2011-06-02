//
//  NSOperationQueue+EMKDefaultQueueTests.m
//  EMKPantry
//
//  Created by Benedict Cohen on 02/06/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "NSOperationQueue+EMKDefaultQueueTests.h"


@implementation NSOperationQueue_EMKDefaultQueueTests

-(void)testDefaultQueue
{
    NSOperationQueue *defaultQueue1 = [NSOperationQueue EMK_defaultQueue];
    
    STAssertTrue([NSOperationQueue EMK_defaultQueue] == defaultQueue1, @"Default queue is singleton");
}

@end
