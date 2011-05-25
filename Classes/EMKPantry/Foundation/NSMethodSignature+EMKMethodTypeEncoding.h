//
//  NSMethodSignature(EMKMethodTypeEncoding).h
//  EMKPantry
//
//  Created by Benedict Cohen on 20/03/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMethodSignature (EMKMethodTypeEncoding)

+(const char *)EMK_typesForMethodWithReturnType:(const char *)returnType argumentTypes:(const char *)firstArgumentType, ...;
+(NSMethodSignature *)EMK_signatureForMethodWithReturnType:(const char *)returnType argumentTypes:(const char *)firstArgumentType, ...;

@end
