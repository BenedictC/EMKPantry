//
//  NSObject+EMKAccessorsTest.m
//  EMKPantry
//
//  Created by Benedict Cohen on 30/05/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "NSObject+EMKAccessorsTest.h"

#import "NSObject+EMKAccessors.h"

@implementation NSObject_EMKAccessorsTest
-(void)setUp
{
}


-(void)tearDown
{
}




-(void)testEMK_selectorIsGetter
{
    SEL validGetter = @selector(arf);
    STAssertTrue(EMK_selectorIsGetter(validGetter), @"%s is a valid getter", validGetter);
    validGetter = @selector(arfArf);
    STAssertTrue(EMK_selectorIsGetter(validGetter), @"%s is a valid getter", validGetter);
    validGetter = @selector(arf_arf);
    STAssertTrue(EMK_selectorIsGetter(validGetter), @"%s is a valid getter", validGetter);
    validGetter = @selector(arf_arfArf);
    STAssertTrue(EMK_selectorIsGetter(validGetter), @"%s is a valid getter", validGetter);
    validGetter = @selector(_arfArf);
    STAssertTrue(EMK_selectorIsGetter(validGetter), @"%s is a valid getter", validGetter);

    
    SEL invalidGetter = @selector(Arf);
    STAssertTrue(!EMK_selectorIsGetter(invalidGetter), @"%s is a invalid getter", validGetter);
    invalidGetter = @selector(EMK_arf);
    STAssertTrue(!EMK_selectorIsGetter(invalidGetter), @"%s is a invalid getter", validGetter);
//    invalidGetter = @selector(_arf);
//    STAssertTrue(!EMK_selectorIsGetter(invalidGetter), @"%s is a invalid getter", validGetter);
    invalidGetter = @selector(arf:);
    STAssertTrue(!EMK_selectorIsGetter(invalidGetter), @"%s is a invalid getter", validGetter);
}



