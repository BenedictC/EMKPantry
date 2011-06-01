//
//  NSObject+EMKRuntimeProperties.m
//  Jot
//
//  Created by Benedict Cohen on 30/05/2011.
//  Copyright 2011 Electric Muffin Kitchen. All rights reserved.
//

#import "NSObject+EMKRuntimeProperties.h"
#import "NSMethodSignature+EMKMethodTypeEncoding.h"

#pragma mark -
#pragma mark EMKRuntimePropertyAttributes interface

@interface EMKRuntimePropertyAttributes : NSObject 
{
}

+(NSMutableDictionary *)properties;
+(void)addObjectProperty:(NSString *)propertyName ofClass:(Class)cls policy:(objc_AssociationPolicy)policy;
+(void)addScalarProperty:(NSString *)propertyName ofClass:(Class)cls size:(NSUInteger)size default:(void *)defaultValue;
+(EMKRuntimePropertyAttributes *)propertyAttributesForProperty:(NSString *)propertyName ofClass:(Class)cls;

@property(readwrite, nonatomic, assign) NSUInteger size;
@property(readwrite, nonatomic, assign) objc_AssociationPolicy policy;
@property(readwrite, nonatomic, copy) NSString *key;
@property(readwrite, nonatomic, copy) NSData *defaultValue;
@end



#pragma mark -
#pragma mark EMKRuntimePropertyAttributes implementation

@implementation EMKRuntimePropertyAttributes

+(NSMutableDictionary *)properties
{
    static NSMutableDictionary *properties = nil;
    if (properties == nil)
    {
        properties = [NSMutableDictionary new];
    }
    return properties;
}



+(void)addObjectProperty:(NSString *)propertyName ofClass:(Class)cls policy:(objc_AssociationPolicy)policy
{
    @synchronized([EMKRuntimePropertyAttributes class])
    {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        NSMutableDictionary *properties = [EMKRuntimePropertyAttributes properties];
        
        NSString *key = [NSString stringWithFormat:@"%@:%@:EMKRuntimeProperty", NSStringFromClass(cls), propertyName];
        EMKRuntimePropertyAttributes *propertyAttribs = [[EMKRuntimePropertyAttributes new] autorelease];
        propertyAttribs.key = key;
        propertyAttribs.policy = policy;
        
        [properties setObject:propertyAttribs forKey:key];
        
        [pool drain];
    }
}



+(void)addScalarProperty:(NSString *)propertyName ofClass:(Class)cls size:(NSUInteger)size default:(void *)defaultValue
{
    @synchronized([EMKRuntimePropertyAttributes class])
    {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        NSMutableDictionary *properties = [EMKRuntimePropertyAttributes properties];
        
        NSString *key = [NSString stringWithFormat:@"%@:%@:EMKRuntimeProperty", NSStringFromClass(cls), propertyName];
        EMKRuntimePropertyAttributes *propertyAttribs = [[EMKRuntimePropertyAttributes new] autorelease];
        propertyAttribs.key = key;
        propertyAttribs.size = size;
        propertyAttribs.defaultValue = [NSData dataWithBytes:defaultValue length:size];
        
        [properties setObject:propertyAttribs forKey:key];
        
        [pool drain];
    }
}



+(EMKRuntimePropertyAttributes *)propertyAttributesForProperty:(NSString *)propertyName ofClass:(Class)cls
{
    @synchronized([EMKRuntimePropertyAttributes class])
    {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        
        NSMutableDictionary *properties = [self properties];
        
        Class currentClass = cls;        
        NSString *key = [NSString stringWithFormat:@"%@:%@:EMKRuntimeProperty", NSStringFromClass(currentClass), propertyName];
        EMKRuntimePropertyAttributes *propertyAttribs = nil;        
        do
        {
            propertyAttribs = [[properties objectForKey:key] retain]; //we retain because of the autorelease pool
            
            currentClass = [currentClass superclass];
            key = [NSString stringWithFormat:@"%@:%@:EMKProperty", NSStringFromClass(currentClass), propertyName];
        }
        while (propertyAttribs == nil && currentClass != [currentClass superclass]);        
        
        [pool drain];
        
        return [propertyAttribs autorelease];
    }
}


@synthesize size = size_;
@synthesize policy = policy_;
@synthesize key = key_;
@synthesize defaultValue = defaultValue_;

-(void)dealloc
{
    [key_ release];
    [defaultValue_ release];
    
    [super dealloc];
}

@end




