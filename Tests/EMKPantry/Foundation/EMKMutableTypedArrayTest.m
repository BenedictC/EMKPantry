//
//  EMKMutableTypedArrayTest.m
//  EMKPantry
//
//  Created by Benedict Cohen on 24/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKMutableTypedArrayTest.h"


@implementation EMKMutableTypedArrayTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application
- (void)testAppDelegate 
{
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}



#else


/*
 
 TODO
 ====
 
 - Mutable copy
 - Thread safety
 
 */



@dynamic array;
@synthesize defaultValue = defaultValue_;

-(void)setUp
{
    [super setUp];
    self.defaultValue = malloc(self.size);    
    *(float *)self.defaultValue = 67;
    
    self.array = [[[EMKMutableTypedArray alloc] initWithTypeSizeof:self.size  bytes:self.data count:self.dataCount defaultValue:self.defaultValue] autorelease];
}



-(void)tearDown
{
    free(self.defaultValue);    
    self.array = nil;
    [super tearDown];
}



-(void)testInits
{
    EMKMutableTypedArray *array3 = [[EMKMutableTypedArray alloc] initWithTypeSizeof:self.size  defaultValue:self.defaultValue];
    STAssertNotNil(array3, @"initWithTypeSizeof: failed");
    STAssertTrue([array3 typeSize] == self.size, @"scalarSize incorrect");
    float fetchedDefaultValue = 0;
    [array3 getDefaultValue:&fetchedDefaultValue];
    STAssertTrue(*(float *)self.defaultValue == fetchedDefaultValue, @"defaultValue incorrect");    
    [array3 release];
    
    EMKMutableTypedArray *array2 = [[EMKMutableTypedArray alloc] initWithTypeSizeof:self.size];
    STAssertNotNil(array2, @"initWithTypeSizeof: failed");
    STAssertTrue([array2 typeSize] == self.size, @"scalarSize incorrect");
    [array2 release];
    

//    EMKMutableTypedArray *array2 = [[EMKMutableTypedArray alloc] initWithTypedArray:<#(EMKTypedArray *)#> defaultValue:<#(const void *)#>
//    STAssertNotNil(array2, @"initWithTypeSizeof: failed");
//    STAssertTrue([array2 typeSize] == self.size, @"scalarSize incorrect");
//    [array2 release];
//
//-(id)initWithTypedArray:(EMKTypedArray *)typedArray defaultValue:(const void *)defaultValue    
    
    //TODO: test with size 0
}



-(void)testClassConvieninceInits
{
    EMKMutableTypedArray *array3 = [EMKMutableTypedArray typedArrayWithTypeSizeof:self.size  defaultValue:self.defaultValue];
    STAssertNotNil(array3, @"initWithTypeSizeof: failed");
    STAssertTrue([array3 typeSize] == self.size, @"scalarSize incorrect");
    float fetchedDefaultValue = 0;
    [array3 getDefaultValue:&fetchedDefaultValue];
    STAssertTrue(*(float *)self.defaultValue == fetchedDefaultValue, @"defaultValue incorrect");    
    
    EMKMutableTypedArray *array2 = [EMKMutableTypedArray typedArrayWithTypeSizeof:self.size];
    STAssertNotNil(array2, @"initWithTypeSizeof: failed");
    STAssertTrue([array2 typeSize] == self.size, @"scalarSize incorrect");
    
    float defaultValue = 765;
    EMKMutableTypedArray *array1 = [EMKMutableTypedArray typedArrayWithTypedArray:self.array defaultValue:&defaultValue];
    STAssertNotNil(array1, @"initWithTypeSizeof: failed");
    STAssertTrue([array1 typeSize] == self.size, @"scalarSize incorrect");

    float value = 0;
    [self.array getValue:&value atIndex:0];
    float startValue = value;    
    value++;
    [array1 setValue:&value atIndex:0];
    STAssertTrue(value != startValue, @"scalarSize incorrect");    
    
    float reValue = 0;
    [self.array getValue:&reValue atIndex:0];
    STAssertTrue(reValue == startValue, @"scalarSize incorrect");        
    
    
    
}



-(void)testSetThenGetAtLowerBound
{
    float value = 1234.5678;
    uint index = 0;
    
    STAssertNoThrow([self.array setValue:&value atIndex:index], @"failed to set value at lowerBound");
    
    float buffer = 0;
    STAssertNoThrowSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to get value at lowerBound");
    STAssertTrue(buffer == value, @"set then test failed at lower bound");
}



-(void)testSetThenGetBenethLowerBound
{
    float value = 1234.5678;
    
    int index = -1;
    STAssertThrows([self.array setValue:&value atIndex:index], @"failed to set value at lowerBound");
    
    float buffer = 0;
    STAssertThrowsSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to get value at lowerBound");
}



-(void)testSetThenGetInBounds
{
    float value = 1234.5678;
    
    uint index = 10000;
    STAssertNoThrow([self.array setValue:&value atIndex:index], @"failed to set value at lowerBound");
    
    float buffer = 0;
    STAssertNoThrowSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to get value at lowerBound");
    STAssertTrue(buffer == value, @"set then test failed at lower bound");
}


