//
//  EMKPantryViewController.m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "EMKPantryViewController.h"
#import "EMKTestView.h"
#import <objc/runtime.h>


@interface EMKPantryViewController  ()

-(void)testViewControllerLoading;
-(void)testViewLoading;
-(void)setSliderValue:(NSNumber *)number;
-(void)testAccessors;
-(void)testOperations;
-(void)sayHello:(NSNumber *)snoozeSeconds;
-(void)logSender:(id)sender;

@property(readonly, nonatomic) EMKSetController *setController;
@property(readonly, nonatomic) NSArray *allMusicians;
@property(readonly, nonatomic) id anyMusician;

@end


@implementation EMKPantryViewController

#pragma mark memory management
- (void)dealloc 
{
    _setController.delegate = nil;
    [_setController release];
    
    [super dealloc];
}



#pragma mark properties
@synthesize testView = _testView;
@synthesize tableView = _tableView;


-(NSString *)title
{
    return [[NSDate date] description];
}


@synthesize setController = _setController;
-(EMKSetController *)setController
{
    if (_setController) return _setController;

    NSArray *sortKeys = [NSArray arrayWithObjects:@"surname", @"firstname", nil];
    _setController =  [[EMKSetController alloc] initWithSet:nil sortKeyPaths:sortKeys secondaryKeyPaths:[NSArray arrayWithObject:@"firstname"] sectionNameKeyPath:nil];
    _setController.delegate = self;

    return _setController;
}



-(NSArray *)allMusicians
{
    if (_allMusicians) return _allMusicians;
    //0
    NSMutableDictionary *jimmy = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Jimmy", @"firstname", @"Page", @"surname", @"Led Zeppelin", @"group", nil];
    NSMutableDictionary *percy = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Robert", @"firstname", @"Plant", @"surname", @"Led Zeppelin", @"group", nil];
    NSMutableDictionary *jpj   = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"John Paul", @"firstname", @"Jones", @"surname", @"Led Zeppelin", @"group", nil];
    NSMutableDictionary *bonzo = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"John", @"firstname", @"Bonham", @"surname", @"Led Zeppelin", @"group", nil];
    NSMutableDictionary *jason = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Jason", @"firstname", @"Bonham", @"surname", @"Led Zeppelin", @"group", nil];
    //5
    NSMutableDictionary *john   = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"John", @"firstname", @"Lennon", @"surname", @"The Beatles", @"group", nil];
    NSMutableDictionary *paul   = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Paul", @"firstname", @"McCartney", @"surname", @"The Beatles", @"group", nil];    
    NSMutableDictionary *george = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"George", @"firstname", @"Harrison", @"surname", @"The Beatles", @"group", nil];
    NSMutableDictionary *ringo  = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Ringo", @"firstname", @"Starr", @"surname", @"The Beatles", @"group", nil];    
    //9
    NSMutableDictionary *frank    = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Frank", @"firstname", @"Zappa", @"surname", @"The Mothers of Invention", @"group", nil];        
    NSMutableDictionary *napoleon = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Napoleon Murphy", @"firstname", @"Brock", @"surname", @"The Mothers of Invention", @"group", nil];                
    NSMutableDictionary *georgeD  = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"George", @"firstname", @"Duke", @"surname", @"The Mothers of Invention", @"group", nil];            
    NSMutableDictionary *bruce    = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Bruce", @"firstname", @"Fowler", @"surname", @"The Mothers of Invention", @"group", nil];            
    NSMutableDictionary *tom      = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Tom", @"firstname", @"Fowler", @"surname", @"The Mothers of Invention", @"group", nil];            
    NSMutableDictionary *ralph    = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Ralph", @"firstname", @"Humphrey", @"surname", @"The Mothers of Invention", @"group", nil];                
    NSMutableDictionary *ruth     = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Ruth", @"firstname", @"Underwood", @"surname", @"The Mothers of Invention", @"group", nil];                    
    NSMutableDictionary *chester  = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Chester", @"firstname", @"Thompson", @"surname", @"The Mothers of Invention", @"group", nil];                        
    //17    
    NSMutableDictionary *mick    = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Mick", @"firstname", @"Jagger", @"surname", @"The Rolling Stones", @"group", nil];
    NSMutableDictionary *keith   = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Keith", @"firstname", @"Richards", @"surname", @"The Rolling Stones", @"group", nil];
    NSMutableDictionary *brian   = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Brian", @"firstname", @"Jones", @"surname", @"The Rolling Stones", @"group", nil];
    NSMutableDictionary *charlie = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Charlie", @"firstname", @"Watts", @"surname", @"The Rolling Stones", @"group", nil];
    NSMutableDictionary *bill    = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Bill", @"firstname", @"Wyman", @"surname", @"The Rolling Stones", @"group", nil];
    NSMutableDictionary *mickT   = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Mick", @"firstname", @"Taylor", @"surname", @"The Rolling Stones", @"group", nil];    
    NSMutableDictionary *ronnie  = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Ronnie", @"firstname", @"Wood", @"surname", @"The Rolling Stones", @"group", nil];        
    
    
    _allMusicians = [[NSArray alloc] initWithObjects:
            jimmy, percy, jpj, bonzo, jason,
            john, paul, george, ringo,
            frank, napoleon, georgeD, bruce, tom, ralph, ruth, chester,
            mick, keith, brian, charlie, bill, mickT, ronnie,
            nil];
    
    
    return _allMusicians;
}


