//
//  EMKTableViewCell.m
//  EMKPantry
//
//  Created by Benedict Cohen on 30/12/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "EMKTableViewCell.h"

#import <objc/runtime.h>
#import "NSObject(EMKAccessors).h"



id EMKTableViewCellDynamicGetter(id self, SEL _cmd);
void EMKTableViewCellDynamicSetter(id self, SEL _cmd, id value);

const char *EMKTableViewCellDynamicPropertiesKey = "EMKTableViewCellDynamicPropertiesKey";


#pragma mark -
#pragma mark EMKTableViewCell
@implementation EMKTableViewCell


#pragma mark class methods
+(BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if (EMK_selectorIsGetter(aSEL))
    {
        class_addMethod(self, aSEL, (IMP)EMKTableViewCellDynamicGetter, "@@:");
        return YES;
    }
    
    
    if (EMK_selectorIsSetter(aSEL))
    {
        class_addMethod(self, aSEL, (IMP)EMKTableViewCellDynamicSetter, "v@:@");    
        return YES;
    }
    
    return [super resolveInstanceMethod:aSEL];
}



#pragma mark instance methods
-(void)setValue:(id)value forKey:(NSString *)key
{
    NSMutableDictionary *dynamicProperties = objc_getAssociatedObject(self, EMKTableViewCellDynamicPropertiesKey);
    if (dynamicProperties == nil)
    {
        dynamicProperties = [NSMutableDictionary dictionaryWithCapacity:5]; //5 is a guess of how many subviews an average composite view will have
        objc_setAssociatedObject(self, EMKTableViewCellDynamicPropertiesKey, dynamicProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    
    [dynamicProperties setObject:value forKey:key];
}



-(id)valueForKey:(NSString *)key
{
    NSMutableDictionary *dynamicProperties = objc_getAssociatedObject(self, EMKTableViewCellDynamicPropertiesKey);    
    if (dynamicProperties == nil)
    {
        dynamicProperties = [NSMutableDictionary dictionaryWithCapacity:5]; //5 is a guess of how many subviews an average composite view will have
        objc_setAssociatedObject(self, EMKTableViewCellDynamicPropertiesKey, dynamicProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    
    return [dynamicProperties valueForKey:key];
}



@end



#pragma mark -
#pragma mark runtime methods


id EMKTableViewCellDynamicGetter(id self, SEL _cmd)
{
    return [self valueForKey:EMK_propertyNameFromGetter(_cmd)];    
}




void EMKTableViewCellDynamicSetter(id self, SEL _cmd, id value)
{
    NSString *propertyName = EMK_propertyNameFromSetter(_cmd);
    
    if (propertyName) [self setValue:value forKey:propertyName];
}

