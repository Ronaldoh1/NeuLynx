//
//  OldActitvityTVCTableViewController.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/21/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "OldActitvityTVC.h"
#import <RateView.h>
#import "Activity.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface OldActitvityTVC ()

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

@end

@implementation OldActitvityTVC

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
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = selectedActivity.activityTitle;
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Make user profile circular
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height/2;

    self.userProfileImageView.layer.masksToBounds = YES;
    self.userProfileImageView.layer.borderWidth = 4.0;
    self.userProfileImageView.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;
    //Set up user's name label
    self.userNameLabel.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];

    //Set up user's gender and orientation label
    self.genderAndOrientationLabel.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];

    //set the title of the activity

    self.ActivityTitleLabel.text = selectedActivity.activityTitle;
    self.ActivityTitleLabel.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];

    //Initially set the flags to 0.4 alpha and change them based on host actual langauges.
    self.portugueseFlag.alpha = 0.3;
    self.americanFlag.alpha = 0.3;
    self.spanishFlag.alpha = 0.3;
    self.frenchFlag.alpha = 0.3;

    //Display the host information
    PFFile *profileImagePFFIle = [PFFile new];

    profileImagePFFIle =  selectedActivity.host.profileImage;

    [profileImagePFFIle getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{

            self.userProfileImageView.image = [UIImage imageWithData:data];

        });


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

    //number of participants
    self.numberOfPeopleLabel.text = [NSString stringWithFormat:@"%@ of %@ joined!", selectedActivity.numberOfpaticipants, selectedActivity.maxNumberOfParticipants];

    //Activity type.
    if ([selectedActivity.isLBGT integerValue] == 1) {
        self.typeActivityLabel.text = [NSString stringWithFormat:@"Type: LGBT"];
    } else {
        self.typeActivityLabel.text = [NSString stringWithFormat:@"Type: Any"];
    }

    //Display activity images

    PFFile *image1PFFIle = [PFFile new];

    image1PFFIle = selectedActivity.activityImage1;

    [image1PFFIle getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {



        dispatch_async(dispatch_get_main_queue(), ^{

            self.image1.image = [UIImage imageWithData:data];

        });

    }];

    PFFile *image2PFFIle = [PFFile new];

    image2PFFIle = selectedActivity.activityimage2;

    [image2PFFIle getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{


            self.image2.image = [UIImage imageWithData:data];

        });


    }];


    //Display rate flags for the user.
    RateView* rv = [RateView rateViewWithRating:3.7f];
    rv.starFillColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1];
    rv.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 3.3, 235, 150, 30);

    [self.view addSubview:rv];

    //hide cancel button

    self.navigationItem.leftBarButtonItem = nil;


}


- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 3 || indexPath.section == 4) {
        return indexPath;
    } else {
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //first thing we want to do is deselect the cell.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
}


//helper method to display error message
-(void)displayErrorMessage{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Request Already Sent!" message:@"You have already sent a request to join this Activity!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertView show];
}

@end
