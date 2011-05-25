//
//  NSObject+EMKAccessors.m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "NSObject+EMKAccessors.h"


@implementation NSObject (EMKAccessors)


-(BOOL)EMK_hasGetterForProperty:(NSString *)propertyName
{
    SEL getterSelector = NSSelectorFromString(propertyName);
    
    return [self respondsToSelector:getterSelector];
}




-(BOOL)EMK_hasSetterForProperty:(NSString *)propertyName
{
    NSString *propertyNameHead = [[propertyName substringToIndex:1] uppercaseString];
    NSString *propertyNameTail = [propertyName substringFromIndex:1];
    
    SEL setterSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", propertyNameHead, propertyNameTail]);
    
    return [self respondsToSelector:setterSelector];
}


@end


BOOL EMK_selectorIsGetter(SEL selector)
{
    NSString *methodName = NSStringFromSelector(selector);
    
    return ([methodName rangeOfString:@":"].location == NSNotFound);
}

    



BOOL EMK_selectorIsSetter(SEL selector)
{
    NSString *methodName = NSStringFromSelector(selector);    
    int methodNameLength  = [methodName length];
    
    return (   methodNameLength > 4 //4 = strlen("set:")
            && [methodName rangeOfString:@":"].length == methodNameLength
            && [methodName rangeOfString:@"set"].location == 0);
}



NSString* EMK_propertyNameFromGetter(SEL getter)
{
    return (EMK_selectorIsGetter(getter)) ? NSStringFromSelector(getter) : nil;
}



NSString* EMK_propertyNameFromSetter(SEL setter)
{
    if (EMK_selectorIsSetter(setter))
    {
        NSString *setterString = NSStringFromSelector(setter);
        int setterStringLength = [setterString length];
        
        NSString *propertyNameHead = [[setterString substringWithRange:(NSRange){.location = 4, .length = 1}] lowercaseString]; //4 = strlen("set:")
        NSString *propertyNameTail = [[setterString substringWithRange:(NSRange){.location = 4, .length = setterStringLength - 4}] substringFromIndex:1]; //4 = strlen("set:")
        
        return [NSString stringWithFormat:@"%@%@", propertyNameHead, propertyNameTail];
    }
    
    return nil;
}




SEL EMK_getterSelectorForPropertyName(NSString *propertyName)
{
    return NSSelectorFromString(propertyName);
}




SEL EMK_setterSelectorForPropertyName(NSString *propertyName)
{
    return NSSelectorFromString([NSString stringWithFormat:@"set%@:", [propertyName capitalizedString]]);
}
