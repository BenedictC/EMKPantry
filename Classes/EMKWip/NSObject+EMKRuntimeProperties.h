//
//  NSObject+EMKRuntimeProperties.h
//  Jot
//
//  Created by Benedict Cohen on 30/05/2011.
//  Copyright 2011 Electric Muffin Kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (EMKRuntimeProperties)


//Adding runtime properties
+(void)EMK_addObjectProperty:(NSString *)propertyName policy:(objc_AssociationPolicy)policy;
+(void)EMK_addScalarProperty:(NSString *)propertyName size:(NSUInteger)size defaultValue:(void *)defaultValue;


//accessing runtime properties
-(id)EMK_getValueForObjectProperty:(NSString *)propertyName;
-(void)EMK_setValue:(id)value forObjectProperty:(NSString *)propertyName;
-(const void *)EMK_getValueForScalarProperty:(NSString *)propertyName;
-(void)EMK_setValue:(void *)value forScalarProperty:(NSString *)propertyName;

@end
