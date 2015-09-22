//
//  ViewController.h
//  SurfersAgainstSewage
//
//  Created by Dan Clarke on 11/07/2014.
//  Copyright (c) 2014 Dan Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyInternet.h"

@interface ViewController : UIViewController <UIAlertViewDelegate> {
	UIProgressView *setupProgressBar;
	LazyInternet *initalDownload;
	UIImageView *imageBack1;
	UIImageView *imageBack2;
	UILabel *topLabel;
	UIImageView *homeLogo;
	NSMutableDictionary *ourData;
    
    UIButton *launchBeach;
    UIButton *launchAlerts;
    UIButton *reloadBtn;
}


@end

