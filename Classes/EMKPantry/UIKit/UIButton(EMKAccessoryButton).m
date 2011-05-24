//
//  UIButton(EMKAccessoryButton).m
//  EMKPantry
//
//  Created by Benedict Cohen on 03/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "UIButton(EMKAccessoryButton).h"
#import "UIView(EMKViewSearching).h"




@implementation UIButton (EMKAccessoryButton)

+(UIButton *)EMK_accessoryButtonWithImage:(UIImage *)defaultImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = (CGRect){.size = defaultImage.size, .origin = button.frame.origin};
    [button setBackgroundImage:defaultImage forState:UIControlStateNormal];
    
    [button addTarget:button action:@selector(EMK_invokeTableViewAccessoryButtonTappedForRowWithIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}



-(IBAction)EMK_invokeTableViewAccessoryButtonTappedForRowWithIndexPath:(id)sender
{
    UITableViewCell *cell = (id)[self EMK_superViewOfClass:[UITableViewCell class]];
    if (!cell) return;
    
    UITableView *tableView = (id)[cell EMK_superViewOfClass:[UITableView class]];
    if (!tableView) return;

    
    //- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath        
    if (![tableView.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) return;
    
    [tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:[tableView indexPathForCell:cell]];
}


@end
