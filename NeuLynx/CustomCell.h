//
//  CustomCell.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/4/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *activityDescriptionText;
@property (weak, nonatomic) IBOutlet UILabel *distanceToActivityLabel;

@end
