//
//  AccountAndSettingsTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/27/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "AccountAndSettingsTVC.h"
#import "User.h"
#import "MailVC2.h"
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

@end

@implementation AccountAndSettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   // self.navigationItem.rightBarButtonItem = self.editButtonItem;



    [self performInitialSetUp];
}

-(void)performInitialSetUp{

    //get Current User
    self.currentUser = [User currentUser];
    

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
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

    //if requests is clicked, then show done button
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL tmpBool = appDelegate.hideDoneButtonForRequests;


    tmpBool = NO;
    appDelegate.hideDoneButtonForRequests = nil;

    //Add right bar button item
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDoneButtonTapped)];
    self.navigationItem.rightBarButtonItem = rightBarButton;

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

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate Methods
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    UITableViewCell *cell = nil;
//
//    if (indexPath.row == 1) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
//    } else {
//
//
//    }
//
//
//    return cell;
//}
//The following method is used to managed which cells are selectable.

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0 && indexPath.section == 0) {
        return nil;
    }else if (indexPath.row == 8 && indexPath.section == 4) {
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

        NSString *iTunesLink = @"http://itunes.apple.com/us/app/warehouse51/id364201184?mt=8";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];

    }else if(indexPath.row == 1 && indexPath.section == 4){

      NSString *iTunesLink = @"http://itunes.apple.com/us/app/warehouse51/id364201184?mt=8";
        NSMutableArray *array = [NSMutableArray arrayWithObject:iTunesLink];

        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];

        
    }else if(indexPath.row == 2 && indexPath.section == 4){

        NSString *fbURL = @"https://www.facebook.com/NeuLynx?filter=1";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbURL]];

        
    }else if(indexPath.row == 3 && indexPath.section == 4){
        NSString *twitterURL = @"https://twitter.com/neulynx";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterURL]];
        
    }else if(indexPath.row == 4 && indexPath.section == 4){

        NSString *instaURL = @"https://instagram.com/neulynx/";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:instaURL]];

        
    }else if(indexPath.row == 5 && indexPath.section == 4){


        NSString *periscopeURL = @"https://www.periscope.tv";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:periscopeURL]];

    }else if(indexPath.row == 6 && indexPath.section == 4){

        NSString *vineURL = @"https://vine.co";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vineURL]];
        
    }else if(indexPath.row == 7 && indexPath.section == 4){

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
            self.profileImage.image = image;
        }

    }];
}

//dismiss the view Controller on Done button Tapped
-(void)onDoneButtonTapped{

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
