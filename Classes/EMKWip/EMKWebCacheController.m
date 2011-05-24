//
//  EMKWebCacheController.m
//  Trot
//
//  Created by Benedict Cohen on 23/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EMKWebCacheController.h"


@interface EMKWebCacheController ()
+(NSString *)cachePath;
+(NSString *)cachePathForRemoteUrl:(NSURL *)url;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSDate *lastModified;
@property (nonatomic, copy) NSURL *url;
@property(readonly, copy, nonatomic) void(^completionBlock)(BOOL, NSError *, NSData *);

-(id)initWithURL:(NSURL *)theURL completionBlock:(void(^)(BOOL, NSError*, NSData *))completionBlock;
@end


NSString *const EMKWebCacheControllerDidFetchData = @"EMKWebCacheControllerDidFetchData";
NSString *const EMKWebCacheURLKey = @"EMKWebCacheURLKey";
NSString *const EMKWebCacheDataKey = @"EMKWebCacheDataKey";


@implementation EMKWebCacheController

#pragma mark class methods
+(void)fetchDataForUrl:(NSURL *)url completionBlock:(void(^)(BOOL, NSError*, NSData *))completionBlock
{
    [[[self alloc] initWithURL:url completionBlock:completionBlock] autorelease];
}



+(NSString *)cachePath
{
    static NSString *path = nil;
    if (path == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"EMKWebCache"] retain];
    }
    
    return path;
}


+(void)load
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
	/* check for existence of cache directory */
    NSString *cachePath = [self cachePath];
	if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath])
    {
        /* create a new cache directory */
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error]) 
        {
            //TODO: handle error
        }
    }
    
    [pool drain];
}



+(void)clearCache
{
    /* removes every file in the cache directory */    
    NSString *cachePath = [self cachePath];
    NSError *error;    
    
	/* remove the cache directory and its contents */
	if (![[NSFileManager defaultManager] removeItemAtPath:cachePath error:&error]) 
    {
        //TODO: handle error
		return;
	}
    
	/* create a new cache directory */
	if (![[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error]) 
    {
        //TODO: handle error
		return;
	}
}



+(BOOL)isDataCached:(NSURL *)url
{
    NSString *cachePath = [self cachePathForRemoteUrl:url];
    
    return ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]);
}
 


+(NSString *)cachePathForRemoteUrl:(NSURL *)url
{
    if (url == nil) return nil;
    
    NSString *cachePath = [self cachePath];
    NSString *filename = [NSString stringWithFormat:@"%ui", [url hash]];
    
    return [cachePath stringByAppendingPathComponent:filename];
}


+(NSData *)cachedDataForUrl:(NSURL *)url
{
//        url = [NSURL URLWithString:@"http://img-cdn.mediaplex.com/0/14020/123656/300x250_April_11_noniron.jpg"];
    NSString *path = [self cachePathForRemoteUrl:url];
    
    return [NSData dataWithContentsOfFile:path];
}


#pragma mark properties
@synthesize completionBlock = completionBlock_;
@synthesize receivedData = receivedData_;
@synthesize lastModified = lastModified_; 
@synthesize connection = connection_;
@synthesize url = url_;


#pragma mark memory management
/* This method initiates the load request. The connection is asynchronous, and we implement a set of delegate methods
 that act as callbacks during the load. */

- (id)initWithURL:(NSURL *)url completionBlock:(void(^)(BOOL, NSError *, NSData *))completionBlock
{
//    url = [NSURL URLWithString:@"http://img-cdn.mediaplex.com/0/14020/123656/300x250_April_11_noniron.jpg"];
    self = [super init];
    
	if (self) 
    {
        completionBlock_ = [completionBlock copy];
        url_ = [url copy];
        
		//Create the request. This application does not use a NSURLCache disk or memory cache, so our cache 
        //policy is to satisfy the request by loading the data from its source.
		NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        
		//Create the connection with the request and start loading the data. 
        //The connection object is owned both by the creator and the loading system.
		connection_ = [[NSURLConnection connectionWithRequest:theRequest delegate:self] retain];
        
		if (connection_ == nil) 
        {
            //TODO: invoke completion block with failure
		}
        else
        {
            //We retain so that we can stick around while the connection is executing
            //TODO: Is there a cleaner way of doing this?            
            [self retain];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(siblingFetchedData:) name:EMKWebCacheControllerDidFetchData object:nil];
        }
	}
    
	return self;
}



- (void)dealloc
{
    [completionBlock_ release];
	[receivedData_ release];
	[lastModified_ release];
	[connection_ release];
    [url_ release];
    
	[super dealloc];
}
         
         

-(void)fetchComplete
{
    [self.connection cancel];
    self.connection = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EMKWebCacheControllerDidFetchData object:nil];
    [self autorelease];
}
         
         
         
-(void)siblingFetchedData:(NSNotification *)notification
{
    NSURL *url = [[notification userInfo] objectForKey:EMKWebCacheURLKey];
    if ([url isEqual:self.url])
    {
        NSData *data = [[notification userInfo] objectForKey:EMKWebCacheDataKey];

        self.completionBlock(YES, nil, data);
        
        [self fetchComplete];    
    }
    
}



#pragma mark NSURLConnection delegate methods
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    NSURL *theURL = self.url;

    if ([[self class] isDataCached:theURL])
    {
        NSString *path = [[self class] cachePathForRemoteUrl:theURL];
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.completionBlock(YES, nil, data);
        
        [self fetchComplete];
        
        return nil;
    }    
    
    return request;
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    /* This method is called when the server has determined that it has
	 enough information to create the NSURLResponse. It can be called
	 multiple times, for example in the case of a redirect, so each time
	 we reset the data capacity. */
    
	/* create the NSMutableData instance that will hold the received data */
    
	long long contentLength = [response expectedContentLength];
	if (contentLength == NSURLResponseUnknownLength) 
    {
		contentLength = 500000;
	}
    
	self.receivedData = [NSMutableData dataWithCapacity:(NSUInteger)contentLength];
    
	/* Try to retrieve last modified date from HTTP header. If found, format
	 date so it matches format of cached image file modification date. */
    
	if ([response isKindOfClass:[NSHTTPURLResponse self]]) 
    {
		NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
		NSString *modified = [headers objectForKey:@"Last-Modified"];
		if (modified) 
        {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
			/* avoid problem if the user's locale is incompatible with HTTP-style dates */
			[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
            
			[dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
			self.lastModified = [dateFormatter dateFromString:modified];
			[dateFormatter release];
		}
		else
        {
			/* default if last modified date doesn't exist (not an error) */
			self.lastModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
		}
	}
}



- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /* Append the new data to the received data. */
    [self.receivedData appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //we may have cancelled the connection because we got the data by other means
    if (self.connection == connection)
    {
        self.completionBlock(NO, error, nil);
        [self fetchComplete];    
    }
}


- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	/* this application does not use a NSURLCache disk or memory cache */
    return nil;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *path = [[self class] cachePathForRemoteUrl:self.url];
    [self.receivedData writeToFile:path atomically:YES];
    NSData *diskData = [NSData dataWithContentsOfMappedFile:path];
    self.completionBlock(YES, nil, diskData);

    [self fetchComplete];    
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:diskData, EMKWebCacheDataKey, self.url, EMKWebCacheURLKey, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EMKWebCacheControllerDidFetchData object:self userInfo:userInfo];
}



@end
