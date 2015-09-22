//
//  loadingView.h
//
//  Created by Dan Clarke on 26/12/2011.
//  Copyright (c) 2011 OverByThere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface loadingView : NSObject {
	
}

+(void)OBTshowLoading:(UIView *)view withText:(NSString *)text;
+(void)OBTshowLoading:(UIView *)view;
+(void)OBThideLoading:(UIView *)view;

+(void)OBTupdatetext:(NSString *)text forView:(UIView *)view;
+(void)OBTupdatetext:(NSString *)text andWidth:(CGFloat)width andLines:(int)lines forView:(UIView *)view;


@end
