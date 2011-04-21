//
//  EMKTypedArray.m
//  EMKPantry
//
//  Created by Benedict Cohen on 15/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKTypedArray.h"


@interface EMKTypedArray ()

@property(readwrite, nonatomic, assign) NSUInteger typeSize;
@property(readwrite, nonatomic, retain) NSData *data;
@property(readwrite, nonatomic, assign) void *defaultValuePtr;
@property(readwrite, nonatomic, assign) NSUInteger lastIndex;
-(void)reallocateDataForUpperIndex:(NSUInteger)upperIndex;
@end



@implementation EMKTypedArray

#pragma mark class methods
+(id)typedArrayWithTypeSizeof:(NSUInteger)size
{
    return [[[self alloc] initWithTypeSizeof:size] autorelease];
}



+(id)typedArrayWithTypeSizeof:(NSUInteger)size defaultValue:(void *)defaultValue;
{
    return [[[self alloc] initWithTypeSizeof:size defaultValue:defaultValue] autorelease];    
}




#pragma mark state mutators and accessors
@synthesize typeSize = typeSize_;
@synthesize data = data_;
@synthesize defaultValuePtr = defaultValuePtr_;



-(const void *)defaultValue
{
    return defaultValuePtr_;
}



@synthesize lastIndex = lastIndex_;
-(NSUInteger)lastIndex
{
    return lastIndex_;
}


-(void)cropLastIndexTo:(NSUInteger)aIndex
{
    //if aIndex is too large, but not equal to NSNotFound, then run away!
    if (   (aIndex >= lastIndex_ && aIndex != NSNotFound)
        || (lastIndex_ == NSNotFound)) return;
    
    lastIndex_ = aIndex;
    
    
    [self reallocateDataForUpperIndex:lastIndex_];
}



-(void)getValue:(void *)buffer atIndex:(NSUInteger)index
{
    if (lastIndex_ == NSNotFound || index > lastIndex_)
    {
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Attempted to get value at invalid index.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSRangeException reason:reason userInfo:nil] raise];
        return;
    }
    
    //Copy from data into buffer
    //This assumes that a char has a size 1 byte.
    char *bytes = (char *)[self.data bytes];
    memcpy(buffer, (const void *)&(bytes[index * typeSize_]), typeSize_);
}



-(void)setValue:(const void *)buffer atIndex:(NSUInteger)index
{
    if (index >= NSNotFound)
    {
        //Throw a range exception        
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Attempted to set value at index NSNotFound.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSRangeException reason:reason userInfo:nil] raise];
        return;
    }
    

    [self reallocateDataForUpperIndex:index];
    NSData *data = self.data;
    
    
    //Copy from buffer into data
    //This assumes that a char has a size 1 byte.
    char *bytes = (char *)[data bytes];    
    memcpy(&(bytes[index * typeSize_]), buffer, typeSize_);    
    
    
    //update upperIndex
    if (index > lastIndex_ || lastIndex_ == NSNotFound) lastIndex_ = index;
}



-(void)addValue:(const void *)buffer
{
    NSUInteger lastIndex = self.lastIndex;
    [self setValue:buffer atIndex:(lastIndex == NSNotFound) ? 0 : lastIndex_+1];
}



-(void)getDefaultValue:(void *)buffer
{
    const void *defaultValue = self.defaultValue;
    if (defaultValue == NULL)
    {
        buffer = NULL;
        return;
    }
    
    memcpy(buffer, defaultValue, typeSize_);
}



-(void)reallocateDataForUpperIndex:(NSUInteger)upperIndex
{
    NSData *data = (self.data) ?: [NSData data];
    uint capacity = [data length] / typeSize_;    
    uint normalizedIndex = (upperIndex == NSNotFound || upperIndex == 0) ? 10 : upperIndex;
    uint requiredCapacity = MIN(2 * normalizedIndex, NSIntegerMax-1);    
    
    //if data is not big enough
    //or data is more than twice the required capacity
    if (capacity <= upperIndex || capacity > upperIndex * 2)
    {
        //create new buffer and copy content from existing buffer
        NSUInteger newBufLength = requiredCapacity * typeSize_;
        void *newBuf = malloc(newBufLength);
        NSUInteger copyCount = MIN([data length], newBufLength);
        memcpy(newBuf, [data bytes], copyCount);
        
        
        //fill the area of new buf that does not contain existing data with the default value
        const void *defaultValue = self.defaultValue;                    
        if (defaultValue != NULL)
        {
            for (int i = capacity; i < requiredCapacity; i++) 
            {
                void *dest = &(((char *)newBuf)[i * typeSize_]);
                memcpy(dest, defaultValue, typeSize_);
            }
        }
        
        //create new data object with the new buffer
        self.data = [NSData dataWithBytesNoCopy:newBuf length:newBufLength freeWhenDone:YES];
    }
}



#pragma mark constructors/destructors
-(id)initWithTypeSizeof:(NSUInteger)size
{
    return [self initWithTypeSizeof:size defaultValue:NULL];
}



//designated initializer
-(id)initWithTypeSizeof:(NSUInteger)size defaultValue:(void *)defaultValue
{
    self = [super init];
    
    if (self)
    {
        typeSize_ = size;
        data_ = nil;
        lastIndex_ = NSNotFound;
        
        if (defaultValue == NULL)
        {
            defaultValuePtr_ = NULL;                        
        }
        else
        {
            defaultValuePtr_ = malloc(typeSize_);
            memcpy(defaultValuePtr_, defaultValue, typeSize_);
        }
    }
    
    
    return self;
}



-(void)dealloc
{
    [data_ release];
    if (defaultValuePtr_ != NULL) free(defaultValuePtr_);
    
    [super dealloc];
}



@end
