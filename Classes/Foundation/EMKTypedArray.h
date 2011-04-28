//
//  EMKTypedArray.h
//  EMKPantry
//
//  Created by Benedict Cohen on 15/04/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: rename to EMKTypedArray?
@interface EMKTypedArray : NSObject <NSCopying>
{
    
}
+(id)typedArrayWithTypeSizeof:(NSUInteger)size;
+(id)typedArrayWithTypeSizeof:(NSUInteger)size bytes:(const void *)bytes count:(NSUInteger)count;

-(id)initWithTypeSizeof:(NSUInteger)size;
-(id)initWithTypeSizeof:(NSUInteger)size bytes:(const void *)bytes count:(NSUInteger)count; //designated initializer


-(NSUInteger)typeSize;
-(NSUInteger)count;
-(void)getValue:(void *)buffer atIndex:(NSUInteger)index;
@end
