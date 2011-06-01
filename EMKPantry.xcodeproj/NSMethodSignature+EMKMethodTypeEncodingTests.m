//
//  NSMethodSignature+EMKMethodTypeEncodingTests.m
//  EMKPantry
//
//  Created by Benedict Cohen on 31/05/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "NSMethodSignature+EMKMethodTypeEncodingTests.h"


@implementation NSMethodSignature_EMKMethodTypeEncodingTests

-(void)setUp
{
    
}


-(void)tearDown
{
    
}



-(void)testEMK_typesForMethodWithReturnType
{
    //'existing' and 'generated' needs to be compared indirectly using NSMethodSignature    
    //this is because 'existing' has interleaved frame offsets 
    SEL selector = @selector(respondsToSelector:);
    Method method = class_getInstanceMethod([NSObject class], selector);
    const char *existing = method_getTypeEncoding(method);
    const char *generated = [NSMethodSignature EMK_typesForMethodWithReturnType:@encode(BOOL) argumentTypes:@encode(SEL), NULL];
    NSMethodSignature *existingMS = [NSMethodSignature signatureWithObjCTypes:existing];
    NSMethodSignature *generatedMS = [NSMethodSignature signatureWithObjCTypes:generated];    
    STAssertTrue([existingMS isEqual:generatedMS], @"failed test EMK_typesForMethodWithReturnType");    

    
    
    selector = @selector(respondsToSelector:);
    method = class_getInstanceMethod([NSObject class], selector);
    existing = method_getTypeEncoding(method);
    generated = [NSMethodSignature EMK_typesForMethodWithReturnType:@encode(void) argumentTypes:@encode(SEL), NULL];
    existingMS = [NSMethodSignature signatureWithObjCTypes:existing];
    generatedMS = [NSMethodSignature signatureWithObjCTypes:generated];    
    STAssertTrue(![existingMS isEqual:generatedMS], @"failed test EMK_typesForMethodWithReturnType");    
    
    
    STAssertThrows([NSMethodSignature EMK_typesForMethodWithReturnType:NULL argumentTypes: NULL], @"Failed to throwInvalidArgument");
}



-(void)testEMK_signatureForMethodWithReturnType
{
    NSMethodSignature *sig = [NSMethodSignature EMK_signatureForMethodWithReturnType:@encode(BOOL) argumentTypes:@encode(SEL), NULL];

    NSMethodSignature *respondsSig = [NSObject instanceMethodSignatureForSelector:@selector(respondsToSelector:)];

    STAssertTrue([respondsSig isEqual:sig], @"failed test EMK_signatureForMethodWithReturnType");    
}

@end
