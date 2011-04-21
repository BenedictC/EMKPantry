//
//  EMKIndexedTypedArray.h
//  EMKPantry
//
//  Created by Benedict Cohen on 18/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMKTypedArray.h"

@interface EMKIndexedTypedArray : EMKTypedArray 
{
}

-(NSUInteger)firstIndex;
-(NSUInteger)lastIndex;

-(NSIndexSet *)indexes;


-(void)unsetValueAtIndex:(NSUInteger)index;
-(void)getValue:(void *)buffer atIndex:(NSUInteger)index nextIndex:(NSUInteger *)nextIndex;
-(void)getValue:(void *)buffer atIndex:(NSUInteger)index previousIndex:(NSUInteger *)previousIndex;

//EMKIndexedScalarArray *indexFloatArray = nil;
//uint index = [indexFloatArray lowestIndex];
//while (index != NSNotFound)
//{
//    float value = 0;
//    [indexFloatArray getValue:&value atIndex:index nextIndex:&index];
//    //do something with value
//}





@end
