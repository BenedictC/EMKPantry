//
//  NSObject(EMKAccessors).h
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (EMKAccessors)


-(BOOL)EMK_hasGetterForProperty:(NSString *)propertyName;
-(BOOL)EMK_hasSetterForProperty:(NSString *)propertyName;


@end


BOOL EMK_selectorIsGetter(SEL selector);
BOOL EMK_selectorIsSetter(SEL selector);

NSString* EMK_propertyNameFromGetter(SEL getter);
NSString* EMK_propertyNameFromSetter(SEL setter);

SEL EMK_getterSelectorForPropertyName(NSString *propertyName);
SEL EMK_setterSelectorForPropertyName(NSString *propertyName);