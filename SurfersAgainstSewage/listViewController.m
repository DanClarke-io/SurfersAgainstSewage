//
//  listViewController.m
//  SurfersAgainstSewage
//
//  Created by Dan Clarke on 11/07/2014.
//  Copyright (c) 2014 Dan Clarke. All rights reserved.
//

#import "listViewController.h"
#import "detailViewController.h"

#import "loadingView.h"

@interface listViewController ()

@end

@implementation listViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil data:(NSMutableDictionary *)data {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if(self) {
        ourData = data;
        ourType = @"beaches"; //[[data objectForKey:[[data allKeys] objectAtIndex:0]] objectForKey:@"data-type"];
        NSLog(@"Our data set for %@ with %ld records",ourType,(unsigned long)[[ourData allKeys] count]);
        [self updateSort];
    }
    return self;
}

-(void)updateSort {
    NSArray *values = [ourData allKeys];
    sortedList = [values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = [[ourData objectForKey:obj1] objectForKey:@"shorttitle"];
        NSString *str2 = [[ourData objectForKey:obj2] objectForKey:@"shorttitle"];
        return (NSComparisonResult)[str1 compare:str2];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self setTitle:@"UK Beaches"];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[self tableView] setSeparatorColor:[UIColor grayColor]];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[[self navigationController] navigationBar] setBarTintColor:[UIColor colorWithRed:0.072 green:0.241 blue:0.253 alpha:1.000]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateSpillReports)]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 80, 40)];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [[self navigationItem] setLeftItemsSupplementBackButton:TRUE];
    [backButton setTitle:@" Back" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    //[backButton setContentMode:UIViewContentModeLeft];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barBackButtonItem, nil];
    self.navigationItem.hidesBackButton = YES;
}

-(void)goToHome { [self dismissViewControllerAnimated:TRUE completion:nil]; }

-(void)updateSpillReports {
    [loadingView OBTshowLoading:self.view withText:@"Updating..."];
    initalDownload = [[LazyInternet alloc] init];
    [initalDownload startDownload:[NSString stringWithFormat:@"https://overbythere.co.uk/apps/sasapp/ioscall.php?time=%ld",(long)[[NSDate date] timeIntervalSince1970]] withDelegate:self withUnique:initalDownload];
}

- (void)lazyInternetDidLoad:(NSData*)data withUnique:(id)unique {
    NSLog(@"Loaded data from list");
    NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* filePath = [docsDir stringByAppendingPathComponent: @"list.plist"];
    [data writeToFile: filePath atomically: YES];
    //NSMutableDictionary *tempData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSLog(@"Counted %ld in reply",[[tempData allKeys] count]);
    ourData = [tempData objectForKey:ourType];
    [self updateSort];
    NSLog(@"Counted %ld cells for %@ display",[sortedList count],ourType);
    [[self tableView] reloadData];
    [loadingView OBThideLoading:self.view];
    
}
- (void)lazyInternetGotSize:(int)totalSize withUnique:(id)unique { NSLog(@"Did get size %d",totalSize); }
- (void)lazyInternetDidFailWithError:(NSError *)error withUnique:(id)unique { NSLog(@"Did fail %@",error); [loadingView OBThideLoading:self.view]; }

// - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger ourInt = [sortedList count];
    NSLog(@"We count %ld cells",(long)ourInt);
	return ourInt;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tv dequeueReusableCellWithIdentifier:@"eventCell"];
    NSMutableDictionary *ourCell = [ourData objectForKey:[sortedList objectAtIndex:indexPath.row]];
    
    if(!cell){ cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"]; }
    cell.textLabel.text = [ourCell objectForKey:@"name"];
    
    if([ourCell objectForKey:@"updated"] && [[ourCell objectForKey:@"data-type"] isEqualToString:@"sewages"]) {
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Last update: %@",[ourCell objectForKey:@"updated"]]];
        [[cell textLabel] setText:[ourCell objectForKey:@"shorttitle"]];
    }
    else { [[cell detailTextLabel] setText:nil]; }
    if([[ourCell objectForKey:@"warning"] isEqualToString:@"recentsewage"]) {
        [cell setBackgroundColor:[UIColor colorWithRed:1.000 green:0.719 blue:0.387 alpha:1.000]];
    }
    else if([[ourCell objectForKey:@"warning"] isEqualToString:@"sewagepresent"]) {
        [cell setBackgroundColor:[UIColor colorWithRed:1.000 green:0.494 blue:0.516 alpha:1.000]];
    }
    else { [cell setBackgroundColor:[UIColor whiteColor]]; }
    
    return cell;

}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tv deselectRowAtIndexPath:indexPath animated:TRUE];
    NSMutableDictionary *ourCell = [ourData objectForKey:[sortedList objectAtIndex:indexPath.row]];
    detailViewController *nextScreen = [[detailViewController alloc] initWithNibName:@"detailViewController_iPhone" data:ourCell];
    [[self navigationController] pushViewController:nextScreen animated:TRUE];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

@end
