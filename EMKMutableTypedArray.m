//
//  EMKMutableTypedArray.m
//  EMKPantry
//
//  Created by Benedict Cohen on 23/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKMutableTypedArray.h"
//#import <pthread.h>

#pragma mark EMKTypedArray protected properties
@interface EMKTypedArray ()
@property(readwrite, retain, nonatomic) NSData *data;
@property(readwrite, assign, nonatomic) NSUInteger count;
@property(readwrite, assign, nonatomic) NSUInteger typeSize;
@end




@interface EMKMutableTypedArray ()
@property(readwrite, retain, nonatomic) NSMutableData *data; 
@property(readwrite, assign, nonatomic) void *defaultValuePtr;
//@property(readonly, assign, nonatomic) pthread_rwlock_t readWriteLock;
//-(BOOL)readLock;
//-(BOOL)writeLock;
//-(void)unlock:(BOOL)perfromUnlock;


-(void)reallocateDataForLength:(NSUInteger)newLength;//this is only accessed from thread-safe methods
@end



@implementation EMKMutableTypedArray

#pragma mark class methods
+(id)typedArrayWithTypeSizeof:(NSUInteger)size defaultValue:(const void *)defaultValue;
{
    return [[[self alloc] initWithTypeSizeof:size defaultValue:defaultValue] autorelease];    
}



+(id)typedArrayWithTypeSizeof:(NSUInteger)size bytes:(const void *)bytes count:(NSUInteger)count defaultValue:(const void *)defaultValue
{
    return  [[[self alloc] initWithTypeSizeof:size bytes:bytes count:count defaultValue:defaultValue] autorelease];
}



+(id)typedArrayWithTypedArray:(EMKTypedArray *)typedArray defaultValue:(const void *)defaultValue
{
    return  [[[self alloc] initWithTypedArray:typedArray defaultValue:defaultValue] autorelease];
}



#pragma mark state mutators and accessors
@dynamic data;
//@synthesize readWriteLock = readWriteLock_;



@synthesize defaultValuePtr = defaultValuePtr_;
-(const void *)defaultValue
{
    //this is set at creation time and never changed, therefore it isn't at risk of thread related nasties
    return defaultValuePtr_;
}



-(void)getDefaultValue:(void *)buffer
{
    const void *defaultValue = self.defaultValue;
    if (defaultValue != NULL)
    {
        memcpy(buffer, defaultValue, self.typeSize);
    }
}



-(NSUInteger)count
{
    NSUInteger result = NSNotFound;
//    BOOL isUnlockRequired = [self readLock];
    result = [super count];
//    [self unlock:isUnlockRequired];
    return result;
}



-(void)setCount:(NSUInteger)count
{
//    BOOL isUnlockRequired = [self writeLock];
    [super setCount: count];
//    [self unlock:isUnlockRequired];
}



-(void)trimToLength:(NSUInteger)newLength
{
//    BOOL isUnlockRequired = [self writeLock];

    NSUInteger count = self.count;
    //if we're already smaller than newLength then do nothing
    if (count > newLength) 
    {
        self.count = newLength;
        [self reallocateDataForLength:newLength];
    }
    
//    [self unlock:isUnlockRequired];
}



-(void)getValue:(void *)buffer atIndex:(NSUInteger)index
{
//    BOOL isUnlockRequired = [self readLock];
    [super getValue:buffer atIndex:index];
//    [self unlock:isUnlockRequired];
}