id EMKDynamicObjectGetter(id self, SEL _cmd);
void EMKDynamicObjectSetter(id self, SEL _cmd, id value);
const void *EMKDynamicScalarGetter(id self, SEL _cmd);
void EMKDynamicScalarSetter(id self, SEL _cmd, void *);



@implementation NSObject (EMKRuntimeProperties)


#pragma mark property adding
+(void)EMK_addObjectProperty:(NSString *)propertyName policy:(objc_AssociationPolicy)policy
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    //Store the properties attribs
    [EMKRuntimePropertyAttributes addObjectProperty:propertyName ofClass:self policy:policy];
    
    
    //add methods to instances
    SEL getter = EMK_getterSelectorForPropertyName(propertyName);
    if (![self instancesRespondToSelector:getter])
    {
        class_addMethod(self, getter, (IMP)EMKDynamicObjectGetter,  [NSMethodSignature EMK_typesForMethodWithReturnType:@encode(id) argumentTypes: NULL]);
    }
    
    
    SEL setter = EMK_setterSelectorForPropertyName(propertyName);
    if (![self instancesRespondToSelector:setter])
    {
        class_addMethod(self, setter, (IMP)EMKDynamicObjectSetter,  [NSMethodSignature EMK_typesForMethodWithReturnType:@encode(void) argumentTypes:@encode(id), NULL]);    
    }
    
    
    [pool drain];
}



+(void)EMK_addScalarProperty:(NSString *)propertyName size:(NSUInteger)size defaultValue:(void *)defaultValue
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    //Store the properties attribs
    [EMKRuntimePropertyAttributes addScalarProperty:propertyName ofClass:self size:size default:defaultValue];
    
    
    //add methods to instances
    SEL getter = EMK_getterSelectorForPropertyName(propertyName);
    class_addMethod(self, getter, (IMP)EMKDynamicScalarGetter,  [NSMethodSignature EMK_typesForMethodWithReturnType:@encode(id) argumentTypes: NULL]);
    
    SEL setter = EMK_setterSelectorForPropertyName(propertyName);
    class_addMethod(self, setter, (IMP)EMKDynamicScalarSetter,  [NSMethodSignature EMK_typesForMethodWithReturnType:@encode(void) argumentTypes:@encode(id), NULL]);    
    
    
    //TODO: Add defaults
    
    [pool drain];
}





-(id)EMK_getValueForObjectProperty:(NSString *)propertyName
{
    EMKRuntimePropertyAttributes *propertyAttribs = [EMKRuntimePropertyAttributes propertyAttributesForProperty:propertyName ofClass:[self class]];
    
    return objc_getAssociatedObject(self, propertyAttribs.key);
}



-(void)EMK_setValue:(id)value forObjectProperty:(NSString *)propertyName
{
    EMKRuntimePropertyAttributes *propertyAttribs = [EMKRuntimePropertyAttributes propertyAttributesForProperty:propertyName ofClass:[self class]];
    
    objc_setAssociatedObject(self, propertyAttribs.key, value, propertyAttribs.policy);
}



-(const void *)EMK_getValueForScalarProperty:(NSString *)propertyName
{
    EMKRuntimePropertyAttributes *propertyAttribs = [EMKRuntimePropertyAttributes propertyAttributesForProperty:propertyName ofClass:[self class]];
    
    NSData *data = objc_getAssociatedObject(self, propertyAttribs.key);
    
    return (data) ? [data bytes] : [propertyAttribs.defaultValue bytes];
}



-(void)EMK_setValue:(void *)value forScalarProperty:(NSString *)propertyName
{
    EMKRuntimePropertyAttributes *propertyAttribs = [EMKRuntimePropertyAttributes propertyAttributesForProperty:propertyName ofClass:[self class]];
    
    NSData *data = [NSData dataWithBytes:value length:propertyAttribs.size];
    
    objc_setAssociatedObject(self, propertyAttribs.key, data, OBJC_ASSOCIATION_RETAIN);
}


@end



id EMKDynamicObjectGetter(id self, SEL _cmd)
{
    return [self EMK_getValueForObjectProperty:EMK_propertyNameFromGetter(_cmd)];
}



void EMKDynamicObjectSetter(id self, SEL _cmd, id value)
{
    [self EMK_setValue:value forObjectProperty:EMK_propertyNameFromSetter(_cmd)];
}



const void *EMKDynamicScalarGetter(id self, SEL _cmd)
{
    return [self EMK_getValueForScalarProperty:EMK_propertyNameFromGetter(_cmd)];
}



void EMKDynamicScalarSetter(id self, SEL _cmd, void *value)
{
    [self EMK_setValue:value forScalarProperty:EMK_propertyNameFromSetter(_cmd)];
}


