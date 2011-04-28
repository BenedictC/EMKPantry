//
//  NSObject(EMKKVOSelector).h
//  EMKPantry
//
//  Created by Benedict Cohen on 20/02/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 @header EMKKVODispatcher.h
 @abstract   Provides methods to allow KVO observers to respond via a selector.
 @discussion 
 
 The functionality is accessed via the 3 methods provided in EMKKVOSelector (which is a category on NSObject).
 The selectors used for observationSelector must match one of the following method signatures:
 
 -(void)noArguements
 -(void)oneArguement:(NSString *)keyPath
 -(void)twoArguements:(NSString *) object:(id)
 -(void)threeArguements:(NSString *) object:(id) change:(NSDictionary)
 -(void)fourArguements:(NSString *) object:(id) change:(NSDictionary) context:(void *)
 
 eg
 
 -(void)refreshView;
 -(void)refreshCellValue:(NSString *)keyPath representingPersonObject:(id)person;
 

 
 All invocations to EMK_addObserver... methods must be balanced with a call to EMK_removeObserver... . These methods cannot be used interchangable with the standard methods.
 
 */

@interface NSObject (EMKKVOSelector)

-(void)EMK_addObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath selector:(SEL)observationSelector;
-(void)EMK_addObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context selector:(SEL)observationSelector;
-(void)EMK_removeObserver:(NSObject *)anObserver withKeyPath:(NSString *)keyPath selector:(SEL)observationSelector;
-(BOOL)EMK_isObject:(id)possibleObserver observerOfKeyPath:(NSString *)keyPath withSelector:(SEL)selector;
@end