-(void)setValue:(const void *)buffer atIndex:(NSUInteger)index
{
//    BOOL isUnlockRequired = [self writeLock];
    
    if (index >= NSNotFound)
    {
//        [self unlock:isUnlockRequired];
        
        //Throw a range exception        
        NSString *reason = [NSString stringWithFormat:@"*** -[%@ %@:]: Attempted to set value at index NSNotFound.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        [[NSException exceptionWithName:NSRangeException reason:reason userInfo:nil] raise];
        return;
    }
    
    
    [self reallocateDataForLength:index+1];
    NSMutableData *data = self.data;
    
    //Copy from buffer into data
    //This assumes that a char has a size 1 byte.
    char *bytes = [data mutableBytes];    
    NSUInteger typeSize = self.typeSize;
    memcpy(&(bytes[index * typeSize]), buffer, typeSize);    
    
    
    //update count
    NSUInteger count = self.count;
    self.count = MAX(count, index+1);
//    [self unlock:isUnlockRequired];
}



-(void)addValue:(const void *)buffer
{
//    BOOL isUnlockRequired = [self writeLock];
    
    NSUInteger count = self.count;
    [self setValue:buffer atIndex:count];
    
//    [self unlock:isUnlockRequired];
}



-(void)reallocateDataForLength:(NSUInteger)newLength
{
    //This method should only be called from other thread safe methods. This method is private.
    //We could wrap it in @synchronized(self), but that's expensive and shouldn't be neccessary if the above is adherd to.
    NSData *data = (self.data) ?: [NSMutableData data];
    const NSUInteger typeSize = self.typeSize;
    const NSUInteger capacity = [data length] / typeSize;    
    const NSUInteger normalizedIndex  = MAX(newLength, 10);
    const NSUInteger requiredCapacity = MIN(2 * normalizedIndex, NSIntegerMax-1);    
    
    //if data is not big enough
    //or data is more than twice the required capacity
    //or the data is not mutable
    BOOL isDataMutable = [data isKindOfClass:[NSMutableData class]];
    if (capacity <= newLength || capacity > newLength * 2 || !isDataMutable)
    {
        NSMutableData *mData = (isDataMutable) ? data : [NSMutableData dataWithData:data];
        //extend buffer
        const NSUInteger newBufLength = requiredCapacity * typeSize;
        [mData setLength:newBufLength];
        
        //fill the area of new buf that does not contain existing data with the default value
        const void *defaultValue = self.defaultValue;                    
        if (defaultValue != NULL)
        {
            void *buffer = [mData mutableBytes];
            for (NSUInteger i = capacity; i < requiredCapacity; i++) 
            {
                void *dest = &(((char *)buffer)[i * typeSize]);
                memcpy(dest, defaultValue, typeSize);
            }
        }
        
        //create new data object with the new buffer
        self.data = mData;
    }
}



//#pragma mark locking
//-(BOOL)readLock
//{
//    int lockAttemptResult = pthread_rwlock_tryrdlock(&readWriteLock_);
//    if (lockAttemptResult == EDEADLK)
//    {
//        //Obtaining multiple read locks is allowed so I don't think we'll ever see EDEADLK        
//        return NO;
//    }
//    else if (lockAttemptResult == 0)
//    {
//        return YES;
//    }
//
//    //get a lock no matter what
//    pthread_rwlock_rdlock(&readWriteLock_);    
//    
//    return YES;
//}
//
//
//
//-(BOOL)writeLock
//{
//    //TODO: What happens if we already have a readLock?
//    int lockAttemptResult = pthread_rwlock_trywrlock(&readWriteLock_);
//    if (lockAttemptResult == EDEADLK)
//    {
//        //we already have the write lock
//        return NO;   
//    }
//    else if (lockAttemptResult == 0)
//    {
//        return YES;
//    }
//
//    //get a lock no matter what    
//    pthread_rwlock_wrlock(&readWriteLock_);    
//    
//    return YES;    
//}
//
//
//
//-(void)unlock:(BOOL)perfromUnlock
//{
//    if (perfromUnlock)
//    {
//        pthread_rwlock_unlock(&readWriteLock_);
//    }
//}



#pragma mark constructors/destructors
-(id)initWithTypeSizeof:(NSUInteger)size bytes:(const void *)bytes count:(NSUInteger)count
{
    return [self initWithTypeSizeof:size bytes:bytes count:count defaultValue:NULL];
}



-(id)initWithTypeSizeof:(NSUInteger)size defaultValue:(const void *)defaultValue 
{
    return [self initWithTypeSizeof:size bytes:NULL count:0 defaultValue:defaultValue];
}



-(id)initWithTypeSizeof:(NSUInteger)size bytes:(const void *)bytes count:(NSUInteger)count defaultValue:(const void *)defaultValue //designated initializer
{
    self = [super initWithTypeSizeof:size bytes:bytes count:count];
    
    if (self)
    {
//        //TODO: check the return type
//        pthread_rwlock_init(&readWriteLock_, NULL);
        
        if (defaultValue == NULL)
        {
            defaultValuePtr_ = NULL;                        
        }
        else
        {
            defaultValuePtr_ = malloc(size);
            memcpy(defaultValuePtr_, defaultValue, size);
        }
    }
    
    return self;
}



-(id)initWithTypedArray:(EMKTypedArray *)typedArray defaultValue:(const void *)defaultValue
{
    self = [self initWithTypeSizeof:typedArray.typeSize defaultValue:defaultValue];
    
    self.data = [[typedArray.data mutableCopy] autorelease];

    return self;
}



-(void)dealloc
{
    if (defaultValuePtr_ != NULL) free(defaultValuePtr_);
//    pthread_rwlock_destroy(&readWriteLock_);
    
    [super dealloc];
}



#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
//    BOOL isUnlockRequired = [self readLock];

    id dolly = [super copyWithZone:zone];
    
//    [self unlock:isUnlockRequired];
    
    return dolly;
}



#pragma mark NSMutableCopying
-(id)mutableCopyWithZone:(NSZone *)zone
{
//    BOOL isUnlockRequired = [self readLock];

    EMKMutableTypedArray *dolly = [[EMKMutableTypedArray alloc] initWithTypeSizeof:self.typeSize bytes:[self.data bytes] count:self.count defaultValue:self.defaultValuePtr];
    
//    [self unlock:isUnlockRequired];
    
    return dolly;        
}

@end




#pragma mark NSMutableCopying
@implementation EMKTypedArray (NSMutableCopying)

-(id)mutableCopyWithZone:(NSZone *)zone
{
    EMKMutableTypedArray *dolly = [[EMKMutableTypedArray alloc] initWithTypeSizeof:self.typeSize bytes:[self.data bytes] count:self.count];
       
    return dolly;        
}

@end
