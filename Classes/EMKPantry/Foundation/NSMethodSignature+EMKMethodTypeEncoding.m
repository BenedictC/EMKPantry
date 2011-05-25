//
//  NSMethodSignature+EMKMethodTypeEncoding.m
//  EMKPantry
//
//  Created by Benedict Cohen on 20/03/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "NSMethodSignature+EMKMethodTypeEncoding.h"



const char *EMK_NSMethodSignature_typesForMethodWithReturnType(const char *returnType, const char *firstArgumentType, va_list arguments);



@implementation NSMethodSignature (EMKMethodTypeEncoding)

+(const char *)EMK_typesForMethodWithReturnType:(const char *)returnType argumentTypes:(const char *)firstArgumentType, ...
{
    va_list arguments;
    va_start(arguments, firstArgumentType);

    const char *result = EMK_NSMethodSignature_typesForMethodWithReturnType(returnType, firstArgumentType, arguments);

    va_end(arguments);    
    
    return result;
}



+(NSMethodSignature *)EMK_signatureForMethodWithReturnType:(const char *)returnType argumentTypes:(const char *)firstArgumentType, ...
{
    va_list arguments;
    va_start(arguments, firstArgumentType);
    const char *types = EMK_NSMethodSignature_typesForMethodWithReturnType(returnType, firstArgumentType, arguments);
    va_end(arguments);    
    
    return [NSMethodSignature signatureWithObjCTypes:types];
}

@end




const char *EMK_NSMethodSignature_typesForMethodWithReturnType(const char *returnType, const char *firstArgumentType, va_list arguments)
{
    NSString *compulsoryTypes =  [NSString stringWithFormat: @"%s%s%s", returnType, //return type
                                  @encode(id), //implicit method arg
                                  @encode(SEL)]; //implicit method arg
    
    NSString *types = compulsoryTypes;    
    const char *argumentType = firstArgumentType;
    
    while (argumentType != NULL)
    {
        //add type to types
        types = [types stringByAppendingFormat:@"%s", argumentType];
        
        //fetch next type
        argumentType = va_arg(arguments, const char *);
    }
    
    NSLog(@"%@", types);
    return [types UTF8String];
}