//
//  AccountAndSettingsTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/27/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "AccountAndSettingsTVC.h"
#import "User.h"
#import "MailVC.h"
#import "ProfileVC.h"
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
    
}

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

@end
