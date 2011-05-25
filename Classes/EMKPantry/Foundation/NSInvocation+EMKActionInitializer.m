//
//  NSInvocation+EMKActionInitializer.m
//  EMKPantry
//
//  Created by Benedict Cohen on 25/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "NSInvocation+EMKActionInitializer.h"
#import "NSMethodSignature+EMKMethodTypeEncoding.h"

@implementation NSInvocation (EMKActionInitializer)

+(NSInvocation*)EMK_invocationWithTarget:(id)target action:(SEL)action
{
    NSMethodSignature *sig = [NSMethodSignature EMK_signatureForMethodWithReturnType:@encode(void) argumentTypes:NULL];
    NSInvocation *actionInvocation = [NSInvocation invocationWithMethodSignature:sig];
    
    [actionInvocation setTarget:target];
    [actionInvocation setSelector:action];
    
    return actionInvocation;
}



+(NSInvocation*)EMK_invocationWithTarget:(id)target action:(SEL)action sender:(id)sender
{
    NSMethodSignature *sig = [NSMethodSignature EMK_signatureForMethodWithReturnType:@encode(void) argumentTypes:@encode(id), NULL];
    NSInvocation *actionInvocation = [NSInvocation invocationWithMethodSignature:sig];
    
    [actionInvocation setTarget:target];
    [actionInvocation setSelector:action];
    [actionInvocation setArgument:&sender atIndex:2];
    
    return actionInvocation;
}



+(NSInvocation*)EMK_invocationWithTarget:(id)target action:(SEL)action sender:(id)sender forEvent:(UIEvent *)event
{
    NSMethodSignature *sig = [NSMethodSignature EMK_signatureForMethodWithReturnType:@encode(void) argumentTypes:@encode(id), @encode(UIEvent *), NULL];
    NSInvocation *actionInvocation = [NSInvocation invocationWithMethodSignature:sig];
    
    [actionInvocation setTarget:target];
    [actionInvocation setSelector:action];
    [actionInvocation setArgument:&sender atIndex:2];
    [actionInvocation setArgument:&event  atIndex:3];    
    
    return actionInvocation;
}


@end
