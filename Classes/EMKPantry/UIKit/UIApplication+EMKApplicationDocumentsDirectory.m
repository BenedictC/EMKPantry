//
//  UIApplication+EMKApplicationDocumentsDirectory.m
//  EMKPantry
//
//  Created by Benedict Cohen on 19/09/2011.
//  Copyright 2011 Benedict Cohen. All rights reserved.
//

#import "UIApplication+EMKApplicationDocumentsDirectory.h"

@implementation UIApplication (EMKApplicationDocumentsDirectory)

- (NSURL *)EMK_applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
