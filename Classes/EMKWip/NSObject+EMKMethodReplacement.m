//
//  NSObject+EMKMethodReplacement.m
//  EMKPantry
//
//  Created by Benedict Cohen on 28/05/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "NSObject+EMKMethodReplacement.h"



NSString * const EMKMethodReplacementReplacementImplementations = @"EMKMethodReplacementReplacementImplementations";




@implementation NSObject (EMKMethodReplacement)

#pragma mark method replacement
+(void)EMK_replaceInstanceMethodForSelector:(SEL)selector withImplementation:(IMP)newImplementation
{
    //1.get reference to original method and store it
    Method originalMethod = class_getInstanceMethod(self, selector);
    IMP originalImp = (void *)method_getImplementation(originalMethod);
    
    
    //2.store original imp with selector by newImp & selector
    //2a. create key by XOR the address newImp and the chars of selector
    void * key = newImplementation;
    int i = 0;
    char* sel = (char *)selector;
    while (sel[i] != '\0')
    {
        key = (void *)((int)key ^ sel[i]);
        i++;
    }

    //2b. store key
    CFMutableDictionaryRef imps = (CFMutableDictionaryRef)objc_getAssociatedObject(self, EMKMethodReplacementReplacementImplementations);
    if (imps == NULL)
    {
        imps = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
        objc_setAssociatedObject(self, EMKMethodReplacementReplacementImplementations, (id)imps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    CFDictionarySetValue(imps, key, originalImp);
    
    
    //3. Attempt to add the method to the class. The method may be implemented in a superclass.
    //By adding a method we dynamically override the superclass implementation
    BOOL didAddMethodToClass = class_addMethod(self, selector, newImplementation, method_getTypeEncoding(originalMethod));
    
    //4. if the method wasn't added then we assume that the method is implement on 
    //this class and not a superclass and simply replace the impementation.
    if(!didAddMethodToClass)
    {
        method_setImplementation(originalMethod, newImplementation);    
    }
}



+(IMP)EMK_instanceMethodForSelector:(SEL)selector replacedByImplementation:(IMP)laterImplementation
{
    //create key
    void * key = laterImplementation;
    int i = 0;
    char* sel = (char *)selector;
    while (sel[i] != '\0')
    {
        key = (void *)((int)key ^ sel[i]);
        i++;
    }
    
    
    //find imp by walking up the class tree
    IMP imp = NULL;
    Class class = self;
    while (imp == NULL)
    {
        CFMutableDictionaryRef imps = (CFMutableDictionaryRef)objc_getAssociatedObject(class, EMKMethodReplacementReplacementImplementations);
        
        if (imps != NULL)
        {
            imp = CFDictionaryGetValue(imps, key);
        }
        
        class = [class superclass];
    }
    
    return imp;
}



+(void)EMK_replaceInstanceMethodForSelector:(SEL)selector withImplementationBlock:(void *(^)(id, SEL, ...))impBlock
{
    [self EMK_replaceInstanceMethodForSelector:selector withImplementation:imp_implementationWithBlock(impBlock)];
}


@end
