//
//  EMKMutableTypedArrayTest.h
//  EMKPantry
//
//  Created by Benedict Cohen on 24/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "EMKMutableTypedArray.h"
#import "EMKTypedArrayTest.h"
//#import "application_headers" as required


@interface EMKMutableTypedArrayTest : EMKTypedArrayTest
{
}

#if USE_APPLICATION_UNIT_TEST
- (void)testAppDelegate;       // simple test on application
#else

@property(readwrite, assign, nonatomic) void* defaultValue;
#endif

@end



@interface EMKMutableTypedArrayTest ()
@property(readwrite, retain, nonatomic) EMKMutableTypedArray* array;
@end