-(id)anyMusician
{
    srandom(time(NULL));
    
    NSArray *musicians = [self.allMusicians sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES]]];    
 
//    return [musicians objectAtIndex:3];
    
    float rand = (int)random() % [musicians count];
    
    return [musicians objectAtIndex:rand];
}



#pragma mark view life cycle
-(void)viewDidUnload
{
    self.testView = nil;
    self.tableView = nil;
    
    [super viewDidUnload];
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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
    
    
    
    //create the object that requires a delegate - don't set the delegate yet!
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Hello" message:nil delegate:nil cancelButtonTitle:@"Bye!" otherButtonTitles:nil] autorelease];
    
    //fetch the associate delegate from the object
    EMKAssociateDelegate *delegate = [alert EMK_associateDelegate];

    
    //add a delegate method to the delegate
    SEL selector = @selector(alertView:clickedButtonAtIndex:);    
    const char *types = [NSMethodSignature EMK_typesForMethodWithReturnType:@encode(void) argumentTypes:@encode(UIAlertView), @encode(NSInteger), NULL];
    //note the type signature for the block. Its the delegate method but with 'id bSelf' prefixed.
    [delegate respondToSelector:selector typeEncoding:types usingBlock:^(id bSelf, UIAlertView *alertView, NSInteger clickedButtonAtIndex)
     {
         NSLog(@"self: %@", self); //this will be a reference to self in the current scope (in this case it's a UIViewController)
         NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));  //this will be a _cmd in the current scope (in this case it's viewDidAppear:)
         
         NSLog(@"bSelf: %@", bSelf); //this will be the associated delegate
         NSLog(@"alertView: %@", alertView); //this is the first 'normal' delegate method arguments
         NSLog(@"clickedButtonAtIndex: %i", clickedButtonAtIndex);  //this is the second 'normal' delegate method arguments
         
         UIAlertView *anotherAlert = [[[UIAlertView alloc] initWithTitle:@"Hiya" message:nil delegate:nil cancelButtonTitle:@"I'm off" otherButtonTitles:nil] autorelease];
         EMKAssociateDelegate *anotherDelegate = [anotherAlert EMK_associateDelegate];
         
         [anotherDelegate respondToSelector:selector typeEncoding:types usingBlock:^(id bSelf2, UIAlertView *alertView2, NSInteger clickedButtonAtIndex2)
          {
              NSLog(@"bSelf2: %@", bSelf2); //this will be the associated delegate
              NSLog(@"alertView2: %@", alertView2); //this is the first 'normal' delegate method arguments
              NSLog(@"clickedButtonAtIndex2: %i", clickedButtonAtIndex2);  //this is the second 'normal' delegate method arguments
          }];

         anotherAlert.delegate = anotherDelegate;
         [anotherAlert show];
         
     }];
    

    //assign the object its delegate
    alert.delegate = delegate; 
    
    [alert show];
}





-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"self: %@", self); 
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));          
    
//    NSLog(@"bSelf: %@", bSelf); 
//    NSLog(@"bCmd: %@", NSStringFromSelector(bCmd));          
    NSLog(@"alertView: %@", alertView);                   
    NSLog(@"clickedButtonAtIndex: %i", buttonIndex);                   
}



#pragma mark table view setController delegate
- (void)setControllerWillChangeContent:(EMKSetController *)controller;
{
    [self.tableView beginUpdates];    
}






