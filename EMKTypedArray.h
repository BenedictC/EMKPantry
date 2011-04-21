//
//  EMKTypedArray.h
//  EMKPantry
//
//  Created by Benedict Cohen on 15/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: rename to EMKTypedArray?
@interface EMKTypedArray : NSObject 
{
    
}
+(id)typedArrayWithTypeSizeof:(NSUInteger)size;
+(id)typedArrayWithTypeSizeof:(NSUInteger)size defaultValue:(void *)defaultValue;

-(id)initWithTypeSizeof:(NSUInteger)size;
//designated initializer
-(id)initWithTypeSizeof:(NSUInteger)size defaultValue:(void *)defaultValue;

-(void)getValue:(void *)buffer atIndex:(NSUInteger)index;
-(void)setValue:(const void *)buffer atIndex:(NSUInteger)index;
-(void)addValue:(const void *)buffer;

-(NSUInteger)lastIndex;
-(void)cropLastIndexTo:(NSUInteger)aIndex;

@property(readonly, nonatomic) NSUInteger typeSize;
-(void)getDefaultValue:(void *)buffer;
-(const void *)defaultValue;
@end
