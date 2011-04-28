//
//  EMKMutableTypedArray.h
//  EMKPantry
//
//  Created by Benedict Cohen on 23/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMKTypedArray.h"

@interface EMKMutableTypedArray : EMKTypedArray
{
}

+(id)typedArrayWithTypeSizeof:(NSUInteger)size defaultValue:(const void *)defaultValue;
+(id)typedArrayWithTypeSizeof:(NSUInteger)size bytes:(const void *)bytes count:(NSUInteger)count defaultValue:(const void *)defaultValue;
+(id)typedArrayWithTypedArray:(EMKTypedArray *)typedArray defaultValue:(const void *)defaultValue;

-(id)initWithTypeSizeof:(NSUInteger)size defaultValue:(const void *)defaultValue;
-(id)initWithTypeSizeof:(NSUInteger)size bytes:(const void *)bytes count:(NSUInteger)count defaultValue:(const void *)defaultValue; //designated initializer
-(id)initWithTypedArray:(EMKTypedArray *)typedArray defaultValue:(const void *)defaultValue;

-(void)getDefaultValue:(void *)buffer;
-(const void *)defaultValue;

-(void)setValue:(const void *)buffer atIndex:(NSUInteger)index;
-(void)addValue:(const void *)buffer;

-(void)trimToLength:(NSUInteger)aIndex;

@end



@interface EMKTypedArray (NSMutableCopying) <NSMutableCopying>
@end

