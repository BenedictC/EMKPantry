//
//  NSInvocation(EMKActionInitializer).m
//  EMKPantry
//
//  Created by Benedict Cohen on 25/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "NSInvocation(EMKActionInitializer).h"


@implementation NSInvocation (EMKActionInitializer)


+(NSInvocation*)EMK_invocationWithTarget:(id)target action:(SEL)action sender:(id)sender
{
    NSInvocation *actionInvocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v:@@"]];
    
    [actionInvocation setTarget:target];
    [actionInvocation setSelector:action];
    [actionInvocation setArgument:&sender atIndex:2];
    
    return actionInvocation;
}

@end