////This test causes the memory to run out on my 4GB system!
//-(void)testSetThenGetAtUpperBound
//{
//    NSUInteger size = sizeof(float);
//    float defaultValue = 67;    
//    float value = 1234.5678;
//    EMKScalarArray *array = [EMKScalarArray typedArrayWithTypeSizeof:size  defaultValue:&defaultValue];
//    
//    uint index = NSIntegerMax - 1;
//    STAssertNoThrow([self.array setValue:&value atIndex:index], @"failed to set value at lowerBound");
//    
//    float buffer = 0;
//    STAssertNoThrowSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to get value at lowerBound");
//    STAssertTrue(buffer == value, @"set then test failed at lower bound");
//}



-(void)testSetThenGetAboveUpperBound
{
    float value = 1234.5678;
    
    int index = NSIntegerMax;
    STAssertThrows([self.array setValue:&value atIndex:index], @"failed to fail to set value at NSIntegerMax");
    
    float buffer = 0;
    STAssertThrowsSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to fail to get value at NSIntegerMax");
}



-(void)testSetThenGetAtNSNotFound
{
    float value = 1234.5678;
    
    int index = NSNotFound;
    STAssertThrows([self.array setValue:&value atIndex:index], @"failed to fail to set value at NSNotFound");
    
    float buffer = 0;
    STAssertThrowsSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to fail to get value at NSNotFound");
}



-(void)testAddThenGet
{
    float value = 1234.5678;
    
    NSUInteger expectedCount = [self.array count];
    STAssertNoThrow([self.array addValue:&value], @"failed to set value at beneth upper bound");
    expectedCount++;
    STAssertNoThrow([self.array addValue:&value], @"failed to set value at beneth upper bound");
    expectedCount++;    
    STAssertNoThrow([self.array addValue:&value], @"failed to set value at beneth upper bound");
    expectedCount++;    
    STAssertNoThrow([self.array addValue:&value], @"failed to set value at beneth upper bound");    
    expectedCount++;    
    
    float buffer = 0;
    STAssertNoThrowSpecific([self.array getValue:&buffer atIndex:[self.array count]-1], NSException, NSRangeException, @"failed to get value at upperBound");
    STAssertTrue([self.array count] ==  expectedCount, @"incorrect lastIndex");        
}



////This test causes the memory to run out on my 4GB system!
//-(void)testAddThenGetUpToUpperBound
//{
//    NSUInteger size = sizeof(float);
//    float defaultValue = 67;    
//    float value = 1234.5678;
//    EMKScalarArray *array = [EMKScalarArray typedArrayWithTypeSizeof:size  defaultValue:&defaultValue];
//    
//    uint i = 0;
//    while (i < NSIntegerMax)
//    {
//        STAssertNoThrow([self.array addValue:&value], @"failed to set value at beneth upper bound");
//        i++;
//    }
//    
//    float buffer = 0;
//    STAssertNoThrowSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to get value at lowerBound");
//    STAssertTrue(buffer == value, @"set then test failed at lower bound");    
//}



////This test causes the memory to run out on my 4GB system!
//-(void)testAddThenGetPastUpperBound
//{
//    NSUInteger size = sizeof(float);
//    float defaultValue = 67;    
//    float value = 1234.5678;
//    EMKScalarArray *array = [EMKScalarArray typedArrayWithTypeSizeof:size  defaultValue:&defaultValue];
//    
//    uint i = 0;
//    while (i < NSUIntegerMax)
//    {
//        if (i >= NSIntegerMax)
//        {
//            STAssertThrows([self.array setValue:&value atIndex:i], @"failed to fail to set value at i => NSIntegerMax");
//            break;
//        }
//        else
//        {
//            STAssertNoThrow([self.array addValue:&value], @"failed to set value at beneth upper bound");            
//        }
//
//        i++;
//    }
//    
//    float buffer = 0;
//    STAssertNoThrowSpecific([self.array getValue:&buffer atIndex:i], NSException, NSRangeException, @"failed to get value at lowerBound");
//    STAssertTrue(buffer == value, @"set then test failed at lower bound");        
//}



-(void)testNonsetValidIndexHasDefaultValue
{
    float value = 0;
    
    uint startCount = [self.array count];
    
    [self.array setValue:&value atIndex:startCount + 10];    
    [self.array getValue:&value atIndex:startCount +  9];
    STAssertTrue(value == *(float *)self.defaultValue, @"default not correct");
}



-(void)testCropLastIndexWithinIndexRange
{
    float value = 1234.5678;
    
    uint length = 4;
    [self.array setValue:&value atIndex:6];
    [self.array trimToLength:length];
    STAssertTrue([self.array count] == length, @"lastIndex not correct");
    
}



-(void)testCropLastIndexOnEmptyArray
{
    uint length = 5;
    
    EMKMutableTypedArray *array = [EMKMutableTypedArray typedArrayWithTypeSizeof:self.size defaultValue:self.defaultValue];
    
    [array trimToLength:length];
    STAssertTrue(0 == [array count], @"Failed to crop lastIndex of empty array");
}



-(void)testCropLastIndexBeyondIndexRange
{
    float value = 1234.5678;
    uint count1 = 50;
    uint count2 = 30;
    
    [self.array setValue:&value atIndex:count1];
    
    [self.array trimToLength:count2];
    STAssertTrue(count2 == [self.array count], @"Failed to crop count");
}




-(void)testCropLastIndexToZero
{
    float value = 1234.5678;
    uint index1 = 50;
    uint index2 = 0;
    
    [self.array setValue:&value atIndex:index1];
    
    [self.array trimToLength:index2];
    STAssertTrue(index2 == [self.array count], @"Failed to crop lastIndex to zero");
}



#endif

@end
