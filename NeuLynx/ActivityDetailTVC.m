
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
#import "SocialTracker.h"

@interface ActivityDetailTVC ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightNavBarButton;


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

@property (nonatomic, strong) Activity  *selectedActivity;


//Keeping track of social involvement
@property (nonatomic, strong) SocialTracker *socialTracker;
@property (nonatomic, strong) IBOutlet UIImageView *userBadge;

@end

@implementation ActivityDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self performInitialSetUp];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];

    [self displayBadgeForUser:(User *)self.selectedActivity.host];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)performInitialSetUp{
    //Display the user information

    //1. Get the activity that user selected.
    Activity *selectedActivity = [Activity new];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    selectedActivity = appDelegate.sharedActivity;
    self.selectedActivity = [Activity new];
    self.selectedActivity = selectedActivity;

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
    self.numberOfPeopleLabel.text = [NSString stringWithFormat:@"%@ of %@ are attending!", selectedActivity.numberOfpaticipants, selectedActivity.maxNumberOfParticipants];

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


//    //Display rate flags for the user.
//    RateView* rv = [RateView rateViewWithRating:3.7f];
//    rv.starFillColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1];
//    rv.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 3.3, 235, 150, 30);
//
//    [self.view addSubview:rv];



    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MMMM dd yyyy @ hh:mm aaa"]; //a,aa or aa all will work.
    NSString *startDate = [myDateFormatter stringFromDate:selectedActivity.startTimeAndDate];
    NSString *endDate = [myDateFormatter stringFromDate:selectedActivity.endTimeAndDate];


    self.timeLabel.text = [NSString stringWithFormat:@"Start Time: %@ \n End Time: %@", startDate, endDate];

    self.locationLabel.text = [NSString stringWithFormat: @"Location: %@", selectedActivity.activityAddress];



}



///*************ACTION BUTTONS***************************//
- (IBAction)onProfileImageTapped:(UIButton *)sender {

    User *user = [User new];


    user = (User *)self.selectedActivity.host;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


    appDelegate.selectedUser = user;

    UIStoryboard *UserDetailStoryboard = [UIStoryboard storyboardWithName:@"UserDetail" bundle:nil];
    UINavigationController *userDetailNavVC = [UserDetailStoryboard instantiateViewControllerWithIdentifier:@"userDetailNavVC"];

    [self presentViewController:userDetailNavVC animated:YES completion:nil];



}

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {


    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        ExclusiveInvite *exclusivInvite = [ExclusiveInvite new];
        exclusivInvite = appDelegate.exclusiveInvite;

        if (exclusivInvite != nil) {

            exclusivInvite.isDispositioned = @0;
        }

    }];
}

