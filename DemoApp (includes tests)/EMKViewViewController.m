//
//  EMKViewViewController.m
//  EMKPantry
//
//  Created by Benedict Cohen on 29/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKViewViewController.h"
#import "EMKTestView.h"



@implementation EMKViewViewController

@synthesize testView = testView_;

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
    self.testView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self testAccessors];
    [self testViewLoading];
}



-(void)testViewLoading
{
    self.testView = [EMKTestView EMK_viewWithDefaultNib];
    CGRect frame = self.testView.frame;
    frame.origin = CGPointZero;
    self.testView.frame = frame;
    [self.view addSubview:self.testView];
    
    [self performSelector:@selector(setSliderValue:) withObject:[NSNumber numberWithFloat:0.0] afterDelay:0];
    [self performSelector:@selector(setSliderValue:) withObject:[NSNumber numberWithFloat:0.25] afterDelay:1];
    [self performSelector:@selector(setSliderValue:) withObject:[NSNumber numberWithFloat:0.5] afterDelay:2];
    [self performSelector:@selector(setSliderValue:) withObject:[NSNumber numberWithFloat:0.75] afterDelay:3];    
    [self performSelector:@selector(setSliderValue:) withObject:[NSNumber numberWithFloat:1.0] afterDelay:4];        
    
    NSLog(@"%@, %@, %@", self.testView.slider, self.testView.switchView, self.testView.progress);

}


-(void)setSliderValue:(NSNumber *)number
{
    NSLog(@"slider: %@", self.testView.slider);
    self.testView.slider.value = [number floatValue];
}






-(void)testAccessors
{
    NSString *className =  NSStringFromClass([self class]);
    NSLog(@"%@ has get view: %i", className, [self EMK_hasGetterForProperty:@"view"]);
    NSLog(@"%@ has set view: %i", className, [self EMK_hasSetterForProperty:@"view"]);
    
    NSLog(@"%@ has get aetjd: %i", className, [self EMK_hasGetterForProperty:@"aetjd"]);
    NSLog(@"%@ has set aetjd: %i", className, [self EMK_hasSetterForProperty:@"aetjd"]);    
}



@end
