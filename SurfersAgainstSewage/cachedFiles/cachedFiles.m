//
//  cachedFiles.m
//
//  Created by Dan Clarke on 28/05/2012.
//  Copyright (c) 2012 OverByThere. All rights reserved.
//

#import "cachedFiles.h"
#import "LazyInternet.h"
#import "loadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation cachedFiles

+(BOOL)checkFile:(NSString *)fileName {
	NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *foofile = [documentsPath stringByAppendingPathComponent:fileName];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
	if(!fileExists) { NSLog(@"File check: Missing - %@",foofile); }
	return fileExists;
}

+(NSString *)getFileAddress:(NSString *)fileName {
	NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *foofile = [documentsPath stringByAppendingPathComponent:fileName];
	return foofile;
}

+(BOOL)checkFile:(NSString *)fileName ifOlderThan:(NSDate *)olderThanDate {
	BOOL fileExists = [cachedFiles checkFile:fileName];
	
	BOOL isolderOrNotThere = TRUE;
	if(fileExists) {
		NSLog(@"It exists, checking date");
		isolderOrNotThere = FALSE;
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[cachedFiles getFileAddress:fileName] error:nil];
		NSDate *fileDate = [attributes fileModificationDate];
		NSTimeInterval oldDate = [olderThanDate timeIntervalSince1970];
		NSTimeInterval currentDate = [fileDate timeIntervalSince1970];
		if(oldDate>currentDate) { //File is newer (if a week ago is older than 2 days ago)
			NSLog(@"Date is newer %f > %f)",currentDate,oldDate);
			return FALSE;
		}
		else { //File is older (if a week ago is older than 2 weeks ago
			NSLog(@"Date is older %f < %f)",currentDate,oldDate);
			return TRUE;
		}
	}
	else {
		NSLog(@"file does not exist");
		return TRUE;
	}
	return isolderOrNotThere;
}

+(NSData *)getFile:(NSString *)fileName {
	NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *foofile = [documentsPath stringByAppendingPathComponent:fileName];
	return [NSData dataWithContentsOfFile:foofile];
}

+(UIImage *)getImage:(NSString *)fileName {
	return [UIImage imageWithData:[cachedFiles getFile:fileName]];
}

+(BOOL)storeImage:(NSString *)fileName withImage:(UIImage *)image {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [paths objectAtIndex: 0];
	NSString *docFile = [docDir stringByAppendingPathComponent:fileName];
	
	[UIImageJPEGRepresentation(image,1.0) writeToFile:docFile atomically:YES];
	
	return YES;
}


+(void)checkAndLoadImage:(NSString *)file withURL:(NSString *)url inView:(UIImageView *)view {
	if(![cachedFiles checkFile:file]) {
		LazyInternet *download = [LazyInternet alloc];
		NSArray *outArray = [NSArray arrayWithObjects:view, file, url, nil];
		
		UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[loading setFrame:view.bounds];
		[loading startAnimating];
		[loading setTag:5];
		[view addSubview:loading];
		
		[download startDownload:url withDelegate:self withUnique:outArray];
	}
	else {
		[view setImage:[cachedFiles getImage:file]];
	}
}

+(void)checkAndLoadImage:(NSString *)file withURL:(NSString *)url inView:(UIImageView *)view ifOlderThan:(NSDate *)date {
	if([cachedFiles checkFile:file ifOlderThan:date]) { //if is older (or does not exist)
		[cachedFiles checkAndLoadImage:file withURL:url inView:view];
	}
}

+(void)lazyInternetDidLoad:(NSData *)data withUnique:(id)unique {
	if([unique isKindOfClass:[NSArray class]]) {
		if([[unique objectAtIndex:0] isKindOfClass:[UIImageView class]]) {
			UIImage *image = [UIImage imageWithData:data];
			
			[cachedFiles updateImageDisplay:[unique objectAtIndex:0] withImage:image];
			[cachedFiles storeImage:[unique objectAtIndex:1] withImage:image];
		}
	}
}

+ (void)lazyInternetGotSize:(int)totalSize withUnique:(id)unique {
	//NSLog(@"Total size is %d",totalSize);
}


+ (void)lazyInternetProgress:(CGFloat)currentProgress withUnique:(id)unique {
	//NSLog(@"Current progress %f",currentProgress);
	
	//int percent;
	
	//percent = round(currentProgress*100);
}

+(void)setImage:(UIImageView *)imageView withImage:(UIImage *)image
{
	CATransition *animation = [CATransition animation];
	animation.duration = 0.188;
	animation.type = kCATransitionFade;
	[imageView.layer addAnimation:animation forKey:@"imageFade"];
	[imageView setImage:image];
}

+(UIImageView *)updateImageDisplay:(UIImageView *)view withImage:(UIImage *)image {
	[[view viewWithTag:5] removeFromSuperview];
	[self setImage:view withImage:image];
	
	
	return view;
}

@end
