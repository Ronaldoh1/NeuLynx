//
//  ActivityDetailTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/1/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "ActivityDetailTVC.h"
#import <RateView.h>
#import "Activity.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
@interface ActivityDetailTVC ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderAndOrientationLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeActivityLabel;

//Languages
@property (weak, nonatomic) IBOutlet UIImageView *portugueseFlag;
@property (weak, nonatomic) IBOutlet UIImageView *americanFlag;
@property (weak, nonatomic) IBOutlet UIImageView *spanishFlag;
@property (weak, nonatomic) IBOutlet UIImageView *frenchFlag;


//Activity Information
@property (weak, nonatomic) IBOutlet UILabel *ActivityTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleLabel;
@property (weak, nonatomic) IBOutlet UITextView *activityDescriptionText;

//Activity Images

@property (weak, nonatomic) IBOutlet UIImageView *image1;

@property (weak, nonatomic) IBOutlet UIImageView *image2;

//Sharing on Social Media
@property SLComposeViewController *activitySL;

@end

@implementation ActivityDetailTVC



@end
