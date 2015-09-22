//
//  loadingView.m
//
//  Created by Dan Clarke on 26/12/2011.
//  Copyright (c) 2011 OverByThere. All rights reserved.
//

#import "loadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation loadingView

+(void)OBTshowLoading:(UIView *)view withText:(NSString *)text {
	
	CGRect boxFrame = CGRectMake(0, 0, 130, 110);
	boxFrame.origin.x = (view.bounds.size.width-boxFrame.size.width)/2;
	boxFrame.origin.y = (view.bounds.size.height-boxFrame.size.height)/2;
	
	[[view viewWithTag:4] removeFromSuperview];
	UIView *ourView = [[UIView alloc] initWithFrame:boxFrame];
	[ourView setAutoresizesSubviews:YES];
	[ourView setTag:4];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[[view viewWithTag:1] removeFromSuperview];
	UIImageView *loadingBackground = [[UIImageView alloc] initWithFrame:ourView.bounds];
	[loadingBackground setBackgroundColor:[UIColor blackColor]];
	[loadingBackground setAlpha:0.8];
	[loadingBackground.layer setCornerRadius:10];
	[loadingBackground setTag:1];
	[loadingBackground setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	[ourView addSubview:loadingBackground];
	
	
	[[view viewWithTag:2] removeFromSuperview];
	UIActivityIndicatorView  *loadingTicker = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[loadingTicker setFrame:CGRectMake(10, 10, 110, 80)];
	[loadingTicker setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
	[loadingTicker setAlpha:0];
	[loadingTicker startAnimating];
	[loadingTicker setTag:2];
	[ourView addSubview:loadingTicker];
	
	
	[[view viewWithTag:3] removeFromSuperview];
	UILabel *loadingText = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 110, 20)];
	loadingText.backgroundColor = [UIColor clearColor];
	[loadingText setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
	[loadingText setTextColor:[UIColor whiteColor]];
	[loadingText setTextAlignment:NSTextAlignmentCenter];
	[loadingText setFont:[UIFont boldSystemFontOfSize:17]];
	[loadingText setAlpha:0];
	[loadingText setText:text];
	[loadingText setTag:3];
	
	[ourView addSubview:loadingText];
	
	[view addSubview:ourView];
	
	[UIView beginAnimations: @"Fade In" context:nil];
	[UIView setAnimationDuration:0.3];
	[loadingBackground setAlpha:0.8];
	[loadingTicker setAlpha:1];
	[loadingText setAlpha:1];
	[UIView commitAnimations];
}

+(void)OBTshowLoading:(UIView *)view {
	[loadingView OBTshowLoading:view withText:@"loading"];
}

+(void)OBTupdatetext:(NSString *)text forView:(UIView *)view {
	UILabel *label = (UILabel *)[view viewWithTag:3];
	[label setText:text];
}

+(void)OBTupdatetext:(NSString *)text andWidth:(CGFloat)width andLines:(int)lines forView:(UIView *)view {
	UILabel *label = (UILabel *)[view viewWithTag:3];
	UIView *box = (UIView *)[view viewWithTag:4];
	CGRect oldTextFrame = label.frame;
	[label setNumberOfLines:lines];
	CGRect frame = box.frame;
	frame.size.width = width;
	frame.size.height = (frame.size.height-oldTextFrame.size.height)+(20*lines);
	frame.origin.x = (view.frame.size.width-width)/2;
	frame.origin.y = (view.frame.size.height-frame.size.height)/2;
	
	[UIView animateWithDuration:0.2 delay:0.0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 [box setFrame:frame];
						 CGRect newTextFrame = label.frame;
						 newTextFrame.size.height = (20*lines);
						 newTextFrame.origin.y = ((frame.size.height-20)-newTextFrame.size.height)+10;
						 [label setFrame:newTextFrame];
						 [label setText:text];
					 }
					 completion:^(BOOL fin) { if (fin) { }}];
	[UIView setAnimationDuration:0.2];
	[UIView commitAnimations];
}

+(void)OBThideLoading:(UIView *)view {
	if([view viewWithTag:1]) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[UIView animateWithDuration:0.2 delay:0.0
							options:UIViewAnimationOptionAllowUserInteraction
						 animations:^{
							 [[view viewWithTag:1] setAlpha:0];
							 [[view viewWithTag:2] setAlpha:0];
							 [[view viewWithTag:3] setAlpha:0];
							 [[view viewWithTag:4] setAlpha:0];}
						 completion:^(BOOL fin) {
							 if (fin) {
								 [[view viewWithTag:1] removeFromSuperview];
								 [[view viewWithTag:2] removeFromSuperview];
								 [[view viewWithTag:3] removeFromSuperview];
								 [[view viewWithTag:4] removeFromSuperview];
							 }}];
		[UIView setAnimationDuration:0.2];
		[UIView commitAnimations];
	}
}

@end
