//
//  EMKSetControllerSectionInfo.h
//  EMKPantry
//
//  Created by Benedict Cohen on 09/01/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>


@protocol EMKSetControllerSectionInfo
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *indexTitle;
@property (nonatomic, readonly) NSUInteger numberOfObjects;
@property (nonatomic, readonly) NSArray *objects;
@end

