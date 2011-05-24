//
//  Test.m
//  EMKPantry
//
//  Created by Benedict Cohen on 20/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "EMKTypedArrayTest.h"
#import "EMKTypedArray.h"

@implementation EMKTypedArrayTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application
- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}



#else                           // all code under test must be linked into the Unit Test bundle


@synthesize array = array_;
@synthesize size = size_;
@synthesize data = data_;
@synthesize dataCount = dataCount_;

-(void)setUp
{
    self.size = sizeof(float);
    self.dataCount = 10;
    self.data = malloc(self.dataCount * self.size);
    for (uint i = 0; i < self.dataCount; i++)
    {
        self.data[i] = 1 / rand();
    }

    self.array = [[[EMKTypedArray alloc] initWithTypeSizeof:self.size bytes:self.data count:self.dataCount] autorelease];
}



-(void)tearDown
{
    self.array = nil;
    self.size = 0;
    self.dataCount = 0;
    free(self.data);
}



-(void)testInits
{
    EMKTypedArray *array3 = [[EMKTypedArray alloc] initWithTypeSizeof:self.size];
    STAssertNotNil(array3, @"initWithTypeSizeof: failed");
    STAssertTrue([array3 typeSize] == self.size, @"scalarSize incorrect");
    STAssertTrue([array3 count] == 0, @"empty array count incorrect");    
    [array3 release];
    
    
    float data[10] = {012, 123, 234, 345, 456, 567, 678, 789, 890, 901};    
    EMKTypedArray *array2 = [[EMKTypedArray alloc] initWithTypeSizeof:self.size bytes:&data count:10];
    STAssertNotNil(array2, @"initWithTypeSizeof:bytes:count: failed");
    STAssertTrue([array2 typeSize] == self.size, @"scalarSize incorrect");
    STAssertTrue([array2 count] == 10, @"empty array count incorrect");    
    [array2 release];
    
    EMKTypedArray *array1 = nil;
    STAssertThrowsSpecificNamed(array1 = [[EMKTypedArray alloc] initWithTypeSizeof:0 bytes:&data count:10],
                                NSException, NSInvalidArgumentException, @"failed to throw invalid argument exception for init with typeSize 0"); 
}



-(void)testClassConvieninceInits
{
    EMKTypedArray *array3 = [EMKTypedArray typedArrayWithTypeSizeof:self.size];
    STAssertNotNil(array3, @"initWithTypeSizeof: failed");
    STAssertTrue([array3 typeSize] == self.size, @"scalarSize incorrect");
    STAssertTrue([array3 count] == 0, @"empty array count incorrect");    
    
    
    float data[10] = {012, 123, 234, 345, 456, 567, 678, 789, 890, 901};    
    EMKTypedArray *array2 = [EMKTypedArray typedArrayWithTypeSizeof:self.size bytes:&data count:10];
    STAssertNotNil(array2, @"initWithTypeSizeof:bytes:count: failed");
    STAssertTrue([array2 typeSize] == self.size, @"scalarSize incorrect");
    STAssertTrue([array2 count] == 10, @"empty array count incorrect");    
    
    //TODO: test with size 0    
}



-(void)testStateOfEmptyArray
{
    EMKTypedArray *emptyArray = [[[EMKTypedArray alloc] initWithTypeSizeof:sizeof(float)] autorelease];
    STAssertTrue([emptyArray count] == 0, @"incorrect lastIndex for empty array");
    float buffer = 0;
    STAssertThrowsSpecificNamed([emptyArray getValue:&buffer atIndex:0], NSException, NSRangeException, @"Array did not throw range exception for invalid getValue");
}



-(void)testGetAtLowerBound
{
    NSUInteger index = 0;
    float buffer = 0;
    float valueFromData = self.data[index];
    
    STAssertNoThrowSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to get value at index 0");
    STAssertTrue(buffer == valueFromData, @"get failed at index 0");
}



-(void)testGetBenethLowerBound
{
    int index = -1;
    float buffer = 0;
    
    STAssertThrowsSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to get value at lowerBound");
}



-(void)testGetInBounds
{
    uint index = 5;
    float buffer = 0;
    float valueFromData = self.data[index];    
    
    STAssertNoThrowSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to get value at lowerBound");
    STAssertTrue(buffer == valueFromData, @"set then test failed at valid index");
}



-(void)testGetAboveUpperBound
{
    int index = 20;
    float buffer = 0;
    
    STAssertThrowsSpecific([self.array getValue:&buffer atIndex:index], NSException, NSRangeException, @"failed to get value at lowerBound");
}



-(void)testCopying
{
    EMKTypedArray *dolly = [self.array copy];
    
    Class mutableClass = NSClassFromString(@"EMKMutableTypedArray");
    
    STAssertTrue(![dolly isKindOfClass:mutableClass], @"immutable copy is mutable");        
    STAssertEquals(dolly.count, self.array.count, @"copy has count incorrect");
    STAssertEquals(dolly.typeSize, self.array.typeSize, @"copy has typeSize incorrect");    

    float aBuffer = 0;    
    float dBuffer = 0;
    for (uint i = 0; i < dolly.count; i++) 
    {
        [self.array getValue:&aBuffer atIndex:i];        
        [dolly getValue:&dBuffer atIndex:i];
        STAssertEquals(aBuffer, dBuffer, @"values at index %i do not match", i);            
    }
}


-(void)testMutableCopying
{
    Class mutableClass = NSClassFromString(@"EMKMutableTypedArray");
    if (mutableClass == nil) return;

    
    EMKTypedArray *dolly = [self.array mutableCopy];

    STAssertTrue([dolly isKindOfClass:mutableClass], @"mutable copy is not mutable");    
    
    STAssertEquals(dolly.count, self.array.count, @"copy has count incorrect");
    STAssertEquals(dolly.typeSize, self.array.typeSize, @"copy has typeSize incorrect");    
    
    float aBuffer = 0;    
    float dBuffer = 0;
    for (uint i = 0; i < dolly.count; i++) 
    {
        [self.array getValue:&aBuffer atIndex:i];        
        [dolly getValue:&dBuffer atIndex:i];
        STAssertEquals(aBuffer, dBuffer, @"values at index %i do not match", i);            
    }    
}
     

#endif

@end
