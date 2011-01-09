//
//  EMKSetControllerObjectChangeDescription.h
//  EMKPantry
//
//  Created by Benedict Cohen on 09/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EMKSetControllerObjectChangeDescription : NSObject 
{
    id _object;
    
    NSIndexPath *_preIndexPath;
    NSIndexPath *_postIndexPath;    
    
    NSUInteger _changeType;
}

+(id)objectChangeDescriptionWithObject:(id)object preIndex:(NSIndexPath *)preIndex postIndex:(NSIndexPath *)postIndex changeType:(EMKSetControllerChangeType)changeType;

@property(readonly, nonatomic) id object;
@property(readonly, nonatomic) NSIndexPath *preIndexPath;
@property(readonly, nonatomic) NSIndexPath *postIndexPath;
@property(readonly, nonatomic) NSUInteger changeType;


@end
