//
//  EMKPantryViewController.m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "EMKSetControllerViewController.h"
#import "EMKTestView.h"
#import <objc/runtime.h>


@interface EMKSetControllerViewController  ()


@property(readonly, nonatomic) EMKSetController *setController;
@property(readonly, nonatomic) NSArray *allMusicians;
@property(readonly, nonatomic) id anyMusician;

@end


@implementation EMKSetControllerViewController

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
