//
//  EMKRootViewController.m
//  EMKPantry
//
//  Created by Benedict Cohen on 29/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKRootViewController.h"

#import "EMKSetControllerViewController.h"
#import "EMKTypedArrayViewController.h"
#import "EMKAssociateDelegateViewController.h"
#import "EMKViewViewController.h"
#import "EMKOperationAndInvocationViewController.h"


@interface EMKRootViewController ()
@property(readwrite, retain, nonatomic) NSDictionary *subVCs;
-(NSArray *)orderedSubVCTitles;
@end


@implementation EMKRootViewController
@synthesize tableView = tableView_;
@synthesize subVCs = subVCs_;


-(NSArray *)orderedSubVCTitles
{
    return [[self.subVCs allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}


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
    [subVCs_ release];
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

    //set up subvcs
    NSMutableDictionary *subVCs = [NSMutableDictionary dictionaryWithCapacity:10];
    [subVCs setObject:[EMKSetControllerViewController class] forKey:@"EMKSetController"];
    [subVCs setObject:[EMKTypedArrayViewController class] forKey:@"EMKTypedArray"];
    [subVCs setObject:[EMKAssociateDelegateViewController class] forKey:@"EMKAssociateDelegate"];
    [subVCs setObject:[EMKViewViewController class] forKey:@"EMKView"];    
    [subVCs setObject:[EMKOperationAndInvocationViewController class] forKey:@"EMKOperationAndInvocation"];    
    
    self.subVCs = subVCs;
    
    self.title = NSLocalizedString(@"EMKPantry", nil);
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.subVCs count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"vcCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[self orderedSubVCTitles] objectAtIndex:indexPath.row];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [[self orderedSubVCTitles] objectAtIndex:indexPath.row];
    
    Class vcClass = [self.subVCs objectForKey:key];
    
    UIViewController *vc = [vcClass EMK_viewControllerWithDefaultNib];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
