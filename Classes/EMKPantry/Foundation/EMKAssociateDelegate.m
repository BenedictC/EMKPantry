//
//  EMKAssociateDelegate.m
//  EMKPantry
//
//  Created by Benedict Cohen on 17/02/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#ifdef __IPHONE_4_3

#import "EMKAssociateDelegate.h"
#import <objc/runtime.h>


@interface EMKAssociateDelegate ()
@property(readwrite, retain) NSArray *blocks;
@end


@implementation EMKAssociateDelegate


#pragma mark Properties
@synthesize blocks = blocks_;




#pragma mark life cycle
-(void)dealloc
{
    self.blocks = nil;
    
    [super dealloc];
}




#pragma mark instance methods
-(void)respondToSelector:(SEL)aSelector typeEncoding:(const char *)types usingBlock:(void *)block
{
    //copy block to the heap and keep a reference to it
    void *copiedBlock = Block_copy(block);
    NSArray *blocks = self.blocks;
    self.blocks = (blocks) ? [blocks arrayByAddingObject:copiedBlock] : [NSArray arrayWithObject:copiedBlock];
    Block_release(copiedBlock);
    
    
    //get the IMP of the block and add it as an instance methods to this class
    IMP blockImp = imp_implementationWithBlock(copiedBlock);
    class_addMethod([self class], aSelector, blockImp, types);
}




@end






@implementation NSObject (EMKAssociateDelegate)

-(EMKAssociateDelegate *)EMK_associateDelegate
{
    const id associateKey = [EMKAssociateDelegate class];
    
    //attempt to fetch an existing associatedDelegate
    EMKAssociateDelegate *aDelegate = objc_getAssociatedObject(self, associateKey);
    
    if (aDelegate == nil)
    {
        //TODO: it would be more OO to add the creation of the subclass as a factory methods to EMKAssociatedDelegate. But doing so would add an extra method for no benefit.
        
        //create and register a subclass of EMKAssociatedDelegate that is unique to self
        //TODO: The class name will be unique, but this code is not thread safe.
        int subClassCounter = 0;
        NSString *assocDelegateSubClassName = nil;        
        do 
        {
            assocDelegateSubClassName = [NSString stringWithFormat:@"EMKAssociateDelegate-%@-0x%x-%i", NSStringFromClass([self class]), (NSUInteger)self, subClassCounter];
            subClassCounter++;
        } while (NSClassFromString(assocDelegateSubClassName));
        
        Class assocDelegateSubClass = objc_allocateClassPair([EMKAssociateDelegate class], [assocDelegateSubClassName UTF8String], 0);        
        objc_registerClassPair(assocDelegateSubClass);

        
        //create an instance of the delegate and store it as an associated object
        aDelegate = [assocDelegateSubClass new];            
        objc_setAssociatedObject(self, associateKey, aDelegate, OBJC_ASSOCIATION_RETAIN);
        [aDelegate release];
    }
    
    return aDelegate;
}



@end

#endif
