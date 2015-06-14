//
//  DetailVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "DetailVC.h"
#import <RateView.h>
#import "Activity.h"
#import "AppDelegate.h"

@interface DetailVC ()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderAndOrientationLabel;

//Languages
@property (weak, nonatomic) IBOutlet UIImageView *portugueseFlag;
@property (weak, nonatomic) IBOutlet UIImageView *americanFlag;
@property (weak, nonatomic) IBOutlet UIImageView *spanishFlag;
@property (weak, nonatomic) IBOutlet UIImageView *frenchFlag;


//Activity Information

@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleLabel;
@property (weak, nonatomic) IBOutlet UITextView *activityDescriptionText;



@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performInitialSetUp];
}

-(void)performInitialSetUp{
    //Display the user information

    //1. Get the activity that user selected.
    Activity *selectedActivity = [Activity new];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    selectedActivity = appDelegate.sharedActivity;

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = selectedActivity.activityTitle;
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Make user profile circular
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height/2;
    self.userProfileImageView.layer.masksToBounds = YES;
    self.userProfileImageView.layer.borderWidth = 0;



    //Initially set the flags to 0.4 alpha and change them based on host actual langauges.
    self.portugueseFlag.alpha = 0.4;
    self.americanFlag.alpha = 0.4;
    self.spanishFlag.alpha = 0.4;
    self.frenchFlag.alpha = 0.4;

    //Display the host information
    PFFile *profileImagePFFIle = [PFFile new];
    
    profileImagePFFIle =  selectedActivity.host.profileImage;

    [profileImagePFFIle getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

    self.userProfileImageView.image = [UIImage imageWithData:data];

    }];


    self.userNameLabel.text = selectedActivity.host.name;
    self.genderAndOrientationLabel.text = [NSString stringWithFormat:@"%@, %@", selectedActivity.host.gender, selectedActivity.host.orientation];

    NSArray *languageArray = selectedActivity.host.languageArray.copy;

        for (int i = 0; i<languageArray.count; i++) {
        if ([languageArray[i] isEqualToString:@"Portuguese"]) {
            self.portugueseFlag.alpha = 1.0;

        }else if([languageArray[i] isEqualToString:@"Spanish"]){
            self.spanishFlag.alpha = 1.0;


        }else if([languageArray[i] isEqualToString:@"English"]){
            self.americanFlag.alpha = 1.0;

        }else if([languageArray[i] isEqualToString:@"French"]){
            self.frenchFlag.alpha = 1.0;
            
        }
        
    }


        //self.activityTitleLabel.text = selectedActivity.activityTitle;
    self.activityDescriptionText.tintColor = [UIColor whiteColor];

    self.activityDescriptionText.text = selectedActivity.activityDescription;

    if (selectedActivity.numberOfpaticipants == nil) {
        selectedActivity.numberOfpaticipants = 0;
    }
    self.numberOfPeopleLabel.text = [NSString stringWithFormat:@"%@ of %@ are attending!", selectedActivity.numberOfpaticipants, selectedActivity.maxNumberOfParticipants];



    //Display rate flags for the user.
    RateView* rv = [RateView rateViewWithRating:3.7f];
    rv.starFillColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    rv.frame = CGRectMake(115, 277, 150, 30);

    [self.view addSubview:rv];




}

///*************ACTION BUTTONS***************************//

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onJoinButtonTapped:(UIBarButtonItem *)sender {

}


@end
