//
//  NSObject+EMKKVOSelector.m
//  EMKPantry
//
//  Created by Benedict Cohen on 20/02/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "NSObject+EMKKVOSelector.h"
#import <objc/runtime.h>

/*!
    @header EMKKVODispatcher.m
    @abstract   Provides methods to allow KVO observors to respond via a selector.
    @discussion 
 
    How this works:

    Setup
    -----
    S1. target receives request to send KVO notifications to observer
    S2. target fetches the observers dispatcher
    S3. target request that the dispatcher stores details of KVO and the observationSelector
    S4. target adds the dispatcher as an observer

    In use
    ------
    U4. Target generates KVO notification and sends it to the observers dispatcher
    U5. dispatcher looks up the selectors based on the target, keyPath and context
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


@property (readonly) NSObject *associate;
@property (readonly) NSMutableDictionary *selectors;

-(id)initWithAssociate:(NSObject *)associate;

-(NSArray *)keysForTarget:(id)target keyPath:(NSString *)keyPath;
-(NSString *)keyForTarget:(id)target keyPath:(NSString *)keyPath selector:(SEL)selector;

-(void)addObservationSelector:(SEL)observationSelector forTarget:(id)target keyPath:(NSString *)keyPath;
-(void)removeObservationSelector:(SEL)observationSelector forTarget:(id)target ofKeyPath:(NSString *)keyPath;
-(BOOL)isObserving:(id)target withKeyPath:(NSString *)keyPath selector:(SEL)selector;
@end






@interface NSObject (EMKKVODispatcherObserver)

//The dispatcher could be associated with the observer or the target. 
//We picked the observer because we want to crash in the same way as when an observation is sent to a dealloc'ed instance.
//If we associated with the target then the crash would occur when the dispatcher invoked the selector.
//(the theory behind ensuring we crash the same way is that crash patterns are recognisable so are therefore useful)
-(EMKKVODispatcher *)EMK_kvoDispatcher;
-(BOOL)EMK_isDispatcherAlive;
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
        associate_ = associate;//we retain to avoid a retain cycle
        selectors_ = [[NSMutableDictionary dictionaryWithCapacity:3] retain]; //3 is arbitary
    }
    
    return self;
}


-(void)dealloc
{
    //warn that there are still observations registered
    if ([selectors_ count])
    {
        NSString *logMsg = [NSString stringWithFormat:@"%@: KVO selectors still registered for dealloced object:", NSStringFromClass([associate_ class])];
        for (NSString *key in [selectors_ allKeys]) 
        {
            NSArray *comps = [key componentsSeparatedByString:@" "];
            id target =  (id)[[comps objectAtIndex:0] intValue];
            logMsg = [logMsg stringByAppendingFormat:@"\n    target: <%@: 0x%x>\n    keyPath: %@\n    selector: %@", NSStringFromClass([target class]), (uint)target, [comps objectAtIndex:1], [comps objectAtIndex:2]];
        }
        NSLog(@"%@", logMsg);
    }
    [selectors_ release];
    
    [super dealloc];
}




#pragma mark kvo callback    
//U4. Target generates KVO notification and sends it to the dispatcher
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)target change:(NSDictionary *)change context:(void *)context
{
    //U5. dispatcher looks up the selectors based on the target, keyPath and context
    for(NSString *key in [self keysForTarget:target keyPath:keyPath])
    {
        SEL selector;
        @synchronized(self)
        {
            selector = NSSelectorFromString([self.selectors objectForKey:key]);
        }
        
        if (selector == nil) continue;
        
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
}



#pragma mark private methods
-(NSArray *)keysForTarget:(id)target keyPath:(NSString *)keyPath
{
    NSString *keyPrefix = [NSString stringWithFormat:@"%u %@", (NSUInteger)target, keyPath];
    
    @synchronized(self)
    {
        return [[self.selectors allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH %@", keyPrefix]];
    }
}



-(NSString *)keyForTarget:(id)target keyPath:(NSString *)keyPath selector:(SEL)observationSelector
{
    //We use the address of the target rather than its has because there could be more than one 
    //object with a given hash (espcially data objects use the hash for comparision).
    return [NSString stringWithFormat:@"%u %@ %@", (NSUInteger)target, keyPath, NSStringFromSelector(observationSelector)];
}



#pragma mark methods called from the NSObject KVODispatcherTarget
-(void)addObservationSelector:(SEL)observationSelector forTarget:(id)target keyPath:(NSString *)keyPath
{
    @synchronized(self)
    {
        NSString *key = [self keyForTarget:target keyPath:keyPath selector:observationSelector];
        [self.selectors setObject:NSStringFromSelector(observationSelector) forKey:key];
    }
}



-(void)removeObservationSelector:(SEL)observationSelector forTarget:(id)target ofKeyPath:(NSString *)keyPath
{
    @synchronized(self)
    {
        NSString *key = [self keyForTarget:target keyPath:keyPath selector:observationSelector];
        [self.selectors removeObjectForKey:key];
    }
}



-(BOOL)isObserving:(id)target withKeyPath:(NSString *)keyPath selector:(SEL)observationSelector
{
    @synchronized(self)
    {
        return !![self.selectors objectForKey:[self keyForTarget:target keyPath:keyPath selector:observationSelector]];
    }
}

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
-(void)EMK_removeObserver:(NSObject *)anObserver withKeyPath:(NSString *)keyPath selector:(SEL)observationSelector;
{
    //T8. Target fetches dispatcher from observer
    EMKKVODispatcher *dispatcher = [anObserver EMK_kvoDispatcher];
    
    //T9. Target removes dispatcher as an observer
    [self removeObserver:dispatcher forKeyPath:keyPath];
    
    //T10. Target request dispatcher remove selector for keyPath
    [dispatcher removeObservationSelector:observationSelector forTarget:self ofKeyPath:keyPath];
}



-(BOOL)EMK_isObject:(id)possibleObserver observerOfKeyPath:(NSString *)keyPath withSelector:(SEL)selector
{
    if (![possibleObserver EMK_isDispatcherAlive])
    {
        return NO;
    }
    
    EMKKVODispatcher *dispatcher = [possibleObserver EMK_kvoDispatcher];
    
    return [dispatcher isObserving:self withKeyPath:keyPath selector:selector];
}


@end

            
            



@implementation NSObject (EMKKVODispatcherObserver)

#pragma mark observer methods
-(BOOL)EMK_isDispatcherAlive
{
    return !!objc_getAssociatedObject(self, [EMKKVODispatcher class]);    
}
           
            
            
-(EMKKVODispatcher *)EMK_kvoDispatcher
{
    @synchronized(self)
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
}


@end



