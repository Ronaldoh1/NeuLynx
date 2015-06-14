//
//  AccountVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/18/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "AccountVC.h"
#import "User.h"
#import "MailVC.h"
#import "ProfileVC.h"
#import "AppDelegate.h"


@interface AccountVC ()<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property NSMutableArray *menuArray;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property User *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *usersNameLabel;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSString *userCity;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property NSArray *cellIconNames;

@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetUp];


}



-(void)initialSetUp{

    //initialize menu icons array.
    [self setCellIconNames:[NSArray arrayWithObjects:@"messageIcon.png", @"requestIcon2", @"historyIcon", @"searchIcon", @"helpIcon", @"faqIcon", @"aboutIcon", @"termsIcon",nil]];

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    //get Current User
    self.currentUser = [User currentUser];

    //get user's name
    self.usersNameLabel.text = self.currentUser.name;

    //Set up Menu Array

    self.menuArray = [NSMutableArray new];


    [self.menuArray addObject:@"Inbox"];
    [self.menuArray addObject:@"Requests"];
     [self.menuArray addObject:@"History"];
     [self.menuArray addObject:@"Search Activity"];
     [self.menuArray addObject:@"Help"];
    [self.menuArray addObject:@"FAQs"];
     [self.menuArray addObject:@"About"];
    [self.menuArray addObject:@"Terms & Conditions"];
    

    //Make Profile Image round

    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 4.0;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1].CGColor;

    //change color of logout button

    [self.logoutButton setTitleColor:[UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1] forState:UIControlStateNormal];


    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Account & Settings";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //get user profile Image
    [self getUsersProfileImage];


    //get user's location and display it.
    self.locationLabel.text = [NSString stringWithFormat:@"%@ - %@, %@", self.currentUser.userCurrentCity, self.currentUser.userAdministrativeArea, self.currentUser.userCountryCode];
    self.locationLabel.textColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1];


    //if requests is clicked, then show done button
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL tmpBool = appDelegate.hideDoneButtonForRequests;


        tmpBool = NO;
        appDelegate.hideDoneButtonForRequests = nil;
    


}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {


    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mapNavVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mapNavVC animated:YES completion:nil];
}

//Display profile image for current user if he/she taps on his/her picture
- (IBAction)onProfilePictureTapped:(UIButton *)sender {

    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
    [self presentViewController:profileNavVC animated:YES completion:nil];
}

//display the profile view to allow the user to edit.
- (IBAction)onViewProfileButtonTapped:(UIButton *)sender {


        UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];


        [self presentViewController:profileNavVC animated:YES completion:nil];

}

- (IBAction)onLogOutButtonTapped:(UIButton *)sender {
    [User logOut];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma Mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //display the cells for each button
    cell.textLabel.text = self.menuArray[indexPath.row];
    //change the color of text
    cell.textLabel.textColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1];
    //change the background color
    cell.backgroundColor = [UIColor clearColor];

     //Add background image to table view
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground"]];

    //change the selection color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    //chnage the cell accessory
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

 NSString *cellIconName = [[self cellIconNames] objectAtIndex:indexPath.row];
    UIImage *cellIcon = [UIImage imageNamed:cellIconName];
    //[cell.imageView setImage:cellIcon];

    cell.imageView.transform =  CGAffineTransformMakeScale(0.5, 0.5);
    cell.imageView.image = cellIcon;


//
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    cell.imageView.frame = CGRectMake(0, 0, 20, 20);
    //cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);


//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
//    imageView.backgroundColor = [UIColor clearColor];
//    [imageView.layer setCornerRadius:5];
//    [imageView.layer setMasksToBounds:YES];
//    [imageView setImage:[UIImage imageNamed:cellIconName]];
//    [cell.contentView addSubview:imageView];

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {

        UIStoryboard *mailStoryboard = [UIStoryboard storyboardWithName:@"Mail" bundle:nil];
        UITabBarController *mailNavVC = [mailStoryboard instantiateViewControllerWithIdentifier:@"mailNavVC"];
        [self presentViewController:mailNavVC animated:YES completion:nil];


    }else if(indexPath.row == 1){
        UIStoryboard *requestStoryBoard = [UIStoryboard storyboardWithName:@"Request" bundle:nil];
        UITabBarController *requestVC = [requestStoryBoard instantiateViewControllerWithIdentifier:@"RequestNavVC"];
        [self presentViewController:requestVC animated:YES completion:nil];


    }else if(indexPath.row == 2){
        UIStoryboard *historyStoryBoard = [UIStoryboard storyboardWithName:@"History" bundle:nil];
        UINavigationController *historyNavVC = [historyStoryBoard instantiateViewControllerWithIdentifier:@"HistoryNavVC"];
        [self presentViewController:historyNavVC animated:YES completion:nil];

    }else if(indexPath.row == 3){
        UIStoryboard *searchActivity = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
        UINavigationController *searchNavVC = [searchActivity instantiateViewControllerWithIdentifier:@"SearchNavVC"];
        [self presentViewController:searchNavVC animated:YES completion:nil];


    }else if(indexPath.row == 4){
        UIStoryboard *helpStoryboard = [UIStoryboard storyboardWithName:@"Help" bundle:nil];
        UINavigationController *helpNavVC = [helpStoryboard instantiateViewControllerWithIdentifier:@"helpNavVC"];
        [self presentViewController:helpNavVC animated:YES completion:nil];

    }else if(indexPath.row == 5){
        UIStoryboard *faqStoryBoard = [UIStoryboard storyboardWithName:@"Faq" bundle:nil];
        UINavigationController *faqNavVC = [faqStoryBoard instantiateViewControllerWithIdentifier:@"faqNavVC"];
        [self presentViewController:faqNavVC animated:YES completion:nil];

    }else if(indexPath.row == 6){
        UIStoryboard *aboutStoryBoard = [UIStoryboard storyboardWithName:@"About" bundle:nil];
        UINavigationController *aboutNavVC = [aboutStoryBoard instantiateViewControllerWithIdentifier:@"aboutNavVC"];
        [self presentViewController:aboutNavVC animated:YES completion:nil];

    }else if(indexPath.row == 7){
        UIStoryboard *termsAndConditionsStoryBoard = [UIStoryboard storyboardWithName:@"TermsAndConditions" bundle:nil];
        UINavigationController *termsAndConditionsNavVC = [termsAndConditionsStoryBoard instantiateViewControllerWithIdentifier:@"TermsAndConditionsNavVC"];
        [self presentViewController:termsAndConditionsNavVC animated:YES completion:nil];

    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{




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



#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
    NSLog(@"Detected Location : %f, %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       NSLog(@"placemark.ISOcountryCode %@",placemark.locality
                             );
                       self.userCity = placemark.locality;

                   }];
}

@end
