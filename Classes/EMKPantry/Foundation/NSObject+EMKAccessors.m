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
    
    BOOL isValidLength = methodNameLength > 4; //4 = strlen("set:");
    BOOL isPrefixCorrect = [methodName rangeOfString:@"set"].location == 0;
    BOOL isSuffixCorrect = [methodName rangeOfString:@":"].location == methodNameLength-1;

    return (isValidLength && isPrefixCorrect && isSuffixCorrect);
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
        
        if (setterStringLength < 5) return nil;
        
        NSString *propertyNameHead = [setterString substringWithRange:(NSRange){.location = 3, .length = 1}]; //4 = strlen("set:")
        NSString *propertyNameTail = [setterString substringWithRange:(NSRange){.location = 4, .length = setterStringLength - 5}]; //4 = strlen("set:")
        
        return [NSString stringWithFormat:@"%@%@", [propertyNameHead  lowercaseString], propertyNameTail];
    }
    
    return nil;
}




SEL EMK_getterSelectorForPropertyName(NSString *propertyName)
{
    return NSSelectorFromString(propertyName);
}




SEL EMK_setterSelectorForPropertyName(NSString *propertyName)
{
    if ([propertyName length] < 1) return NULL;
    
    NSString *firstLetter = [propertyName substringToIndex:1];
    NSString *tail = [propertyName substringFromIndex:1];

    return NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [firstLetter uppercaseString], tail]);
}
