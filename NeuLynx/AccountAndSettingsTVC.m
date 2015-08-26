//
//  AccountAndSettingsTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/27/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "AccountAndSettingsTVC.h"
#import "User.h"


#import "AppDelegate.h"


@interface AccountAndSettingsTVC ()<CLLocationManagerDelegate>
//User
@property User *currentUser;


//Location
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSString *userCity;

//section 1 - profile image
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userBadge;

@end

@implementation AccountAndSettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performInitialSetUp];
}
-(void)viewWillAppear:(BOOL)animated{


    [self displayBadgeForUser:[User currentUser]];

}
-(void)performInitialSetUp{

    //get Current User
    self.currentUser = [User currentUser];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:25];
    titleView.text = self.currentUser.name;
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Get User's location
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    //get user's location and display it.
    self.locationLabel.text = [NSString stringWithFormat:@"%@ %@, %@", self.currentUser.userCurrentCity, self.currentUser.userAdministrativeArea, self.currentUser.userCountryCode];
    self.locationLabel.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];

    //Make profile image round.
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 4.0;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;

    //Get profile image
    [self getUsersProfileImage];


    //Set up badge for current user.
    if ([[User currentUser].activitiesJoinedCounter intValue] == 0) {
        self.userBadge.image = nil;
    }else if ([[User currentUser].activitiesJoinedCounter intValue] > 5){
        self.userBadge.image = [UIImage imageNamed:@"bronzeSocial"];
    }else if ([[User currentUser].activitiesJoinedCounter intValue] > 10){
        self.userBadge.image = [UIImage imageNamed:@"platinumSocial"];
    }else if ([[User currentUser].activitiesJoinedCounter intValue] > 25){
        self.userBadge.image = [UIImage imageNamed:@"silverSocial"];
    }else if ([[User currentUser].activitiesJoinedCounter intValue] > 50){
        self.userBadge.image = [UIImage imageNamed:@"Social"];
    }

//    //if requests is clicked, then show done button
////    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////    BOOL tmpBool = appDelegate.hideDoneButtonForRequests;
//
//
//    tmpBool = NO;
//    appDelegate.hideDoneButtonForRequests = nil;

    //Add right bar button item
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDoneButtonTapped)];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    [self displayBadgeForUser:[User currentUser]];
    
}

#pragma Marks - Buttons 

- (IBAction)onViewProfileButtonTapped:(id)sender {

    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];

    [self presentViewController:profileNavVC animated:YES completion:nil];

}
- (IBAction)onSignOutButtonTapped:(id)sender {
    [User logOut];

    self.navigationItem.leftBarButtonItem.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
    
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mapNavVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mapNavVC animated:YES completion:nil];
}

#pragma mark - UITableView Delegate Methods
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0 && indexPath.section == 0) {
        return nil;
    }else if (indexPath.row == 8 && indexPath.section == 5) {
        return nil;
    } else {
        return indexPath;
    }

}

