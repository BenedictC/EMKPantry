//
//  NSFileHandle(EMKTemporaryFile).m
//  PresentationCaster
//
//  Created by Benedict Cohen on 15/11/2010.
//  Copyright 2010 Electric Muffin Kitchen. All rights reserved.
//

#import "NSFileHandle(EMKTemporaryFile).h"


@implementation NSFileHandle (EMKTemporaryFile)


+(NSFileHandle *)EMK_fileHandleForWritingToTemporaryFile:(NSURL**)temporaryFilePath
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *path;
    do 
    {
        path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", random()]];
    } while ([fileManager fileExistsAtPath:path]);

    [fileManager createFileAtPath:path contents:nil attributes:nil];
    
    *temporaryFilePath = [NSURL fileURLWithPath:path];
    return [NSFileHandle fileHandleForWritingAtPath:path];
}


@end
