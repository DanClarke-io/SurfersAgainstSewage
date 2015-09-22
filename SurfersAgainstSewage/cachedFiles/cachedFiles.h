//
//  cachedFiles.h
//
//  Created by Dan Clarke on 28/05/2012.
//  Copyright (c) 2012 OverByThere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cachedFiles : NSObject {
	
}
+(BOOL)checkFile:(NSString *)fileName;
+(BOOL)checkFile:(NSString *)fileName ifOlderThan:(NSDate *)date;
+(NSString *)getFileAddress:(NSString *)fileName;
+(NSData *)getFile:(NSString *)fileName;
+(UIImage *)getImage:(NSString *)fileName;
+(BOOL)storeImage:(NSString *)fileName withImage:(UIImage *)image;
+(void)checkAndLoadImage:(NSString *)file withURL:(NSString *)url inView:(UIImageView *)view;
+(void)lazyInternetDidLoad:(NSData *)data withUnique:(id)unique;
+(UIImageView *)updateImageDisplay:(UIImageView *)view withImage:(UIImage *)image;

@end
