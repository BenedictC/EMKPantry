//
//  EMKAssociateDelegateViewController.m
//  EMKPantry
//
//  Created by Benedict Cohen on 29/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKAssociateDelegateViewController.h"


@implementation EMKAssociateDelegateViewController

@synthesize textField1 = textField1_;
@synthesize textField2 = textField2_;
@synthesize textField3 = textField3_;

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
    textField1_.delegate = nil;
    [textField1_ release];
    textField2_.delegate = nil;    
    [textField2_ release];
    textField3_.delegate = nil;    
    [textField3_ release];    
    
    
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

    SEL selector = @selector(textField:shouldChangeCharactersInRange:replacementString:);        
    const char *types = [NSMethodSignature EMK_typesForMethodWithReturnType:@encode(BOOL) argumentTypes:@encode(UITextField*), @encode(NSRange), @encode(NSString), NULL];
    
    //fetch the associate delegate from the object
    EMKAssociateDelegate *delegate1 = [self.textField1 EMK_associateDelegate];
    [delegate1 respondToSelector:selector typeEncoding:types usingBlock:(id(^)(id, ...))^(id bSelf, UITextField *textField, NSRange range, NSString *replacementString)
     {
         //Numbers only
         return ([replacementString intValue] != 0 || [replacementString isEqualToString:@"0"] || [replacementString length] == 0);
     }];
    self.textField1.delegate = (id<UITextFieldDelegate>)delegate1;
    
    
    EMKAssociateDelegate *delegate2 = [self.textField2 EMK_associateDelegate];
    [delegate2 respondToSelector:selector typeEncoding:types usingBlock:(id(^)(id, ...))^(id bSelf, UITextField *textField, NSRange range, NSString *replacementString)
     {
         //Update title
         self.title = [NSString stringWithFormat:@"TextField 2 Length: %i", [[textField.text stringByReplacingCharactersInRange:range withString:replacementString] length]];
         return YES;
     }];
    self.textField2.delegate = (id<UITextFieldDelegate>)delegate2;
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.textField1.delegate = nil;
    self.textField1 = nil;

    self.textField2.delegate = nil;
    self.textField2 = nil;

    self.textField3.delegate = nil;
    self.textField3 = nil;

}



@end
