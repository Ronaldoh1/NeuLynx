//
//  HistoryCustomCellTableViewCell.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/19/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *activityDescriptionText;
@property (weak, nonatomic) IBOutlet UILabel *distanceToActivityLabel;

@end
