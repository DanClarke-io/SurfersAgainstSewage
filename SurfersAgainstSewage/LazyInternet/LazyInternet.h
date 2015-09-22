//  Created by Dan Clarke on 18/01/2012.
//  Copyright (c) 2012 OverByThere. All rights reserved.

#import <UIKit/UIKit.h>

@protocol LazyInternetDelegate;

@interface LazyInternet : NSObject {
    NSURLConnection *intConnection;
    id <LazyInternetDelegate> delegate;
    NSString *unique;
    CGFloat statusCode;
    long long totalSize;
    CGFloat progress;
    NSTimer *timer;
    NSMutableDictionary *additionalDict;
}

@property (strong, nonatomic) NSMutableData *activeDownload;
@property (strong, nonatomic) NSString *currentURL;

- (void)startDownload:(NSString *)url withDelegate:(id)_delegate withUnique:(id)_unique;
- (void)cancelDownload;

@end


@protocol LazyInternetDelegate <NSObject>

- (void)lazyInternetDidLoad:(NSData*)data withUnique:(id)unique;
- (void)lazyInternetGotSize:(int)totalSize withUnique:(id)unique;
- (void)lazyInternetProgress:(CGFloat)currentProgress withUnique:(id)unique;
- (void)lazyInternetDidFailWithError:(NSError *)error withUnique:(id)unique;

@end