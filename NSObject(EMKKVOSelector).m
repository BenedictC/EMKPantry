//
//  NSObject(EMKKVOSelector).m
//  EMKPantry
//
//  Created by Benedict Cohen on 20/02/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "NSObject(EMKKVOSelector).h"
#import <objc/runtime.h>

/*!
    @header EMKKVODispatcher.m
    @abstract   Provides methods to allow KVO observors to respond via a selector.
    @discussion 
 
    How this all works:

    Setup
    -----
    S1. target receives request to send KVO notifications to observer
    S2. target fetches dispatcher
    S3. target request the dispatcher stores details of KVO and the observationSelector
    S4. target adds the dispatcher as an observer   

    In use
    ------
    U4. Target generates KVO notification and sends it to the dispatcher
    U5. dispatcher looks up the selector based on the target, keyPath and context
    U6. dispatcher construct invocation from selector and invokes on observer
 
    Teardown
    --------
    T7. Target receives request to remove observer
    T8. Target fetches dispatcher from observer
    T9. Target removes dispatcher as an observer
    T10. Target requests dispatcher remove selector for keyPath
*/





/*!
    @class       EMKKVODispatcher
    @abstract    Class used to handle the KVO notifications and invoke the registered selectors of the associated object.
                 The calling code should never interact with this class directly, all interaction is handled via the
                 EMKKVOSelector category on NSObject.
*/
@interface EMKKVODispatcher : NSObject
{
}
-(id)initWithAssociate:(NSObject *)associate;
@property (readonly) NSObject *associate;
@property (readonly) NSMutableDictionary *selectors;
-(NSString *)keyForTarget:(id)target keyPath:(NSString *)keyPath;
-(void)addObservationSelector:(SEL)observationSelector forTarget:(id)target keyPath:(NSString *)keyPath;
-(void)removeObservationSelectorForTarget:(id)target ofKeyPath:(NSString *)keyPath;
@end





@implementation EMKKVODispatcher


#pragma mark properties
@synthesize associate = associate_;
@synthesize selectors = selectors_;


#pragma mark memory management
-(id)initWithAssociate:(NSObject *)associate
{
    self = [super init];
    
    if (self)
    {
        associate_ = associate;
        selectors_ = [[NSMutableDictionary dictionaryWithCapacity:3] retain]; //3 is arbitary
    }
    
    return self;
}


-(void)dealloc
{
    //TODO: warn that there are still observations registered
    [selectors_ release];
    
    [super dealloc];
}




#pragma mark kvo callback    
//U4. Target generates KVO notification and sends it to the dispatcher
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)target change:(NSDictionary *)change context:(void *)context
{
    //U5. dispatcher looks up the selector based on the target, keyPath and context
    NSString *key = [self keyForTarget:target keyPath:keyPath];
    SEL selector = NSSelectorFromString([self.selectors objectForKey:key]);
        
    //U6. dispatcher construct invocation from selector and invokes on observer
    NSMethodSignature *sig = [self.associate methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setSelector:selector];
    
    NSUInteger numberOfArguments = [sig numberOfArguments];
    for (uint i = 2; i < numberOfArguments; i++) 
    {
        switch (i)
        {
            case 2: //keyPath
                [invocation setArgument:&keyPath atIndex:i];
                break;
            case 3: //object
                [invocation setArgument:&target atIndex:i];                
                break;
            case 4: //change
                [invocation setArgument:&change atIndex:i];                
                break;
            case 5: //context
                if (context != NULL)
                {
                    [invocation setArgument:context atIndex:i];                
                }
                break;
            default:
                //TODO: something's gone wrong!
                break;
        }
    }
    
    [invocation invokeWithTarget:self.associate];
}



#pragma mark private methods
-(NSString *)keyForTarget:(id)target keyPath:(NSString *)keyPath
{
    //We use the address of the target rather than its has because there could be more than one 
    //object with a given hash (espcially data objects use the hash for comparision).
    return [NSString stringWithFormat:@"%u %@", (NSUInteger)target, keyPath];
}



#pragma mark methods called from the NSObject KVODispatcherTarget
-(void)addObservationSelector:(SEL)observationSelector forTarget:(id)target keyPath:(NSString *)keyPath
{
    NSString *key = [self keyForTarget:target keyPath:keyPath];
    
    [self.selectors setObject:NSStringFromSelector(observationSelector) forKey:key];
}


-(void)removeObservationSelectorForTarget:(id)target ofKeyPath:(NSString *)keyPath
{
    NSString *key = [self keyForTarget:target keyPath:keyPath];
    [self.selectors removeObjectForKey:key];
}

@end






@interface NSObject (EMKKVODispatcherObserver)

//The dispatcher could be associated with the observer or the target. 
//We picked the observer because we want to crash in the same way as when an observation is sent to a dealloc'ed instance.
//If we associated with the target then the crash would occur when the dispatcher invoked the selector.
//(the theory behind ensuring we crash the same way is that crash patterns are recognisable so are therefore useful)
-(EMKKVODispatcher *)EMK_kvoDispatcher;

@end





@implementation NSObject (EMKKVOSelector) //a.k.a. EMKKVODispatcherTarget

#pragma mark target methods

//convienince method to cater for most common usage case
-(void)EMK_addObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath selector:(SEL)observationSelector
{
    [self EMK_addObserver:anObserver forKeyPath:keyPath options:0 context:NULL selector:observationSelector];
}




//S1. target receives request to send KVO notifications to observer
-(void)EMK_addObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context selector:(SEL)observationSelector
{
    //TODO: validate selector
    
    
    //S2. target fetches dispatcher
    EMKKVODispatcher *dispatcher = [anObserver EMK_kvoDispatcher];
    
    //S3. target request the dispatcher stores details of KVO and the observationSelector
    [dispatcher addObservationSelector:observationSelector forTarget:self keyPath:keyPath];
    
    //S4. target adds the dispatcher as an observer   
    [self addObserver:dispatcher forKeyPath:keyPath options:options context:context];    
}





//T7. Target receives request to remove observer
-(void)EMK_removeObserver:(NSObject *)anObserver forSelectorObservationWithKeyPath:(NSString *)keyPath
{
    //T8. Target fetches dispatcher from observer
    EMKKVODispatcher *dispatcher = [anObserver EMK_kvoDispatcher];
    
    //T9. Target removes dispatcher as an observer
    [self removeObserver:dispatcher forKeyPath:keyPath];
    
    //T10. Target request dispatcher remove selector for keyPath
    [dispatcher removeObservationSelectorForTarget:self ofKeyPath:keyPath];
}

@end




@implementation NSObject (EMKKVODispatcherObserver)

#pragma mark observer methods
-(EMKKVODispatcher *)EMK_kvoDispatcher
{
    EMKKVODispatcher *dispatcher = objc_getAssociatedObject(self, [EMKKVODispatcher class]);
    if (dispatcher == nil)
    {
        dispatcher = [[EMKKVODispatcher alloc] initWithAssociate:self];
        objc_setAssociatedObject(self, [EMKKVODispatcher class], dispatcher, OBJC_ASSOCIATION_RETAIN);
        [dispatcher release];
    }
    
    return dispatcher;
}


@end



