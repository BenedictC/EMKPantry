//
//  EMKTypedArrayViewController.m
//  EMKPantry
//
//  Created by Benedict Cohen on 29/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKTypedArrayViewController.h"


@implementation EMKTypedArrayViewController

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
    
    
    
    
    
    //Create an array
    CGPoint points[2] = {CGPointMake(10,10), CGPointMake(20, 20)};
    EMKMutableTypedArray *pointArray = [EMKMutableTypedArray typedArrayWithTypeSizeof:sizeof(CGPoint) bytes:points count:2 defaultValue:&CGPointZero];
    
    CGPoint value;
    uint i, pointCount;
    for (i = 0, pointCount = [pointArray count]; i < pointCount; i++)
    {
        [pointArray getValue:&value atIndex:i];
        NSLog(@"%i: %f, %f", i, value.x, value.y);
    }
    //0: 10, 10
    //1: 20, 20
    
    
    //add a value
    CGPoint point = (CGPoint){.x = 40, .y = 40};
    [pointArray setValue:&point atIndex:3];
    
    for (i = 0, pointCount = [pointArray count]; i < pointCount; i++)
    {
        [pointArray getValue:&value atIndex:i];
        NSLog(@"%i: %f, %f", i, value.x, value.y);
    }
    //0: 10, 10
    //1: 20, 20
    //2: 0, 0
    //3: 40, 40
    
    
    //shrink the array
    [pointArray trimToLength:2];
    
    for (i = 0, pointCount = [pointArray count]; i < pointCount; i++)
    {
        [pointArray getValue:&value atIndex:i];
        NSLog(@"%i: %f, %f", i, value.x, value.y);
    }
    //0: 10, 10
    //1: 20, 20
    
    
    //    @try {
    //            [stack removeObjectAtIndex:3];
    //    }
    //    @catch (NSException *exception) 
    //    {
    //        NSLog(@"%@", [exception name]);
    //        NSLog(@"%@", [exception reason]);                
    //        NSLog(@"%@", [exception userInfo]);        
    //        @throw exception;
    //    }
    //
    
    
    //    EMKTypedArray *floatArray = [EMKTypedArray typedArrayWithTypeSizeof:sizeof(float)];
    //    const int count = 20;
    //    
    //    for (int i = 0; i < count; i++)
    //    {
    //        float value = i;
    //        uint index = rand() % 1200;
    //        [floatArray setValue:&value atIndex:index];
    //        NSLog(@"set %i: %f", index, value);
    //    }
    //
    //    NSUInteger i = [floatArray firstIndex];
    //    while (i != NSNotFound)
    //    {
    //        uint oldI = i;
    //        float value = 0;
    //        [floatArray getValue:&value atIndex:i nextIndex:&i];
    //        NSLog(@"get %i: %f", oldI, value);
    //    }
    
    return;
    
    
    //    [self testViewLoading];
    //    float defaultValue = 12345;
    //    EMKScalarArray *floatArray = [EMKScalarArray scalarArrayWithScalarSizeof:sizeof(float) capacity:5 defaultValue:&defaultValue];
    //    
    //    float a = 235;
    //    [floatArray setValue:&a atIndex:5];
    //    
    //    float b = 765;
    //    [floatArray getValue:&b atIndex:5];
    //    
    //    float c = 765;
    //    [floatArray getValue:&c atIndex:3];
    //    
    //    
    //    for(int i = 0; i < 20; i++)
    //    {
    //        [floatArray getValue:&a atIndex:i];
    //        NSLog(@"%i: %f", i, a);
    //    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
