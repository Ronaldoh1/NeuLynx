//
//  CustomCell.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/4/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code

    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height/2;
    self.userProfileImage.layer.masksToBounds = YES;
    self.userProfileImage.layer.borderWidth = 4.0;
    self.userProfileImage.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
