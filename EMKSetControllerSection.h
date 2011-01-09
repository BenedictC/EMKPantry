//
//  EMKSetControllerSection.h
//  EMKPantry
//
//  Created by Benedict Cohen on 08/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EMKSetControllerSectionInfo;

@interface EMKSetControllerSection : NSObject <EMKSetControllerSectionInfo>
{
    NSString *_indexTitle; 
    NSString *_name;
    NSArray *_objects;
}

-(id)initWithName:(NSString *)name;
-(void)setObjects:(NSArray *)objects;
-(void)setIndexTitle:(NSString *)indexTitle;

@end