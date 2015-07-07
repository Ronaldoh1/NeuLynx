//
//  RequestCustomCell.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/5/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutParticipant;

@end