- (IBAction)onJoinButtonTapped:(UIBarButtonItem *)sender {

    //1. Get the activity that user selected.
    Activity *selectedActivity = [Activity new];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    selectedActivity = appDelegate.sharedActivity;

    NSMutableArray *tempActivityArray = [NSMutableArray arrayWithArray:selectedActivity.RequestsArray];




    //check if the current user has already sent a request.

    if ([tempActivityArray containsObject:[User currentUser]]) {

        [self displayErrorMessage];



    }else {

        //we want to disposition the exclusive invite.
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        ExclusiveInvite *exclusivInvite = [ExclusiveInvite new];
        exclusivInvite = appDelegate.exclusiveInvite;

        if (exclusivInvite != nil) {

            exclusivInvite.isDispositioned = @1;

            [exclusivInvite saveInBackground];



            selectedActivity.numberOfpaticipants = @([selectedActivity.numberOfpaticipants integerValue] + 1);


            //add current user to the request.

            [tempActivityArray addObject:[User currentUser]];

            selectedActivity.RequestsArray = tempActivityArray.copy;

            [selectedActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {

                    self.rightNavBarButton.enabled = NO;

                    // Create our Installation query
                    PFQuery *pushQuery = [PFInstallation query];
                    // only return Installations that belong to a User that

                    [pushQuery whereKey:@"user" equalTo:selectedActivity.host];
                    
                    // Send push notification to query
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery]; // Set our Installation query
                    [push setMessage:[NSString stringWithFormat:@"%@ has requested to join your exclusive invite. Please check your Requests to confirm.", [User currentUser].name]];
                    [push sendPushInBackground];




                    [self dismissViewControllerAnimated:YES completion:nil];

                } else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was an error sending your request. Please try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];

                }
            }];




        }else{




            //get the number of participants

            selectedActivity.numberOfpaticipants = @([selectedActivity.numberOfpaticipants integerValue] + 1);


            //add current user to the request.

            [tempActivityArray addObject:[User currentUser]];

            selectedActivity.RequestsArray = tempActivityArray.copy;

            [selectedActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {

                    //diable right bar button item

                    self.rightNavBarButton.enabled = NO;

                    // Create our Installation query
                    PFQuery *pushQuery = [PFInstallation query];
                    // only return Installations that belong to a User that

                    [pushQuery whereKey:@"user" equalTo:selectedActivity.host];

                    // Send push notification to query
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery]; // Set our Installation query
                    [push setMessage:[NSString stringWithFormat:@"%@ has requested to join your activity. Please check your Requests to review this request", [User currentUser].name]];
                    [push sendPushInBackground];



                    [self dismissViewControllerAnimated:YES completion:nil];

                } else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was an error sending your request. Please try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];

                }
            }];

        }
    }

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

    //the next thing we want to do is handle the user's selections.
    //initialize the social media view controller

    self.activitySL = [[SLComposeViewController alloc]init];

    if (indexPath.section == 3 && indexPath.row == 0) {


        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:@"http://developers.facebook.com"];
        content.contentDescription = [NSString stringWithFormat:@"Hey, I just found the following activity on NeuLynx Check it out hope you can join me! . %@ - %@. ", self.ActivityTitleLabel.text, self.activityDescriptionText.text];

        FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
        //shareDialog.delegate = self;
        shareDialog.fromViewController = self;
        shareDialog.shareContent = content;
        [shareDialog show];

        //Update Social involvement

        if ([User currentUser] != nil) {

        self.socialTracker = [SocialTracker new];
        self.socialTracker.points = @1;
        self.socialTracker.pointsOwner = [User currentUser];
        [self.socialTracker saveInBackground];

        }

    }else if (indexPath.section == 3 && indexPath.row == 1){
        //Share Information on Twitter

        self.activitySL = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [self.activitySL setInitialText:[NSString stringWithFormat:@"Hey, I just found the following activity on @NeuLynx Check it out hope you can join me! . %@ - %@. ", self.ActivityTitleLabel.text, self.activityDescriptionText.text]];
        [self presentViewController:self.activitySL animated:YES completion:^{
            //Update Social involvement


            if ([User currentUser] != nil) {

                self.socialTracker = [SocialTracker new];
                self.socialTracker.points = @1;
                self.socialTracker.pointsOwner = [User currentUser];
                [self.socialTracker saveInBackground];
                
            }

        }];
    }else if (indexPath.section == 3 && indexPath.row == 2){
        //Share Information on WhatsApp
        NSString * msg = [NSString stringWithFormat:@"Hey, I just found the following activity on NeuLynx Check it out hope you can join me! . %@ - %@. ", self.ActivityTitleLabel.text, self.activityDescriptionText.text];
        NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
        NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
            [[UIApplication sharedApplication] openURL: whatsappURL];

            //Update Social involvement

            if ([User currentUser] != nil) {

                self.socialTracker = [SocialTracker new];
                self.socialTracker.points = @1;
                self.socialTracker.pointsOwner = [User currentUser];
                [self.socialTracker saveInBackground];
                
            }


        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else if(indexPath.section == 4 && indexPath.row == 0){


        [self.selectedActivity fetchInBackground];

        NSNumber *tempNumber = self.selectedActivity.flagCount;


        self.selectedActivity.flagCount = [NSNumber numberWithInteger:[tempNumber integerValue] + 1];

        [self.selectedActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){

            if (succeeded) {

                [self dismissViewControllerAnimated:YES completion:^{
                    [self displayAlertMessage:@"Flagged for Removal" andWith:@"Activity has been Flagged for removal - Thank you for helping us!"];
                }];

            }

        }];
    }
    

}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
}


////////////////*****************HELPER METHODS************************///////////////////
//display alert method
-(void)displayAlertWithTitle:(NSString *)title andWith:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:[NSString stringWithFormat:@"Error %@", [error description]]
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
}

-(void)displayAlertMessage:(NSString *)title andWith:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
}

//helper method to display error message
-(void)displayErrorMessage{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Request Already Sent!" message:@"You have already sent a request to join this Activity!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alertView show];
}

-(void)displayBadgeForUser:(User *)user{


    PFQuery *query = [PFQuery queryWithClassName:@"SocialTracker"];

    [query whereKey:@"pointsOwner" equalTo:user];


    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){

        // NSArray *activitiesArray = activities;
        if (!error) {
            //get a copy of all activities
            // Add activities to the map.
            int sum = 0;

            for (SocialTracker  *obj in array) {

                sum = sum + [(obj.points) intValue];

            }



            NSLog(@"%d", sum);

            dispatch_async(dispatch_get_main_queue(), ^{

                if(sum == 0){
                    self.userBadge.image = nil;
                }else if(sum >= 25 && sum<= 74){
                    self.userBadge.image = [UIImage imageNamed:@"bronzeSocial.png"];
                }else if (sum >= 75 && sum <= 119) {
                    self.userBadge.image = [UIImage imageNamed:@"silverSocial.png"];

                }else if(sum >= 120 && sum <= 149){
                    self.userBadge.image = [UIImage imageNamed:@"goldSocial.png"];
                    
                }else if(sum >= 150){
                    self.userBadge.image = [UIImage imageNamed:@"platinumSocial.png"];
                    
                }
                
                
                
            });
            
        }
    }];
}

@end