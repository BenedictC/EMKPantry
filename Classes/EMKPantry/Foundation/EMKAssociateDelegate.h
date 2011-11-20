//
//  EMKAssociateDelegate.h
//  EMKPantry
//
//  Created by Benedict Cohen on 17/02/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



#ifdef __IPHONE_4_3
@interface EMKAssociateDelegate : NSObject 

-(void)respondToSelector:(SEL)aSelector typeEncoding:(const char *)types usingBlock:(id(^)(id, ...))block;
//-(void)removeBlockForSelector:(SEL)aSelector;

@end



@interface NSObject (EMKAssociateDelegate)

-(EMKAssociateDelegate *)EMK_associateDelegate;

@end
#endif