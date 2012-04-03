//
//  EMKWebCacheController.h
//  Trot
//
//  Created by Benedict Cohen on 23/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface EMKWebCacheController : NSObject 
{
    
}


//This needs to return data if it's been cached and only execute block if it's not cached

+(NSData *)cachedDataForUrl:(NSURL *)url;
+(void)fetchDataForUrl:(NSURL *)url completionBlock:(void(^)(BOOL, NSError*, NSData *))completionBlock;


@end
