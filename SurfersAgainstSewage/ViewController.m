//
//  ViewController.m
//  SurfersAgainstSewage
//
//  Created by Dan Clarke on 11/07/2014.
//  Copyright (c) 2014 Dan Clarke. All rights reserved.
//

//Headers
#import "ViewController.h"
#import "listViewController.h"
#import "mainNavViewController.h"
#import "reportViewController.h"

//Libraries
#import "cachedFiles.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)runForcedUpdate { [self runUpdateForced:TRUE]; }
-(void)runUpdateForced:(BOOL)forced {
    //Reset UI if failed.
    BOOL runTest = FALSE;
    if([cachedFiles checkFile:@"list.plist" ifOlderThan:[NSDate dateWithTimeIntervalSinceNow:43200]]) { runTest = TRUE; }
    if(forced) { runTest = TRUE; }
    
    if(runTest) {
        [topLabel setText:@"Downloading latest data..."];
        [setupProgressBar setAlpha:1];
        
        initalDownload = [[LazyInternet alloc] init];
        [initalDownload startDownload:[NSString stringWithFormat:@"https://overbythere.co.uk/apps/sasapp/ioscall.php?time=%ld",(long)[[NSDate date] timeIntervalSince1970]] withDelegate:self withUnique:initalDownload];
    }
    else {
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* filePath = [docsDir stringByAppendingPathComponent: @"list.plist"];
        ourData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        [self loadMainScreen];
    }
}
			
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [[self view] setBackgroundColor:[UIColor colorWithRed:0 green:69.0f/255.0f blue:99.0f/255.0f alpha:1]];
    imageBack1 = [[UIImageView alloc] initWithFrame:CGRectMake(-25, -25, 370, 618)];
    [imageBack1 setImage:[UIImage imageNamed:@"start1.jpg"]];
    [imageBack1 setContentMode:UIViewContentModeScaleAspectFit];
    
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-25);
    verticalMotionEffect.maximumRelativeValue = @(25);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-25);
    horizontalMotionEffect.maximumRelativeValue = @(25);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    imageBack2 = [[UIImageView alloc] initWithFrame:CGRectMake(-25, -25, 370, 618)];
    [imageBack2 addMotionEffect:group];
    [imageBack2 setImage:[UIImage imageNamed:@"start2.jpg"]];
    [imageBack2 setAlpha:0];
    [imageBack2 setContentMode:UIViewContentModeScaleAspectFit];
    
    [[self view] addSubview:imageBack1];
    [[self view] addSubview:imageBack2];
    
    
    topLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, 40)];
    [topLabel setText:@"Downloading latest data..."];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topLabel setTextColor:[UIColor whiteColor]];
    [[self view] addSubview:topLabel];
    [topLabel sizeToFit];
    
    setupProgressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [setupProgressBar setFrame:CGRectMake(20, 60+topLabel.frame.size.height, self.view.frame.size.width-40, 10)];
    [setupProgressBar setProgressTintColor:[UIColor whiteColor]];
    [setupProgressBar setTrackTintColor:[UIColor colorWithRed:0.042 green:0.098 blue:0.112 alpha:1.000]];
    [[self view] addSubview:setupProgressBar];
    
    homeLogo = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-235)/2, -235, 235, 235)];
    [homeLogo setImage:[UIImage imageNamed:@"homeLogo"]];
    [[self view] addSubview:homeLogo];
    
    launchBeach = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-170, self.view.frame.size.width-40, 50)];
    [launchBeach setBackgroundColor:[UIColor colorWithRed:0.529 green:0.145 blue:0.095 alpha:1.000]];
    [launchBeach setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[launchBeach titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [[launchBeach layer] setMasksToBounds:TRUE];
    [[launchBeach layer] setCornerRadius:5];
    [launchBeach addTarget:self action:@selector(selectBeachScreen) forControlEvents:UIControlEventTouchUpInside];
    [launchBeach setTitle:@"Select Beach" forState:UIControlStateNormal];
    [launchBeach setEnabled:FALSE];
    [launchBeach setAlpha:0];
    [launchBeach setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
    launchAlerts = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-100, self.view.frame.size.width-40, 50)];
    [launchAlerts setBackgroundColor:[UIColor colorWithRed:0.044 green:0.149 blue:0.156 alpha:1.000]];
    [launchAlerts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[launchAlerts titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [[launchAlerts layer] setCornerRadius:5];
    [[launchAlerts layer] setMasksToBounds:TRUE];
    [launchAlerts addTarget:self action:@selector(launchAlertScreen) forControlEvents:UIControlEventTouchUpInside];
    [launchAlerts setTitle:@"UK Wide Sewage Alerts" forState:UIControlStateNormal];
    [launchAlerts setEnabled:FALSE];
    [launchAlerts setAlpha:0];
    [launchAlerts setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
    
    [[self view] addSubview:launchBeach];
    [[self view] addSubview:launchAlerts];
    
    CALayer *bottomBeachBorder = [CALayer layer];
    [bottomBeachBorder setFrame:CGRectMake(0, 0, launchBeach.frame.size.width, launchBeach.frame.size.height-5)];
    [bottomBeachBorder setBackgroundColor:[UIColor colorWithRed:0.877 green:0.243 blue:0.160 alpha:1.000].CGColor];
    [bottomBeachBorder setCornerRadius:5];
    [bottomBeachBorder setZPosition:-1];
    [launchBeach.layer addSublayer:bottomBeachBorder];
    
    CALayer *bottomAlertBorder = [CALayer layer];
    [bottomAlertBorder setFrame:CGRectMake(0, 0, launchAlerts.frame.size.width, launchAlerts.frame.size.height-5)];
    [bottomAlertBorder setBackgroundColor:[UIColor colorWithRed:0.072 green:0.241 blue:0.253 alpha:1.000].CGColor];
    [bottomAlertBorder setCornerRadius:5];
    [bottomAlertBorder setZPosition:-1];
    [launchAlerts.layer addSublayer:bottomAlertBorder];
    
    
    [self runUpdateForced:FALSE];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)launchAlertScreen {
    if([[ourData objectForKey:@"sewages"] count]>0) {
        listViewController *nextScreen = [[listViewController alloc] initWithNibName:@"listViewController_iPhone" data:[ourData objectForKey:@"sewages"]];
        mainNavViewController *navControl = [[mainNavViewController alloc] initWithRootViewController:nextScreen];
        [self presentViewController:navControl animated:TRUE completion:nil];
    }
    else {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"No Sewage alerts" message:@"Currently, SAS are not aware of any sewage alerts in the UK." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Report sewage spill", nil];
        [al setDelegate:self];
        [al show];
    }
}

-(void)selectBeachScreen {
    listViewController *nextScreen = [[listViewController alloc] initWithNibName:@"listViewController_iPhone" data:[ourData objectForKey:@"beaches"]];
    mainNavViewController *navControl = [[mainNavViewController alloc] initWithRootViewController:nextScreen];
    [self presentViewController:navControl animated:TRUE completion:nil];
}

-(void)reportSewageScreen {
    listViewController *nextScreen = [[listViewController alloc] initWithNibName:@"listViewController_iPhone" data:[ourData objectForKey:@"beaches"]];
    mainNavViewController *navControl = [[mainNavViewController alloc] initWithRootViewController:nextScreen];
    [self presentViewController:navControl animated:TRUE completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqualToString:@"No Sewage alerts"]) {
        NSLog(@"%ld",(long)buttonIndex);
        if(buttonIndex==0) { /* button was "Close */ }
        else {
            //Button was "Report sewage spill"
            reportViewController *nextScreen = [[reportViewController alloc] initWithNibName:@"reportViewController" data:[ourData objectForKey:@"beaches"]];
            mainNavViewController *navControl = [[mainNavViewController alloc] initWithRootViewController:nextScreen];
            [self presentViewController:navControl animated:TRUE completion:nil];
        }
    }
}

- (void)lazyInternetDidLoad:(NSData*)data withUnique:(id)unique {
    NSLog(@"Did load. %f",[setupProgressBar progress]);
    //NSLog(@"%@",data);
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* filePath = [docsDir stringByAppendingPathComponent: @"list.plist"];
    [data writeToFile: filePath atomically: YES];
    //NSLog(@"%@",str);
    ourData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSLog(@"%@",[ourData objectForKey:@"sewages"]);
    NSLog(@"Data now loaded, proceeding with setup");
    [self loadMainScreen];
}
-(void)loadMainScreen {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [imageBack2 setAlpha:1];
        [topLabel setAlpha:0];
        [setupProgressBar setAlpha:0];
        [launchBeach setAlpha:1];
        [launchAlerts setAlpha:1];
        [reloadBtn setAlpha:0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = homeLogo.frame;
            frame.origin.y = 50;
            [homeLogo setFrame:frame];
            [launchBeach setEnabled:TRUE];
            [launchAlerts setEnabled:TRUE];
            [reloadBtn setEnabled:FALSE];
        }];
    }];
}
- (void)lazyInternetGotSize:(int)totalSize withUnique:(id)unique {
	//NSLog(@"Did get size %d",totalSize);
	
}
- (void)lazyInternetProgress:(CGFloat)currentProgress withUnique:(id)unique {
	[setupProgressBar setProgress:currentProgress animated:TRUE];
    //NSLog(@"Loading %f",currentProgress);
}
- (void)lazyInternetDidFailWithError:(NSError *)error withUnique:(id)unique {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Surfers Against Sewage" message:@"Sorry, but we are unable to download the latest data to your device, please try again later." delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [topLabel setText:@"Failed to download"];
    [setupProgressBar setAlpha:0];
    [alert show];
    
    if(!reloadBtn) {
        reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-80, self.view.frame.size.width-(20*2), 50)];
        [reloadBtn setBackgroundColor:[UIColor colorWithRed:0.044 green:0.149 blue:0.156 alpha:1.000]];
        [reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[reloadBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
        [[reloadBtn layer] setCornerRadius:5];
        [[reloadBtn layer] setMasksToBounds:TRUE];
        [reloadBtn addTarget:self action:@selector(runForcedUpdate) forControlEvents:UIControlEventTouchUpInside];
        [reloadBtn setTitle:@"Reload" forState:UIControlStateNormal];
        [reloadBtn setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [reloadBtn setAlpha:0];
        [[self view] addSubview:reloadBtn];
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [reloadBtn setAlpha:1];
    } completion:nil];

    
    NSLog(@"Did fail %@",error);
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

-(UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

@end
