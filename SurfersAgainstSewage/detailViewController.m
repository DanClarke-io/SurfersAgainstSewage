//
//  listViewController.m
//  SurfersAgainstSewage
//
//  Created by Dan Clarke on 11/07/2014.
//  Copyright (c) 2014 Dan Clarke. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@end

@implementation detailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil data:(NSMutableDictionary *)data {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if(self) {
        ourData = data;
        NSLog(@"Our data set with %@ records",ourData);
    }
    return self;
}
            
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self setTitle:[ourData objectForKey:@"title"]];
    CGFloat mapHeight = 200;
    CGRect mapFrame = self.view.bounds;
    mapFrame.size.height = mapHeight;
    
    mapBackView = [[UIView alloc] initWithFrame:mapFrame];
    [mapBackView setBackgroundColor:[UIColor blackColor]];
    [[self view] addSubview:mapBackView];
    
    mapView = [[MKMapView alloc] initWithFrame:mapFrame];
    [mapView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    
    [[self view] addSubview:mapView];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[ourData objectForKey:@"loc1"] floatValue];
    zoomLocation.longitude= [[ourData objectForKey:@"loc2"] floatValue];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    
    [mapView setRegion:viewRegion animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:zoomLocation];
    [annotation setTitle:[ourData objectForKey:@"name"]]; //You can set the subtitle too
    [mapView addAnnotation:annotation];
    
    
    textFrame = self.view.bounds;
    textFrame.size.height -= mapHeight;
    textFrame.origin.y = mapHeight;
    scrollView = [[UIScrollView alloc] initWithFrame:textFrame];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"infoBack"]]];
    [scrollView setDelegate:self];
    [[self view] addSubview:scrollView];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat fullWidth = self.view.frame.size.width;
    
    UIView *titleHead = [[UIView alloc] initWithFrame:CGRectMake(0, -1, fullWidth, 47)];
    [titleHead setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleHeader"]]];
    [scrollView addSubview:titleHead];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, fullWidth-40, 30)];
    [titleLabel setText:[ourData objectForKey:@"name"]];
    [titleLabel setNumberOfLines:3];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleLabel sizeToFit];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [scrollView addSubview:titleLabel];
    [self autoUpdateScrollView:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, [self updateScrollHeight:titleLabel], fullWidth-40, 30)];
    [descriptionLabel setText:[ourData objectForKey:@"desc"]];
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setFont:[UIFont systemFontOfSize:15]];
    [descriptionLabel sizeToFit];
    [descriptionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [scrollView addSubview:descriptionLabel];
    [self autoUpdateScrollView:descriptionLabel];
    
    UILabel *updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, [self updateScrollHeight:descriptionLabel], fullWidth-40, 30)];
    [updateLabel setText:[NSString stringWithFormat:@"Last updated: %@",[ourData objectForKey:@"updated"]]];
    [updateLabel setNumberOfLines:0];
    [updateLabel setFont:[UIFont systemFontOfSize:12]];
    [updateLabel sizeToFit];
    [updateLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [scrollView addSubview:updateLabel];
    [self autoUpdateScrollView:updateLabel];
    
    UIButton *directionsBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, [self updateScrollHeight:updateLabel], (fullWidth-60)/2, 50)];
    [directionsBtn setTitle:@"Directions" forState:UIControlStateNormal];
    [directionsBtn addTarget:self action:@selector(getDirections) forControlEvents:UIControlEventTouchUpInside];
    [directionsBtn setBackgroundColor:[UIColor colorWithRed:0.877 green:0.243 blue:0.160 alpha:1.000]];
    [directionsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[directionsBtn layer] setCornerRadius:5];
    [directionsBtn setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [scrollView addSubview:directionsBtn];
    [self autoUpdateScrollView:directionsBtn];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(((fullWidth-60)/2)+40, [self updateScrollHeight:updateLabel], (fullWidth-60)/2, 50)];
    [shareBtn setTitle:@"Share" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(getShare) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundColor:[UIColor colorWithRed:0.072 green:0.241 blue:0.253 alpha:1.000]];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[shareBtn layer] setCornerRadius:5];
    [shareBtn setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [scrollView addSubview:shareBtn];
    [self autoUpdateScrollView:shareBtn];
    
    if([[ourData objectForKey:@"data-type"] isEqualToString:@"sewages"]) {
        int x = 0;
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* filePath = [docsDir stringByAppendingPathComponent: @"list.plist"];
        NSMutableDictionary *mainData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        NSString *affects = [[NSString alloc] init];
        
        while(x<[[ourData objectForKey:@"beaches affected"] count]) {
            NSMutableDictionary *ourBeach = [[mainData objectForKey:@"beaches"] objectForKey:[NSString stringWithFormat:@"%ld",(long)[[[ourData objectForKey:@"beaches affected"] objectAtIndex:x] integerValue]]];
            affects = [affects stringByAppendingString:[NSString stringWithFormat:@"Affects: %@\n",[ourBeach objectForKey:@"name"]]];
            
            CLLocationCoordinate2D zoomLocation;
            zoomLocation.latitude = [[ourBeach objectForKey:@"loc1"] floatValue];
            zoomLocation.longitude= [[ourBeach objectForKey:@"loc2"] floatValue];
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:zoomLocation];
            [annotation setTitle:[NSString stringWithFormat:@"Affects: %@\n",[ourBeach objectForKey:@"name"]]]; //You can set the subtitle too
            [mapView addAnnotation:annotation];
            x++;
        }
        
        UILabel *beachLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, scrollView.contentSize.height, fullWidth-40, 30)];

        [beachLabel setText:affects];
        [beachLabel setNumberOfLines:0];
        [beachLabel setFont:[UIFont systemFontOfSize:12]];
        [beachLabel sizeToFit];
        [updateLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [scrollView addSubview:beachLabel];
        [self autoUpdateScrollView:beachLabel];
    }
    
    loadGoogleName = [[LazyInternet alloc] init];
    [loadGoogleName startDownload:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true_or_false",[ourData objectForKey:@"loc1"],[ourData objectForKey:@"loc2"]] withDelegate:self withUnique:loadGoogleName];

}


