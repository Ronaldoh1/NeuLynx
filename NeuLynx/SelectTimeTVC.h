//
//  SelectTimeVC.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/3/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface SelectTimeTVC : UITableViewController

@property Activity *activity;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property NSDate *startDateAndTime;
@property NSDate *endDateAndTime;

@end
