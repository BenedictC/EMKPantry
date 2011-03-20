//
//  NSMethodSignature(EMKMethodTypeEncoding).m
//  EMKPantry
//
//  Created by Benedict Cohen on 20/03/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "NSMethodSignature(EMKMethodTypeEncoding).h"


@implementation NSMethodSignature (EMKMethodTypeEncoding)


+(const char *)EMK_typesForMethodWithReturnType:(const char *)returnType argumentTypes:(const char *)firstArgumentTypes, ...
{
    NSString *compulsoryTypes =  [NSString stringWithFormat: @"%s%s%s", returnType, //return type
                                  @encode(id), //implicit method arg
                                  @encode(SEL)]; //implicit method arg
    
    NSString *types = compulsoryTypes;    
    const char *argumentType = firstArgumentTypes;    
    va_list arguments;
    va_start(arguments, firstArgumentTypes);    
    
    while (argumentType != NULL)
    {
        //add type to types
        types = [types stringByAppendingFormat:@"%s", argumentType];
        
        //fetch next type
        argumentType = va_arg(arguments, const char *);
    }
    
    va_end(arguments);
    
    return [types UTF8String];
}


@end
