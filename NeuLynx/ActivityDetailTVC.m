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

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self performInitialSetUp];
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

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = selectedActivity.activityTitle;
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Make user profile circular
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.height/2;
    self.userProfileImageView.layer.masksToBounds = YES;
    self.userProfileImageView.layer.borderWidth = 0;

    //Set up user's name label
    self.userNameLabel.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];

    //Set up user's gender and orientation label
    self.genderAndOrientationLabel.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];

    //set the title of the activity

    self.ActivityTitleLabel.text = selectedActivity.activityTitle;
    self.ActivityTitleLabel.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];

    //add borders to the textView
    self.activityDescriptionText.layer.borderWidth = 4.0f;
    self.activityDescriptionText.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;

    //Initially set the flags to 0.4 alpha and change them based on host actual langauges.
    self.portugueseFlag.alpha = 0.3;
    self.americanFlag.alpha = 0.3;
    self.spanishFlag.alpha = 0.3;
    self.frenchFlag.alpha = 0.3;

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


    //Display activity images

    PFFile *image1PFFIle = [PFFile new];

    image1PFFIle = selectedActivity.activityImage1;

    [image1PFFIle getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        self.image1.image = [UIImage imageWithData:data];

    }];

    PFFile *image2PFFIle = [PFFile new];

    image2PFFIle = selectedActivity.activityimage2;

    [image2PFFIle getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        self.image2.image = [UIImage imageWithData:data];

    }];


    //Display rate flags for the user.
    RateView* rv = [RateView rateViewWithRating:3.7f];
    rv.starFillColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1];
    rv.frame = CGRectMake(115, 235, 150, 30);

    [self.view addSubview:rv];




}

///*************ACTION BUTTONS***************************//

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
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




    selectedActivity.numberOfpaticipants = @([selectedActivity.numberOfpaticipants integerValue] + 1);
    //add current user to the request.



    [tempActivityArray addObject:[User currentUser]];

        selectedActivity.RequestsArray = tempActivityArray.copy;

    [selectedActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {



            // Create our Installation query
            PFQuery *pushQuery = [PFInstallation query];
            // only return Installations that belong to a User that
            // matches the innerQuery
            [pushQuery whereKey:@"user" matchesQuery: selectedActivity.host];

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


#pragma mark - Table view data source

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 3) {
        return indexPath;
    } else {
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //firt thing we want to do is deselect the cell.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    //the next thing we want to do is handle the user's selections.
    //initialize the social media view controller

    self.activitySL = [[SLComposeViewController alloc]init];

    if (indexPath.section == 3 && indexPath.row == 0) {


        //        self.activitySL = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        //        [self.activitySL setInitialText:[NSString stringWithFormat:@"Hey, I just found the following activity on NeuLynx Check it out hope you can join me! . %@ - %@. ", self.ActivityTitleLabel.text, self.activityDescriptionText.text]];
        //        [self presentViewController:self.activitySL animated:YES completion:nil];
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:@"http://developers.facebook.com"];
        content.contentDescription = [NSString stringWithFormat:@"Hey, I just found the following activity on NeuLynx Check it out hope you can join me! . %@ - %@. ", self.ActivityTitleLabel.text, self.activityDescriptionText.text];

        FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
        //shareDialog.delegate = self;
        shareDialog.fromViewController = self;
        shareDialog.shareContent = content;
        [shareDialog show];

    }else if (indexPath.section == 3 && indexPath.row == 1){
        //Share Information on Twitter

        self.activitySL = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [self.activitySL setInitialText:[NSString stringWithFormat:@"Hey, I just found the following activity on NeuLynx Check it out hope you can join me! . %@ - %@. ", self.ActivityTitleLabel.text, self.activityDescriptionText.text]];
        [self presentViewController:self.activitySL animated:YES completion:nil];
    }else if (indexPath.section == 3 && indexPath.row == 2){
        //Share Information on WhatsApp
        NSString * msg = [NSString stringWithFormat:@"Hey, I just found the following activity on NeuLynx Check it out hope you can join me! . %@ - %@. ", self.ActivityTitleLabel.text, self.activityDescriptionText.text];
        NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
        NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
            [[UIApplication sharedApplication] openURL: whatsappURL];
        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }

    }

}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{

}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{

}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//helper method to display error message
-(void)displayErrorMessage{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Request Already Sent!" message:@"You have already sent a request to join this Activity!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alertView show];
}

@end
