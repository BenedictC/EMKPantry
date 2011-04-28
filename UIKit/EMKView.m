//
//  EMKView.m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "EMKView.h"
#import <objc/runtime.h>
#import "NSObject(EMKAccessors).h"



#pragma mark -
#pragma mark EMKCompositeView

@implementation EMKView

#pragma mark class methods
+(BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if (EMK_selectorIsGetter(aSEL))
    {
        class_addMethod([self class], aSEL, (IMP)EMKViewDynamicGetter, "@@:");
        return YES;
    }
    
    
    if (EMK_selectorIsSetter(aSEL))
    {
        class_addMethod([self class], aSEL, (IMP)EMKViewDynamicSetter, "v@:@");    
        return YES;
    }
    
    return [super resolveInstanceMethod:aSEL];
}


#pragma mark memory management
-(void)dealloc
{
    [_dynamicProperties release];
    [super dealloc];
}





#pragma mark instance methods
-(void)setValue:(id)value forKey:(NSString *)key
{
    if (!_dynamicProperties) _dynamicProperties = [[NSMutableDictionary dictionaryWithCapacity:5] retain]; //5 is a guess of how many subviews an average composite view will have
    
    [_dynamicProperties setObject:value forKey:key];
}


-(id)valueForKey:(NSString *)key
{
    if (!_dynamicProperties) _dynamicProperties = [[NSMutableDictionary dictionaryWithCapacity:5] retain]; //5 is a guess of how many subviews an average composite view will have
    
    return [_dynamicProperties valueForKey:key];
}



@end










#pragma mark -
#pragma mark runtime methods


id EMKViewDynamicGetter(id self, SEL _cmd)
{
    return [self valueForKey:EMK_propertyNameFromGetter(_cmd)];    
}




void EMKViewDynamicSetter(id self, SEL _cmd, id value)
{
    NSString *propertyName = EMK_propertyNameFromSetter(_cmd);
    
    if (propertyName) [self setValue:value forKey:propertyName];
}

