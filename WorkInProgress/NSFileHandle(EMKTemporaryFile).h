//
//  NSFileHandle(EMKTemporaryFile).h
//  PresentationCaster
//
//  Created by Benedict Cohen on 15/11/2010.
//  Copyright 2010 Electric Muffin Kitchen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileHandle (EMKTemporaryFile)


+(NSFileHandle *)EMK_fileHandleForWritingToTemporaryFile:(NSURL**)temporaryFilePath;


@end
