//
//  reportViewController.m
//  SurfersAgainstSewage
//
//  Created by Dan Clarke on 28/09/2014.
//  Copyright (c) 2014 Dan Clarke. All rights reserved.
//

#import "reportViewController.h"

@interface reportViewController ()

@end

@implementation reportViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil data:(NSMutableDictionary *)data {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if(self) {
        ourData = data;
        ourType = [[data objectForKey:[[data allKeys] objectAtIndex:0]] objectForKey:@"data-type"];
        NSLog(@"Our data set for %@ with %ld records",ourType,(unsigned long)[[ourData allKeys] count]);
        NSArray *values = [ourData allKeys];
        sortedList = [values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *str1 = [[ourData objectForKey:obj1] objectForKey:@"shorttitle"];
            NSString *str2 = [[ourData objectForKey:obj2] objectForKey:@"shorttitle"];
            return (NSComparisonResult)[str1 compare:str2];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self setTitle:@"Report sewage spill"];
    //[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[[self navigationController] navigationBar] setBarTintColor:[UIColor colorWithRed:0.072 green:0.241 blue:0.253 alpha:1.000]];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"infoBack"]]];
    [[self view] addSubview:scrollView];
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
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    beachBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,10,300,35)];
    [beachBtn setTitle:@"Select beach" forState:UIControlStateNormal];
    [beachBtn setBackgroundColor:[UIColor whiteColor]];
    [beachBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[beachBtn titleLabel] setTextAlignment:NSTextAlignmentLeft];
    [[beachBtn layer] setCornerRadius:5];
    [beachBtn addTarget:self action:@selector(updateBeach) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:beachBtn];
    
    beachPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [beachPicker setAlpha:0];
    [beachPicker setAutoresizingMask:UIViewContentModeTop | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [beachPicker setHidden:TRUE];
    [beachPicker setTintColor:[UIColor colorWithWhite:255 alpha:0.2]];
    [beachPicker setDelegate:self];
    [beachPicker setDataSource:self];
    
    
    CGRect pickerFrame = self.view.frame;
    pickerFrame.origin.y = (pickerFrame.size.height/3)*2;
    pickerFrame.size.height = (pickerFrame.size.height/3);
    UIView *beachPickerContainer = [[UIView alloc] initWithFrame:pickerFrame];
    [beachPickerContainer setBackgroundColor:[UIColor whiteColor]];
    
    
    [[self view] addSubview:beachPickerContainer];
    
    [beachPickerContainer addSubview:beachPicker];
    [[beachPickerContainer layer] setBorderColor:[UIColor redColor].CGColor];
    [[beachPickerContainer layer] setBorderWidth:1];
    [beachPicker setFrame:beachPickerContainer.bounds];
}

-(void) updateBeach {
    NSLog(@"Ready to call picker view");
    [beachPicker setAlpha:1];
    [beachPicker setHidden:FALSE];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { return 5; }
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"Test";
}

-(void)goToHome { [self dismissViewControllerAnimated:TRUE completion:nil]; }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
