//
//  listViewController.h
//  SurfersAgainstSewage
//
//  Created by Dan Clarke on 11/07/2014.
//  Copyright (c) 2014 Dan Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyInternet.h"

@interface listViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	NSMutableDictionary *ourData;
    NSString *ourType;
    NSArray *sortedList;
    LazyInternet *initalDownload;
	
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil data:(NSMutableDictionary *)data; 

@end

