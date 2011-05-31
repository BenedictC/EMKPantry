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



BOOL EMK_selectorIsGetter(SEL getter)
{
    const char *methodName = (const char *)getter;
    
    int i = 0;
    while (methodName[i] != '\0')
    {
        switch(i)
        {
        case 0:
            if (('A'-1 < methodName[0] && methodName[0] < '^')) return NO;
            break;
                
        default:
            if (methodName[i] == ':') return NO;
            break;
        }
        
        i++;
    }
    
    return YES;
}

    



BOOL EMK_selectorIsSetter(SEL setter)
{
    const char *methodName = (const char *)setter;    

    int i = 0;
    while (methodName[i] != '\0')
    {
        switch (i)
        {
        case 0:        
            if (methodName[0] != 's') return NO;
            break;

        case 1:                        
            if (methodName[1] != 'e') return NO;        
            break;
                
        case 2:                        
            if (methodName[2] != 't') return NO;        
            break;        
                
        case 3:                        
            if (!('A'-1 < methodName[3] && methodName[3] < 'a')) return NO;
            break;
                
        default:
            if (methodName[i] == ':' && methodName[i+1] != '\0') return NO;
            break;
        }
        
        i++;
    }
    
    return (i>4 && methodName[i-1] == ':');
}



NSString *EMK_propertyNameFromGetter(SEL getter)
{
    return (EMK_selectorIsGetter(getter)) ? NSStringFromSelector(getter) : nil;
}



NSString *EMK_propertyNameFromSetter(SEL setter)
{
    if (EMK_selectorIsSetter(setter))
    {
        char *setterString = strdup((const char *)setter);
        
        BOOL isUpperCase = (setterString[3] > 'A'-1) && (setterString[3] < 'Z'+1);
        setterString[3] = (isUpperCase) ? setterString[3] + ('a' - 'A') : setterString[3];
        int i = 4;
        while(TRUE)
        {
            if (setterString[i+1] == '\0')
            {
                setterString[i] = '\0';
                break;
            }
            i++;
        }
        
        NSString *result = [NSString stringWithCString:&(setterString[3]) encoding:NSUTF8StringEncoding];
        free(setterString);
        
        return result;
    }
    
    return nil;
}




SEL EMK_getterSelectorForPropertyName(NSString *propertyName)
{
    SEL result = NSSelectorFromString(propertyName);
    return (EMK_selectorIsGetter(result)) ? result : NULL;
}




SEL EMK_setterSelectorForPropertyName(NSString *propertyName)
{
    if ([propertyName length] < 1) return NULL;
    
    NSString *firstLetter = [propertyName substringToIndex:1];
    NSString *tail = [propertyName substringFromIndex:1];

    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [firstLetter uppercaseString], tail]);
    
    return (EMK_selectorIsSetter(setter)) ? setter : NULL;
}
