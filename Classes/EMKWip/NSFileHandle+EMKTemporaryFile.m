//
//  NSFileHandle+EMKTemporaryFile.m
//  PresentationCaster
//
//  Created by Benedict Cohen on 15/11/2010.
//  Copyright 2010 Electric Muffin Kitchen. All rights reserved.
//

#import "NSFileHandle+EMKTemporaryFile.h"


@implementation NSFileHandle (EMKTemporaryFile)


+(NSFileHandle *)EMK_fileHandleForWritingToTemporaryFile:(NSURL**)temporaryFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    //create a random path from the temp dir and a random number
    NSString *temporaryDirectory = NSTemporaryDirectory();
    NSString *path = nil;
    do 
    {
        path = [temporaryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", random()]];
    } while ([fileManager fileExistsAtPath:path]);

    //TODO: theoretically another thread could create the file
    
    
    // attempt to create the file
    if ([fileManager createFileAtPath:path contents:nil attributes:nil])
    {
        //return the path and the file handle
        *temporaryFilePath = [NSURL fileURLWithPath:path];
        return [NSFileHandle fileHandleForWritingAtPath:path];        
    }
    else
    {    
        //we failed!
        *temporaryFilePath = nil;
        return nil;
    }
    
}


@end
