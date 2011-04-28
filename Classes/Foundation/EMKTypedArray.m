//
//  EMKTypedArray.m
//  EMKPantry
//
//  Created by Benedict Cohen on 15/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKTypedArray.h"

/****

 TODO
 ====
 - Check return state of locks
 - We could replace memcpy with NSData methods, but we wouldn't gain much
  
****/


#pragma mark Protected properties & methods
@interface EMKTypedArray ()
@property(readwrite, retain, nonatomic) NSData *data;
@property(readwrite, assign, nonatomic) NSUInteger count;
@property(readwrite, assign, nonatomic) NSUInteger typeSize;
@end



@implementation EMKTypedArray

#pragma mark class methods
+(id)typedArrayWithTypeSizeof:(NSUInteger)size
{
    return [[[self alloc] initWithTypeSizeof:size] autorelease];
}



+(id)typedArrayWithTypeSizeof:(NSUInteger)size bytes:(const void *)bytes count:(NSUInteger)count
{
    return [[[self alloc] initWithTypeSizeof:size bytes:bytes count:count] autorelease];
}



#pragma mark state mutators and accessors
@synthesize data = data_; //private
@synthesize count = count_;
@synthesize typeSize = typeSize_;



-(void)getValue:(void *)buffer atIndex:(NSUInteger)index
{
    NSUInteger count = self.count;
    if (index >= count)
    {
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Attempted to get value at invalid index.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSRangeException reason:reason userInfo:nil] raise];
        return;
    }
    
    //Copy from data into buffer
    //This assumes that a char has a size 1 byte.
    char *bytes = (char *)[self.data bytes];
    NSUInteger typeSize = self.typeSize;
    memcpy(buffer, (const void *)&(bytes[index * typeSize]), typeSize);
}



#pragma mark constructors/destructors
-(id)init
{
    return [self initWithTypeSizeof:0 bytes:NULL count:0];
}



-(id)initWithTypeSizeof:(NSUInteger)size
{
    return [self initWithTypeSizeof:size bytes:NULL count:0];
}



//designated initializer
-(id)initWithTypeSizeof:(NSUInteger)size bytes:(const void *)bytes count:(NSUInteger)count
{
    if (size < 1)
    {
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Attempted to create with typeSize 0.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        return nil;
    } 
    else if (count >= NSIntegerMax)
    {
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Attempted to create with count >= NSIntegerMax.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        return nil;
    }
    
    self = [super init];
    
    if (self)
    {
        data_ = [[NSData alloc] initWithBytes:bytes length:size * count];
        count_ = count;
        typeSize_ = size;        
    }
    
    return self;
}



-(void)dealloc
{
    [data_ release];
    
    [super dealloc];
}



#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    //TODO: is [self class] correct? we'll be returning a mutable copy if it's the copy is invoked on a mutable instances, which is incorrect.
    EMKTypedArray *dolly = [[EMKTypedArray alloc] initWithTypeSizeof:self.typeSize];
    //setting the properties after the init mean that we may avoid creating another NSData
    dolly.data = [[self.data copy] autorelease];
    dolly.count = self.count;
    
    return dolly;        
}

@end
