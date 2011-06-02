//
//  NSInvocation+EMKActionInitializerTests.m
//  EMKPantry
//
//  Created by Benedict Cohen on 02/06/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "NSInvocation+EMKActionInitializerTests.h"
#import "NSInvocation+EMKActionInitializer.h"

@interface DummyClass : NSObject
{
}

-(void)testMethod;
-(void)testMethodWithSender:(id)sender;
-(void)testMethodWithSender:(id)sender event:(UIEvent *)event;
@property(readwrite, assign, nonatomic) SEL lastInvokedMethod;
@end



@implementation DummyClass

@synthesize lastInvokedMethod;

-(void)testMethod
{
    self.lastInvokedMethod = _cmd;
}

-(void)testMethodWithSender:(id)sender
{
    self.lastInvokedMethod = _cmd;
}

-(void)testMethodWithSender:(id)sender event:(UIEvent *)event
{
    self.lastInvokedMethod = _cmd;
}

@end






@implementation NSInvocation_EMKActionInitializerTests

@synthesize dummy;

-(void)setUp
{
    self.dummy = [[DummyClass new] autorelease];
}


-(void)tearDown
{
    self.dummy = nil;
}



-(void)testEMK_invocationWithTargetAction
{
    SEL sel = @selector(testMethod);
    [[NSInvocation EMK_invocationWithTarget:self.dummy action:sel] invoke];
    
    STAssertTrue(sel == self.dummy.lastInvokedMethod, @"Last invoked method incorrect");
    
    //TODO: negative tests
}


-(void)testEMK_invocationWithTargetActionSender
{
    SEL sel = @selector(testMethodWithSender:);
    [[NSInvocation EMK_invocationWithTarget:self.dummy action:sel sender:self] invoke];
    STAssertTrue(sel == self.dummy.lastInvokedMethod, @"Last invoked method incorrect");    
    
    //TODO: negative tests    
}


-(void)testEMK_invocationWithTargetActionSenderForEvent
{
    SEL sel = @selector(testMethodWithSender:event:);
    [[NSInvocation EMK_invocationWithTarget:self.dummy action:sel sender:self forEvent:nil] invoke];
    STAssertTrue(sel == self.dummy.lastInvokedMethod, @"Last invoked method incorrect");    
    
    //TODO: negative tests    
}


@end