//the following method  handles the different actions/events to take the user to the appropriate screen.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //first we need to deselect the cell.

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 1) {

        UIStoryboard *mailStoryboard = [UIStoryboard storyboardWithName:@"Mail" bundle:nil];
        UITabBarController *mailNavVC = [mailStoryboard instantiateViewControllerWithIdentifier:@"mailNavVC"];
        [self presentViewController:mailNavVC animated:YES completion:nil];

    }else if(indexPath.row == 1 && indexPath.section == 1){
        UIStoryboard *requestStoryBoard = [UIStoryboard storyboardWithName:@"Request" bundle:nil];
        UITabBarController *requestVC = [requestStoryBoard instantiateViewControllerWithIdentifier:@"RequestNavVC"];
        [self presentViewController:requestVC animated:YES completion:nil];

    }else if(indexPath.row == 2 && indexPath.section == 1){
        UIStoryboard *historyStoryBoard = [UIStoryboard storyboardWithName:@"History" bundle:nil];
        UINavigationController *historyNavVC = [historyStoryBoard instantiateViewControllerWithIdentifier:@"HistoryNavVC"];
        [self presentViewController:historyNavVC animated:YES completion:nil];

    }else if(indexPath.row == 3 && indexPath.section == 1){
        UIStoryboard *searchActivity = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
        UINavigationController *searchNavVC = [searchActivity instantiateViewControllerWithIdentifier:@"SearchNavVC"];
        [self presentViewController:searchNavVC animated:YES completion:nil];


    }else if(indexPath.row == 4 && indexPath.section == 1){
        UIStoryboard *exclusiveStoryboard = [UIStoryboard storyboardWithName:@"Exclusive" bundle:nil];
        UINavigationController *exclusiveTVC = [exclusiveStoryboard instantiateViewControllerWithIdentifier:@"exclusiveTVC"];
        [self presentViewController:exclusiveTVC animated:YES completion:nil];

        
    }else if(indexPath.row == 0 && indexPath.section == 2){
        UIStoryboard *helpStoryboard = [UIStoryboard storyboardWithName:@"Help" bundle:nil];
        UINavigationController *helpNavVC = [helpStoryboard instantiateViewControllerWithIdentifier:@"helpNavVC"];
        [self presentViewController:helpNavVC animated:YES completion:nil];

    }else if(indexPath.row == 0 && indexPath.section == 3){
        UIStoryboard *faqStoryBoard = [UIStoryboard storyboardWithName:@"Faq" bundle:nil];
        UINavigationController *faqNavVC = [faqStoryBoard instantiateViewControllerWithIdentifier:@"faqNavVC"];
        [self presentViewController:faqNavVC animated:YES completion:nil];

    }else if(indexPath.row == 1 && indexPath.section == 3){
        UIStoryboard *aboutStoryBoard = [UIStoryboard storyboardWithName:@"About" bundle:nil];
        UINavigationController *aboutNavVC = [aboutStoryBoard instantiateViewControllerWithIdentifier:@"aboutNavVC"];
        [self presentViewController:aboutNavVC animated:YES completion:nil];

    }else if(indexPath.row == 2 && indexPath.section == 3){
        UIStoryboard *termsAndConditionsStoryBoard = [UIStoryboard storyboardWithName:@"TermsAndConditions" bundle:nil];
        UINavigationController *termsAndConditionsNavVC = [termsAndConditionsStoryBoard instantiateViewControllerWithIdentifier:@"TermsAndConditionsNavVC"];
        [self presentViewController:termsAndConditionsNavVC animated:YES completion:nil];
        
    }else if(indexPath.row == 0 && indexPath.section == 4){

        UIStoryboard *bugStoryBoard = [UIStoryboard storyboardWithName:@"bugReport" bundle:nil];
        UINavigationController *bugReportNavVC = [bugStoryBoard instantiateViewControllerWithIdentifier:@"bugReportNavVC"];
        [self presentViewController:bugReportNavVC animated:YES completion:nil];
        
    }else if(indexPath.row == 0 && indexPath.section == 5){

        NSString *iTunesLink = @"http://itunes.apple.com/us/app/warehouse51/id364201184?mt=8";

        NSMutableArray *array = [NSMutableArray arrayWithObject:iTunesLink];

        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];


    }else if(indexPath.row == 1 && indexPath.section == 5){
        NSString *iTunesLink = @"http://itunes.apple.com/us/app/warehouse51/id364201184?mt=8";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];


        
    }else if(indexPath.row == 2 && indexPath.section == 5){


        NSURL *fanPageURL = [NSURL URLWithString:@"fb://profile/647265878689136"];
        [[UIApplication sharedApplication] openURL:fanPageURL];

        
    }else if(indexPath.row == 3 && indexPath.section == 5){


        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=neulynx"]];
        
    }else if(indexPath.row == 4 && indexPath.section == 5){

        NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=neulynx"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            [[UIApplication sharedApplication] openURL:instagramURL];
        }
        
    }else if(indexPath.row == 5 && indexPath.section == 5){


        NSString *periscopeURL = @"pscp://user?screen_name=neulynx";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:periscopeURL]];

    }else if(indexPath.row == 6 && indexPath.section == 5){

        NSString *vineURL = @"vine://user/1010410284269150208";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vineURL]];
        
    }else if(indexPath.row == 7 && indexPath.section == 5){

        NSString *googlePlusURL = @"https://plus.google.com/100840424703355995696/posts";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googlePlusURL]];
        
    }



}
//*******************Helper Method***************************//
//Helper method to download user's profile image
-(void)getUsersProfileImage{

    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];

            dispatch_async(dispatch_get_main_queue(), ^{

                self.profileImage.image = image;
                
            });

        }

    }];
}

//query to get the count of the user's social activity.

-(void)displayBadgeForUser:(User *)user{


    PFQuery *query = [PFQuery queryWithClassName:@"SocialTracker"];

    [query whereKey:@"pointsOwner" equalTo:[User currentUser]];


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

//dismiss the view Controller on Done button Tapped
-(void)onDoneButtonTapped{

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