-(void)testEMK_selectorIsSetter
{
    SEL validSetter = @selector(setA:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"a"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(setAr:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"ar"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(setAA:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"aA"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(setArf_arf:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"arf_arf"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(setArf_arfArf:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"arf_arfArf"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(set_arfArf:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"_arfArf"], @"%s propertyName extraction failed", validSetter);
    
    
    
    SEL invalidSetter = @selector(setarf);
    STAssertTrue(!EMK_selectorIsSetter(invalidSetter), @"%s is an invalid setter", invalidSetter);
    invalidSetter = @selector(setArf);
    STAssertTrue(!EMK_selectorIsSetter(invalidSetter), @"%s is an invalid setter", invalidSetter);
    invalidSetter = @selector(setarf:);
    STAssertTrue(!EMK_selectorIsSetter(invalidSetter), @"%s is an invalid setter", invalidSetter);
    invalidSetter = @selector(arf:);
    STAssertTrue(!EMK_selectorIsSetter(invalidSetter), @"%s is an invalid setter", invalidSetter);
    invalidSetter = @selector(SetArf:);
    STAssertTrue(!EMK_selectorIsSetter(invalidSetter), @"%s is an invalid setter", invalidSetter);
    invalidSetter = @selector(Setarf:);
    STAssertTrue(!EMK_selectorIsSetter(invalidSetter), @"%s is an invalid setter", invalidSetter);
    invalidSetter = @selector(setArf:arf:);
    STAssertTrue(!EMK_selectorIsSetter(invalidSetter), @"%s is an invalid setter", invalidSetter);
    
}



-(void)testEMK_propertyNameFromGetter
{
    SEL validGetter = @selector(arf);
    STAssertTrue([EMK_propertyNameFromGetter(validGetter) isEqualToString:@"arf"], @"%s propertyName extraction failed", validGetter);
    validGetter = @selector(arfArf);
    STAssertTrue([EMK_propertyNameFromGetter(validGetter) isEqualToString:@"arfArf"], @"%s propertyName extraction failed", validGetter);
    validGetter = @selector(arf_arf);
    STAssertTrue([EMK_propertyNameFromGetter(validGetter) isEqualToString:@"arf_arf"], @"%s propertyName extraction failed", validGetter);
    validGetter = @selector(arf_arfArf);
    STAssertTrue([EMK_propertyNameFromGetter(validGetter) isEqualToString:@"arf_arfArf"], @"%s propertyName extraction failed", validGetter);
    validGetter = @selector(_arfArf);
    STAssertTrue([EMK_propertyNameFromGetter(validGetter) isEqualToString:@"_arfArf"], @"%s propertyName extraction failed", validGetter);
    
    
    SEL invalidGetter = @selector(Arf);
    STAssertTrue(EMK_propertyNameFromGetter(invalidGetter) == nil, @"%s propertyName extraction failed", invalidGetter);
    invalidGetter = @selector(EMK_arf);
    STAssertTrue(EMK_propertyNameFromGetter(invalidGetter) == nil, @"%s propertyName extraction failed", invalidGetter);
//    invalidGetter = @selector(_arf);
//    STAssertTrue(EMK_propertyNameFromGetter(invalidGetter) == nil, @"%s propertyName extraction failed", invalidGetter);
    invalidGetter = @selector(arf:);
    STAssertTrue(EMK_propertyNameFromGetter(invalidGetter) == nil, @"%s propertyName extraction failed", invalidGetter);
}




-(void)testEMK_propertyNameFromSetter
{
    SEL validSetter = @selector(setA:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"a"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(setAr:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"ar"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(setAA:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"aA"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(setArf_arf:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"arf_arf"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(setArf_arfArf:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"arf_arfArf"], @"%s propertyName extraction failed", validSetter);
    validSetter = @selector(set_arfArf:);
    STAssertTrue([EMK_propertyNameFromSetter(validSetter) isEqualToString:@"_arfArf"], @"%s propertyName extraction failed", validSetter);
    
    
    SEL invalidSetter = @selector(setarf);
    STAssertTrue(EMK_propertyNameFromSetter(invalidSetter) == nil, @"%s propertyName extraction failed", invalidSetter);
    invalidSetter = @selector(setArf);
    STAssertTrue(EMK_propertyNameFromSetter(invalidSetter) == nil, @"%s propertyName extraction failed", invalidSetter);
    invalidSetter = @selector(setarf:);
    STAssertTrue(EMK_propertyNameFromSetter(invalidSetter) == nil, @"%s propertyName extraction failed", invalidSetter);
    invalidSetter = @selector(arf:);
    STAssertTrue(EMK_propertyNameFromSetter(invalidSetter) == nil, @"%s propertyName extraction failed", invalidSetter);
    invalidSetter = @selector(SetArf:);
    STAssertTrue(EMK_propertyNameFromSetter(invalidSetter) == nil, @"%s propertyName extraction failed", invalidSetter);
    invalidSetter = @selector(Setarf:);
    STAssertTrue(EMK_propertyNameFromSetter(invalidSetter) == nil, @"%s propertyName extraction failed", invalidSetter);
    invalidSetter = @selector(setArf:arf:);
    STAssertTrue(EMK_propertyNameFromSetter(invalidSetter) == nil, @"%s propertyName extraction failed", invalidSetter);
    
}





-(void)testEMK_getterSelectorForPropertyName
{
    NSString *propertyName = @"arf";
    STAssertTrue(@selector(arf) == EMK_getterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"a";
    STAssertTrue(@selector(a) == EMK_getterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"aR";
    STAssertTrue(@selector(aR) == EMK_getterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"a_RHW";
    STAssertTrue(@selector(a_RHW) == EMK_getterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");

    propertyName = @"Arf";
    STAssertTrue(@selector(Arf) != EMK_getterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"EMK_a";
    STAssertTrue(@selector(EMK_a) != EMK_getterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"arf:";
    STAssertTrue(@selector(arf:) != EMK_getterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
}



-(void)testEMK_setterSelectorForPropertyName
{
    NSString *propertyName = @"a";
    STAssertTrue(@selector(setA:) == EMK_setterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"ar";
    STAssertTrue(@selector(setAr:) == EMK_setterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"aR";
    STAssertTrue(@selector(setAR:) == EMK_setterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"a_RHW";
    STAssertTrue(@selector(setA_RHW:) == EMK_setterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    
   
    propertyName = @"Arf";
    STAssertTrue(@selector(Arf) != EMK_setterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"setArf:";
    STAssertTrue(@selector(setArf:) != EMK_setterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");
    propertyName = @"arf:";
    STAssertTrue(@selector(arf:) != EMK_setterSelectorForPropertyName(propertyName), @" EMK_getterSelectorForPropertyName");    
}



-(void)testEMK_hasGetterForProperty
{
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:[NSData data]] autorelease];
    
    STAssertTrue([parser EMK_hasGetterForProperty:@"delegate"], @"EMK_hasGetterForProperty failed");

    STAssertTrue(![parser EMK_hasGetterForProperty:@"Arfdelegate"], @"EMK_hasGetterForProperty failed");
    STAssertTrue(![parser EMK_hasGetterForProperty:@"setDelegate:"], @"EMK_hasGetterForProperty failed");
}



-(void)testEMK_hasSetterForProperty
{
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:[NSData data]] autorelease];
    
    STAssertTrue([parser EMK_hasSetterForProperty:@"delegate"], @"EMK_hasSetterForProperty failed");
    
    STAssertTrue(![parser EMK_hasSetterForProperty:@"Arfdelegate"], @"EMK_hasSetterForProperty failed");
    STAssertTrue(![parser EMK_hasSetterForProperty:@"setDelegate:"], @"EMK_hasSetterForProperty failed");
}



@end
