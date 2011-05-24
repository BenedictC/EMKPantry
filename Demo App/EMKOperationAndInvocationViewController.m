//
//  EMKOperationAndInvocationViewController.m
//  EMKPantry
//
//  Created by Benedict Cohen on 29/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKOperationAndInvocationViewController.h"


@implementation EMKOperationAndInvocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self testOperations];
}



-(void)testOperations
{
    NSOperation *op1 = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sayHello:) object:[NSNumber numberWithInt:6]] autorelease];
    NSOperation *op2 = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sayHello:) object:[NSNumber numberWithInt:1]] autorelease];
    NSOperation *op3 = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sayHello:) object:[NSNumber numberWithInt:3]] autorelease];    
    [op2 addDependency:op1];
    [op3 addDependency:op2];
    [[NSOperationQueue EMK_defaultQueue] addOperation:op1];
    [[NSOperationQueue EMK_defaultQueue] addOperation:op2];
    [[NSOperationQueue EMK_defaultQueue] addOperation:op3];    
    
    
    NSOperation *op4 = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sayHello:) object:[NSNumber numberWithInt:6]] autorelease];
    NSOperation *op5 = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sayHello:) object:[NSNumber numberWithInt:1]] autorelease];
    NSOperation *op6 = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(sayHello:) object:[NSNumber numberWithInt:3]] autorelease];    
    [op5 addDependency:op4];
    [op6 addDependency:op5];
    [[NSOperationQueue mainQueue] addOperation:op4];
    [[NSOperationQueue mainQueue] addOperation:op5];
    [[NSOperationQueue mainQueue] addOperation:op6];        
}





-(void)sayHello:(NSNumber *)snoozeSeconds
{
    [[UIApplication sharedApplication] performSelectorOnMainThread:@selector(EMK_addNetworkActivityParticipant) withObject:nil waitUntilDone:NO];    
    sleep([snoozeSeconds intValue]);
    
    NSLog(@"Hello from mainThread?: %i", [NSThread isMainThread]);
    [[UIApplication sharedApplication] performSelectorOnMainThread:@selector(EMK_removeNetworkActivityParticipant) withObject:nil waitUntilDone:NO];
}




-(void)logSender:(id)sender
{
    NSLog(@"%@", sender);
}



@end
