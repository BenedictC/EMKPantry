//
//  EMKPantryViewController.h
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EMKTestView;



@interface EMKSetControllerViewController : UIViewController <EMKSetControllerDelegate>
{
    EMKTestView *_testView;
    UITableView *_tableView;
    
    EMKSetController *_setController;
    NSArray *_allMusicians;
}

@property (nonatomic, assign) IBOutlet EMKTestView *testView;
@property (nonatomic, assign) IBOutlet UITableView *tableView;

-(IBAction)addBandMember:(id)sender;
-(IBAction)removeBandMember:(id)sender;
-(IBAction)resetBandMember:(id)sender;
@end

