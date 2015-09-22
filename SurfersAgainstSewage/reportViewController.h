//
//  reportViewController.h
//  SurfersAgainstSewage
//
//  Created by Dan Clarke on 28/09/2014.
//  Copyright (c) 2014 Dan Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reportViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIScrollView *scrollView;
    UIButton *beachBtn;
    UIPickerView *beachPicker;
    
    NSMutableDictionary *ourData;
    NSString *ourType;
    NSArray *sortedList;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil data:(NSMutableDictionary *)data;

@end
