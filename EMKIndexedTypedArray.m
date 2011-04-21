//
//  EMKIndexedTypedArray.m
//  EMKPantry
//
//  Created by Benedict Cohen on 18/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKIndexedTypedArray.h"
#import "redblack.h"

/*
TODO:
 If the indexes stored are sparse then a lot of memory will be wasted.
 To recifiy this we could store the indexes as a red-black tree.
 The nodes store:
 - index (obviously!)
 - the index in the super class (eg index 400 could map to index 0 in super)

 we would also need to store the unset indexes so they can be reused
 
 Problems:
 How would we know when the underlying array has become sparse?
    ratio between indexes.Count and upperIndex
 
 */

@interface EMKIndexedTypedArray ()

@property(readwrite, retain, nonatomic) NSMutableIndexSet *indexSet;

@end;


@implementation EMKIndexedTypedArray

#pragma mark state mutators and accessors
@synthesize indexSet = indexSet_;



-(NSUInteger)firstIndex
{
    return [self.indexSet firstIndex];
}



-(NSUInteger)lastIndex
{
    return [self.indexSet lastIndex];    
}



-(NSIndexSet *)indexes
{
    return [[self.indexSet copy] autorelease];
}



-(void)setValue:(const void *)buffer atIndex:(NSUInteger)index
{
    [super setValue:buffer atIndex:index];
    
    [self.indexSet addIndex:index];
}



-(void)unsetValueAtIndex:(NSUInteger)index
{
    const void *defaultValue = [self defaultValue];
    if (defaultValue != NULL)
    {
        [super setValue:defaultValue atIndex:index];
    }
    
    [self.indexSet removeIndex:index];
}



-(void)getValue:(void *)buffer atIndex:(NSUInteger)index nextIndex:(NSUInteger *)nextIndex
{
    NSIndexSet *indexSet = self.indexSet;
    
    if (![indexSet containsIndex:index])
    {
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Index not set.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        return;
    }
    
    [super getValue:buffer atIndex:index];
    
    *nextIndex = [indexSet indexGreaterThanIndex:index];
}



-(void)getValue:(void *)buffer atIndex:(NSUInteger)index previousIndex:(NSUInteger *)previousIndex
{
    NSIndexSet *indexSet = self.indexSet;
    
    if (![indexSet containsIndex:index])
    {
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Index not set.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        return;
    }
    
    [super getValue:buffer atIndex:index];
    
    *previousIndex = [indexSet indexLessThanIndex:index];
}



#pragma mark constructors and destructor
-(id)initWithTypeSizeof:(NSUInteger)size defaultValue:(void *)defaultValue
{
    self = [super initWithTypeSizeof:size defaultValue:defaultValue];
    
    if (self)
    {
        indexSet_ = [[NSMutableIndexSet alloc] init];
    }
    
    return self;
}



-(void)dealloc
{
    [indexSet_ release];
    
    [super dealloc];
}

@end
