//
//  EMKSetControllerSectionChangeDescription.h
//  EMKPantry
//
//  Created by Benedict Cohen on 09/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMKSetControllerSectionChangeDescription : NSObject 
{
    id _section;
    
    NSUInteger _index;
    NSUInteger _changeType;
}

+(id)sectionChangeDescriptionWithSection:(id)section index:(NSUInteger)index changeType:(EMKSetControllerChangeType)changeType;


@property(readonly, nonatomic) id section;
@property(readonly, nonatomic) NSUInteger index;
@property(readonly, nonatomic) NSUInteger changeType;

@end
