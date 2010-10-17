//
//  EMKCompositeView.m
//  EMKPantry
//
//  Created by Benedict Cohen on 16/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import "EMKCompositeView.h"
#import <objc/runtime.h>
#import "NSObject(EMKAccessors).h"



id EMKCompositeViewDynamicGetter(id self, SEL _cmd);
void EMKCompositeViewDynamicSetter(id self, SEL _cmd, id value);


#pragma mark -
#pragma mark EMKCompositeView

@implementation EMKCompositeView

#pragma mark class methods
+(BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if (EMK_selectorIsGetter(aSEL))
    {
        class_addMethod([self class], aSEL, (IMP)EMKCompositeViewDynamicGetter, "@@:");
        return YES;
    }
    
    
    if (EMK_selectorIsSetter(aSEL))
    {
        class_addMethod([self class], aSEL, (IMP)EMKCompositeViewDynamicSetter, "v@:@");    
        return YES;
    }
    
    return [super resolveInstanceMethod:aSEL];
}


#pragma mark init, dealloc and memory management
-(void)dealloc
{
    [_subViews release];
    [super dealloc];
}



#pragma mark properties

@dynamic subViews;

-(NSMutableDictionary*)subViews
{
    @synchronized(self)
    {
        if (!_subViews) _subViews = [[NSMutableDictionary dictionaryWithCapacity:5] retain]; //5 is a guess of how many subviews an average composite view will have
    }
    
    return _subViews;
}




#pragma mark instance methods
-(void)setValue:(id)value forKey:(NSString *)key
{
    [self.subViews setObject:value forKey:key];
}


-(id)valueForKey:(NSString *)key
{
    return [self.subViews valueForKey:key];
}





@end





#pragma mark -
#pragma mark EMKCompositeCell


@implementation EMKCompositeCell


#pragma mark class methods
+(BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if (EMK_selectorIsGetter(aSEL))
    {
        class_addMethod([self class], aSEL, (IMP)EMKCompositeViewDynamicGetter, "@@:");
        return YES;
    }
    
    
    if (EMK_selectorIsSetter(aSEL))
    {
        class_addMethod([self class], aSEL, (IMP)EMKCompositeViewDynamicSetter, "v@:@");    
        return YES;
    }
    
    return [super resolveInstanceMethod:aSEL];
}



#pragma mark init, dealloc and memory management
-(void)dealloc
{
    [_subViews release];
    [super dealloc];
}



#pragma mark properties

@dynamic subViews;

-(NSMutableDictionary*)subViews
{
    @synchronized(self)
    {
        if (!_subViews) _subViews = [[NSMutableDictionary dictionaryWithCapacity:5] retain]; //5 is a guess of how many subviews an average composite view will have
    }
    
    return _subViews;
}



#pragma mark instance methods
-(void)setValue:(id)value forKey:(NSString *)key
{
    [self.subViews setObject:value forKey:key];
}


-(id)valueForKey:(NSString *)key
{
    return [self.subViews valueForKey:key];
}


@end









#pragma mark -
#pragma mark runtime additions
id EMKCompositeViewDynamicGetter(id self, SEL _cmd)
{
    return [self valueForKey:EMK_propertyNameFromGetter(_cmd)];    
}




void EMKCompositeViewDynamicSetter(id self, SEL _cmd, id value)
{
    NSString *propertyName = EMK_propertyNameFromSetter(_cmd);
    
    if (propertyName) [self setValue:value forKey:propertyName];
}

