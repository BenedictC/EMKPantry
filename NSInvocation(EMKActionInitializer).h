//
//  NSInvocation(EMKActionInitializer).h
//  EMKPantry
//
//  Created by Benedict Cohen on 25/10/2010.
//  Copyright 2010 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSInvocation (EMKActionInitializer)


+(NSInvocation*)EMK_invocationWithTarget:(id)target action:(SEL)action sender:(id)sender;

@end
