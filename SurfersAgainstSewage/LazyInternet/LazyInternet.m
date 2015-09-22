//  Created by Dan Clarke on 18/01/2012.
//  Copyright (c) 2012 OverByThere. All rights reserved.


#import "LazyInternet.h"

@implementation LazyInternet

@synthesize activeDownload;
@synthesize currentURL;

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        additionalDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)startDownload:(NSString *)url withDelegate:(id)_delegate withUnique:(id)_unique {
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSLog(@"URL Request: %@",url);
    currentURL = url;
    activeDownload = [NSMutableData data];
    NSURLRequest *ourRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:ourRequest delegate:self];
    intConnection = conn;
    delegate = _delegate;
    unique = _unique;
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                             target:self
                                           selector:@selector(failedLoading:)
                                           userInfo:nil
                                            repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}



- (void)setValue:(id)value forKey:(NSString *)key {
    [additionalDict setObject:value forKey:key];
}

- (id)valueForKey:(NSString *)key {
    return [additionalDict objectForKey:key];
}

- (void)cancelDownload {
    [intConnection cancel];
    intConnection = nil;
    activeDownload = nil;
}

- (void)connection: (NSURLConnection*) connection didReceiveResponse: (NSHTTPURLResponse*) response {
    statusCode = [response statusCode];
    [timer invalidate];
    if (statusCode == 200) {
        totalSize = [[[response allHeaderFields] valueForKey:@"Content-Length"] intValue];
        if(totalSize<=0) {
            totalSize = [response expectedContentLength];
        }
    }
    if([delegate respondsToSelector:@selector(lazyInternetGotSize:withUnique:)]) {
        [delegate lazyInternetGotSize:(int)totalSize withUnique:unique];
    }
}

-(void)failedLoading:(id)selector {
    [self failedLoading:selector withUnique:unique];
}

-(void)failedLoading:(id)selector withUnique:(id)un; {
    NSLog(@"Failed download %@",selector);
    [timer invalidate];
    [self cancelDownload];
    if([delegate respondsToSelector:@selector(lazyInternetDidFailWithError:withUnique:)]) {
        [delegate lazyInternetDidFailWithError:[NSError errorWithDomain:@"Timeout" code:0 userInfo:nil] withUnique:un];
    }
    else {
        NSLog(@"Failed download (%@), however no responder is set up on %@",[NSError errorWithDomain:@"Timeout" code:0 userInfo:nil],delegate);
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [timer invalidate];
    [activeDownload appendData:data];
    progress = ((float) [activeDownload length] / (float) totalSize);
    if([delegate respondsToSelector:@selector(lazyInternetProgress:withUnique:)]) {
        [delegate lazyInternetProgress:progress withUnique:unique];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    activeDownload = nil;
    intConnection = nil;
    [self failedLoading:error withUnique:unique];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSData *data = activeDownload;
    [timer invalidate];
    //UIImage *image = [[UIImage alloc] initWithData:activeDownload];
    activeDownload = nil;
    intConnection = nil;
    if([delegate respondsToSelector:@selector(lazyInternetDidLoad:withUnique:)]) {
        [delegate lazyInternetDidLoad:data withUnique:unique];
    }
    else {
        NSLog(@"Got data, however no responder is set up on %@",delegate);
    }
}

@end

