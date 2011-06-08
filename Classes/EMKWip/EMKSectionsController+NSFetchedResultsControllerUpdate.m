//
//  EMKSectionsController+NSFetchedResultsControllerUpdate.m
//  EMKPantry
//
//  Created by Benedict Cohen on 06/06/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//
#ifdef NSCoreDataVersionNumber_iPhoneOS_3_0
#import "EMKSectionsController+NSFetchedResultsControllerUpdate.h"
#import <objc/runtime.h>


#pragma mark 
#pragma mark - 
//keys used for associatedObjects
NSString * const EMKSectionsControllerPreUpdateStateKey = @"EMKSectionsControllerPreUpdateStateKey";
NSString * const EMKSectionsControllerIsArchiveKey      = @"EMKSectionsControllerIsArchiveKey";
NSString * const EMKSectionsControllerUpdateContextKey  = @"EMKSectionsControllerUpdateContextKey";



#pragma mark interfaces
//The GenericUpdate category could be made public, but see as the only
//use case is currently NSFetchedResultsController making it public would just add
//confusion to the interface

@interface EMKSectionsController (GenericUpdate)

@property(readonly, nonatomic, retain) EMKSectionsController *sectionsControllerPriorToUpdate;
@property(readonly, nonatomic, assign) BOOL isArchive;
@property(readonly, nonatomic, assign) BOOL isUpdating;
@property(readonly, nonatomic, retain) id updateContext;

-(void)beginUpdate:(id)updateContext;
-(void)endUpdate;

@end


@interface EMKSectionsController (GenericUpdatePrivate)

@property(readwrite, nonatomic, retain) EMKSectionsController *sectionsControllerPriorToUpdate;
@property(readwrite, nonatomic, assign) BOOL isArchive;
@property(readwrite, nonatomic, retain) id updateContext;

@end



#pragma mark -
@implementation EMKSectionsController  (GenericUpdate) 

//Updating
@dynamic isUpdating;
-(BOOL)isUpdating
{
    return !!objc_getAssociatedObject(self, EMKSectionsControllerPreUpdateStateKey);
}



@dynamic isArchive;
-(BOOL)isArchive
{
    return [objc_getAssociatedObject(self, EMKSectionsControllerIsArchiveKey) boolValue];
}

-(void)setIsArchive:(BOOL)isArchive
{
    objc_setAssociatedObject(self, EMKSectionsControllerIsArchiveKey, [NSNumber numberWithBool:isArchive], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@dynamic updateContext;
-(id)updateContext
{
    id result = objc_getAssociatedObject(self, EMKSectionsControllerUpdateContextKey);
    return result;
}

-(void)setUpdateContext:(id)updateContext
{
    objc_setAssociatedObject(self, EMKSectionsControllerUpdateContextKey, updateContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




@dynamic sectionsControllerPriorToUpdate;
-(EMKSectionsController *)sectionsControllerPriorToUpdate
{
    EMKSectionsController *result = objc_getAssociatedObject(self, EMKSectionsControllerPreUpdateStateKey);
    
    if (result == nil)
    {
        NSLog(@"WARNING: Accessed sectionsControllerPriorToUpdate while not updating");
    }
    
    return result;
}


-(void)setSectionsControllerPriorToUpdate:(EMKSectionsController *)sectionsControllerPriorToUpdate
{
    objc_setAssociatedObject(self, EMKSectionsControllerPreUpdateStateKey, sectionsControllerPriorToUpdate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



-(void)beginUpdate:(id)context
{
    if (self.isUpdating)
    {
		NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Attempted to beginUpdate before ending pervious update", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        return;
    }
    
    //update self
    self.updateContext = context;
    
    //create clone
    EMKSectionsController *clone = [[self copy] autorelease];
    clone.isArchive = YES;
    self.sectionsControllerPriorToUpdate = clone;
}



-(void)endUpdate
{
    self.updateContext = nil;    
    self.sectionsControllerPriorToUpdate = nil;
}

@end










#pragma mark -
#pragma mark EMKSectionsController NSFetchedResultsControllerUpdate 
//these are convience methods for accessing the functionality defined in the GenericUpdate category
@implementation EMKSectionsController (NSFetchedResultsControllerUpdate)


-(void)beginUpdateFromFetchedResultsController:(NSFetchedResultsController *)controller
{
    NSDictionary *controllerAndSections = [NSDictionary dictionaryWithObjectsAndKeys:controller, @"controller", 
                                                                                     [[controller.sections copy] autorelease], @"sections", nil];
    
    [self beginUpdate:controllerAndSections];
}



//TODO: This method is technically redundant
//It exists to help express the intended usages pattern
-(void)updateSections:(NSArray *)sections
{
    self.sections = sections;
}


-(NSUInteger)indexForSectionInfo:(id)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type)
    {
        case NSFetchedResultsChangeDelete:
        {
            EMKSectionsController *priorController = [self sectionsControllerPriorToUpdate];
            id arrangedSectionInfo = [[self.updateContext objectForKey:@"sections"] objectAtIndex:sectionIndex];
            return [priorController.arrangedSections indexOfObject:arrangedSectionInfo];
            break; //I know this break is pointless, but my OCD kicks in if it's missing.
        }
            
        case NSFetchedResultsChangeInsert:
        {
            return [self.arrangedSections indexOfObject:sectionInfo];            
            break; //I know this break is pointless, but my OCD kicks in if it's missing.
        }
            
        default:
        {
            NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Unsupported change type. Only NSFetchedResultsChangeDelete and NSFetchedResultsChangeInsert are supported.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
            [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
            break;
        }
    }
    
    return NSNotFound;
}





-(NSIndexPath *)indexPathForObjectAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;
    
    EMKSectionsController *priorState = [self sectionsControllerPriorToUpdate];
    id sectionInfo = [[self.updateContext objectForKey:@"sections"] objectAtIndex:indexPath.section];    
    NSUInteger section = [priorState.arrangedSections indexOfObject:sectionInfo];
    
    return [NSIndexPath indexPathForRow:indexPath.row inSection:section];
}
 

-(NSIndexPath *)indexPathForObjectAtNewIndexPath:(NSIndexPath *)newIndexPath
{
    if (newIndexPath == nil) return nil;
    
    id newSectionInfo = [[[[self updateContext] objectForKey:@"controller"] sections] objectAtIndex:newIndexPath.section];
    NSUInteger newSection = [self.arrangedSections indexOfObject:newSectionInfo];

    return [NSIndexPath indexPathForRow:newIndexPath.row inSection:newSection];    
}

@end
#endif