- (void)setController:(EMKSetController *)controller didChangeSection:(id <EMKSetControllerSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(EMKSetControllerChangeType)type;
{
    switch (type)
    {
        case EMKSetControllerChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case EMKSetControllerChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        default:
            break;
    }

}




- (void)setController:(EMKSetController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(EMKSetControllerChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
{
    switch (type)
    {
        case EMKSetControllerChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case EMKSetControllerChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case EMKSetControllerChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case EMKSetControllerChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            

            
        default:
            break;
    }
    

}





- (void)setControllerDidChangeContent:(EMKSetController *)controller;
{
    [self.tableView endUpdates];    
    [self.tableView flashScrollIndicators];
    self.title = @"WRGETRF";
}





//- (NSString *)setController:(EMKSetController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName;
//{
//    return nil;
//}








#pragma mark table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.setController.sections count];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
{
    return [[[self.setController sections] objectAtIndex:sectionIndex] name];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [[self.setController.sections objectAtIndex:sectionIndex] numberOfObjects];
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"plainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier] autorelease];
    }
    
    id object = [self.setController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [object valueForKey:@"firstname"], [object valueForKey:@"surname"]];
    
                           
   return cell;
}




#pragma mark table view delegate



#pragma mark test methods

-(void)testViewControllerLoading
{
//    self.viewController = [EMKPantryViewController EMK_viewControllerWithDefaultNib];
}





-(void)testViewLoading
{
    self.testView = [EMKTestView EMK_viewWithDefaultNib];
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
    NSLog(@"has get window: %i", [self EMK_hasGetterForProperty:@"window"]);
    NSLog(@"has set window: %i", [self EMK_hasSetterForProperty:@"window"]);
    
    NSLog(@"has get aetjd: %i", [self EMK_hasGetterForProperty:@"aetjd"]);
    NSLog(@"has set aetjd: %i", [self EMK_hasSetterForProperty:@"aetjd"]);    
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
    NSLog(@"NSObject class conforms to NSObject: %i", [[NSObject class] conformsToProtocol:@protocol(NSObject)]);
    [[NSObject class] release];
    NSLog(@"%i %i", [NSObject class] == [[NSObject class] class], [[[NSObject class] class] retainCount]);
    
    
    
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
    [[UIApplication sharedApplication] EMK_addNetworkActivityParticipant];
    sleep([snoozeSeconds intValue]);
    
    NSLog(@"Hello from mainThread?: %i", [NSThread isMainThread]);
    [[UIApplication sharedApplication] EMK_removeNetworkActivityParticipant];
}







-(void)logSender:(id)sender
{
    NSLog(@"%@", sender);
}




#pragma mark IBActions
-(IBAction)resetBandMember:(id)sender
{
    srandom(time(NULL));
    NSMutableArray *allMusicians = [[self allMusicians] mutableCopy];    
    
    //Random musicians
    int musicianCount = 1 + ((int)random() % ([allMusicians count]-1));
    NSMutableSet *musicians = [NSMutableSet setWithCapacity:musicianCount];
    for (int i = 0; i < musicianCount; i++) 
    {
        int randomIndex = (int)random() % (musicianCount - i);
        
        [musicians addObject: [allMusicians objectAtIndex:randomIndex]];
        [allMusicians removeObjectAtIndex:randomIndex];
    }
    

    //fixed musicians
//    NSSet *musicians;
//    static int musicianSetId = 0;
//    switch (musicianSetId++ % 6)
//    {
//        case 0:
//            musicians = [NSSet setWithObjects: [allMusicians objectAtIndex:0], nil];
//            break;
//        case 1:
//            musicians = [NSSet setWithObjects: [allMusicians objectAtIndex:5], nil];
//            break;
//        case 2:
//            musicians = [NSSet setWithObjects: [allMusicians objectAtIndex:9], nil];
//            break;
//        case 3:
//            musicians = [NSSet setWithObjects: [allMusicians objectAtIndex:17], nil];
//            break;
//        case 4:
//            musicians = [NSSet setWithObjects: [allMusicians objectAtIndex:9], nil];
//            break;
//        case 5:
//            musicians = [NSSet setWithObjects: [allMusicians objectAtIndex:10], nil];
//            break;
//            
//    }
    
    
    [self.setController setObjects:musicians];
}




-(IBAction)addBandMember:(id)sender
{
    srandom(time(NULL));
    NSMutableDictionary *anyMusician = [self.setController.objects objectAtIndex:((int)random() % [self.setController.objects count])];
//    [anyMusician setObject:@"The Other People" forKey:@"group"];
    [anyMusician setObject:@"ARF ARF ARF" forKey:@"surname"];    
    
    //[self.setController addObjects:[NSSet setWithObject:[self anyMusician]] removeObjects:nil];
}





-(IBAction)removeBandMember:(id)sender
{
    id musician = [self.setController.objects lastObject];
    if (musician == nil) return;
    
    [self.setController addObjects:nil removeObjects:[NSSet setWithObject:musician]];
}





@end