-(void)getDirections {
    NSString *Destinationlatlong =[NSString stringWithFormat:@"%@,%@",[ourData objectForKey:@"loc1"],[ourData objectForKey:@"loc2"]];
    NSString *addr = [NSString stringWithFormat:@"https://maps.apple.com/maps?saddr=Current+Location&daddr=%@",Destinationlatlong];
    addr = [addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [[NSURL alloc] initWithString:addr];
    if ([[UIApplication sharedApplication]canOpenURL:url]) { [[UIApplication sharedApplication] openURL:url]; }
    else{  NSLog(@"Locations not supported on this device"); }
}


-(void)getShare {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Surfers Against Sewage" message:@"Share currently not enabled." delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];

}

-(CGFloat)updateScrollHeight:(UIView *)view { return view.frame.size.height+view.frame.origin.y+20; }
-(void)autoUpdateScrollView:(UIView *)view { [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, [self updateScrollHeight:view])]; }

-(void)scrollViewDidScroll:(UIScrollView *)sv {
    CGRect newFrame = sv.frame;
    newFrame.origin.y = sv.frame.origin.y-sv.contentOffset.y;
    CGFloat calc = (sv.frame.size.height-sv.contentOffset.y)+sv.contentOffset.y;
    if(sv.contentSize.height>self.view.frame.size.height) {
        if((sv.contentOffset.y<0 && sv.frame.origin.y==textFrame.origin.y) || (sv.frame.origin.y==0 && sv.frame.size.height==calc && sv.contentOffset.y>0)) {
            CGRect newMapFrame = mapView.frame;
            newMapFrame.origin.y = 0;
            [mapView setFrame:newMapFrame];
            [mapView setZoomEnabled:TRUE];
        }
        else if(sv.frame.origin.y>0 && sv.frame.origin.y<=textFrame.origin.y) {
            if(sv.contentSize.height>sv.frame.size.height) {
                CGFloat alphaCalc = (((mapView.alpha*100)-(sv.contentOffset.y/2)))/100;
                [mapView setAlpha:alphaCalc];
                [mapView setZoomEnabled:FALSE];
                CGRect newMapFrame = mapView.frame;
                newMapFrame.origin.y -= sv.contentOffset.y/3;
                [mapView setFrame:newMapFrame];
                newFrame.size.height = self.view.bounds.size.height-newFrame.origin.y; [sv setFrame:newFrame];
            }
            
        }
        else {
            if(sv.frame.origin.y<=0 && sv.contentOffset.y>0) { newFrame.origin.y = 0; newFrame.size.height = self.view.frame.size.height; [sv setFrame:newFrame]; }
            else if(sv.frame.origin.y<textFrame.origin.y) {  [sv setFrame:newFrame]; }
            else { newFrame.origin.y = textFrame.origin.y; [sv setFrame:newFrame]; }
        }
        if(newFrame.origin.y>0 && sv.contentOffset.y>0) { [sv setContentOffset:CGPointMake(sv.contentOffset.x, 0)]; }
        if(mapView.alpha<0.2) { [mapView setAlpha:0.2]; } else if(mapView.alpha>1) { [mapView setAlpha:1]; }
        if(mapView.frame.origin.y>0) { CGRect newMapFrame = mapView.frame; newMapFrame.origin.y = 0; [mapView setFrame:newMapFrame]; }
    }
    
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath { [tv deselectRowAtIndexPath:indexPath animated:TRUE]; }


- (void)lazyInternetDidLoad:(NSData*)data withUnique:(id)unique {
    if(unique==loadGoogleName) {
        NSError *error;
        NSMutableDictionary *googleBack = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if(error) { NSLog(@"Error parsing reply from Google: %@",error); }
        else {
            //NSLog(@"%@",[[googleBack objectForKey:@"results"] objectAtIndex:1]);
            if([[googleBack objectForKey:@"results"] count]>0) {
                NSString *finalLocation = [[[googleBack objectForKey:@"results"] objectAtIndex:1] objectForKey:@"formatted_address"];
                googleBack = nil;
                NSLog(@"%@",finalLocation);
            }
        }
    }
}

- (void)lazyInternetDidFailWithError:(NSError *)error withUnique:(id)unique { NSLog(@"Did fail %@",error); }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
