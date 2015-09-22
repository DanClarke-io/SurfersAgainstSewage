//
//  listViewController.h
//  SurfersAgainstSewage
//
//  Created by Dan Clarke on 11/07/2014.
//  Copyright (c) 2014 Dan Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LazyInternet.h"

#define METERS_PER_MILE 1609.344

@interface detailViewController : UIViewController <UIScrollViewDelegate> {
    NSMutableDictionary *ourData;
    UIScrollView *scrollView;
    LazyInternet *loadGoogleName;
    CGRect textFrame;
    UIPanGestureRecognizer *scrollPanRecognizer;
    MKMapView *mapView;
    UIView *mapBackView;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil data:(NSMutableDictionary *)data; 

@end

