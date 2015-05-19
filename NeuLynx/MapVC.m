//
//  MapVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "User.h"



@interface MapVC ()<MKMapViewDelegate, UIActionSheetDelegate, UISearchBarDelegate,CLLocationManagerDelegate>
@property UIButton *mainButton;
@property UIButton *mainButton1;
@property UIButton *mainButton2;
@property UIButton *mainButton3;
@property UIButton *mainButton4;
@property UIButton *mainButton5;
@property UIButton *mainButton6;

@property UIDynamicAnimator *dynamicAnimator;
@property BOOL isFannedOut;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property CLLocationManager *locationManager;
@property CLLocation *initialLocation;
@property BOOL didGetUserLocation;
@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpProfileImage];
    [self setUpFanOutButton];


    //GETING THE USER'S LOCATION
    //set up settings for location managers.
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];

    self.mapView.showsUserLocation = true;

    //initially we should set the didGetUserLocation to false;
    self.didGetUserLocation = false;

    


}

-(void)viewWillAppear:(BOOL)animated{
    [self performInitialSetup];

    //If the user is logged in, then we want to allow him to tab on history
    if ([User currentUser] != nil) {

        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];

    }else{
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
    }
//    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:true];
//
//    double latitude = self.locationManager.location.coordinate.latitude;
//    double longitude = self.locationManager.location.coordinate.longitude;
//
//
//    [self zoom:&latitude :&longitude];
}


 //helper method for initial set up

-(void)performInitialSetup{

    //Set the Title and Color

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"NeuLynx";
    titleView.textColor = [UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];

    //Check if the user has previously used the app.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasBeenRun"]) {

        UIStoryboard *tutorialStoryboard = [UIStoryboard storyboardWithName:@"Tutorial" bundle:nil];
        UITabBarController *tutorialNavVC = [tutorialStoryboard instantiateViewControllerWithIdentifier:@"tutorialNavVC"];
        [self presentViewController:tutorialNavVC animated:true completion:nil];

    }

    //if it has displayed the map then we say it has been run...therefore we do not show the Tutorial again
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasBeenRun"];
    //Dismiss Keyboard when user touches outside of the search bar.
    //first - create a tap gesture.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    //add the tap gesture to the current view.
    [self.view addGestureRecognizer:tap];

    //check if the user is logged in. If he is, then allow the profile image to be tapable

//    if ([User currentUser] == nil) {
//        self.navigationItem.leftBarButtonItem.enabled = NO;
//    }else{
//        self.navigationItem.leftBarButtonItem.enabled = YES;
//    }

}
-(void)dismissKeyboard{
    [self.searchBar resignFirstResponder];
}

-(void)setUpFanOutButton{
    //create dynamic animator
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.mainButton1 = [self createButton];
    self.mainButton2 = [self createButton];
    self.mainButton3 = [self createButton];
    self.mainButton4 = [self createButton];
    self.mainButton5 = [self createButton];
    self.mainButton6 = [self createButton];

    self.mainButton = [self createButton];



    //set the images for each button
    [self.mainButton setBackgroundImage:[UIImage imageNamed:@"discover"] forState:UIControlStateNormal];
    [self.mainButton1 setBackgroundImage:[UIImage imageNamed:@"festival"] forState:UIControlStateNormal];
    [self.mainButton2 setBackgroundImage:[UIImage imageNamed:@"gastronomy"] forState:UIControlStateNormal];
    [self.mainButton3 setBackgroundImage:[UIImage imageNamed:@"nightout"] forState:UIControlStateNormal];
    [self.mainButton4 setBackgroundImage:[UIImage imageNamed:@"cultural"] forState:UIControlStateNormal];
    [self.mainButton5 setBackgroundImage:[UIImage imageNamed:@"fitness"] forState:UIControlStateNormal];
    [self.mainButton6 setBackgroundImage:[UIImage imageNamed:@"outdoors"] forState:UIControlStateNormal];
    [self.mainButton addTarget:self action:@selector(fanButtons:) forControlEvents:UIControlEventTouchUpInside];
}
-(UIButton *)createButton{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50.0, self.view.frame.size.height - 100.0, 50.0, 50.0)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0] forState: UIControlStateNormal];

    //button setTitle:title forState:UIControlStateNormal];
     button.layer.borderColor = [UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0].CGColor;

    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = button.frame.size.width/2;

    [self.view addSubview:button];

    return button;
}
-(void) fanButtons:(id)sender{

    [self.dynamicAnimator removeAllBehaviors];

    if (!self.isFannedOut) {
        [self fanButtonOut];

    }else {
        [self snapButton:self.mainButton1 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton2 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton3 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton4 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton5 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton6 toPoint:self.mainButton.center];
    }
    self.isFannedOut = !self.isFannedOut;
    
    
}
-(void)fanButtonOut{
    [self snapButton:self.mainButton1 toPoint:CGPointMake(self.mainButton.frame.origin.x - 60.0, self.mainButton.frame.origin.y + 20.0)];
    [self snapButton:self.mainButton2 toPoint:CGPointMake(self.mainButton.frame.origin.x - 55.0, self.mainButton.frame.origin.y - 35.0)];
    [self snapButton:self.mainButton3 toPoint:CGPointMake(self.mainButton.frame.origin.x - 45.0, self.mainButton.frame.origin.y - 90.0)];
    [self snapButton:self.mainButton4 toPoint:CGPointMake(self.mainButton.frame.origin.x - 35.0, self.mainButton.frame.origin.y - 145.0)];
    [self snapButton:self.mainButton5 toPoint:CGPointMake(self.mainButton.frame.origin.x - 15.0, self.mainButton.frame.origin.y - 200.0)];
    [self snapButton:self.mainButton6 toPoint:CGPointMake(self.mainButton.frame.origin.x + 20.0, self.mainButton.frame.origin.y - 245.0)];
}
-(void)snapButton:(UIButton *)button toPoint:(CGPoint)point{
    UISnapBehavior *snapBehavior =[[UISnapBehavior alloc] initWithItem:button snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];
}
-(void)setUpProfileImage{

    //create an image and assign it to defualt image
    UIImage *profileImage = [UIImage imageNamed:@"defaultImage"];
    //create button frame
    CGRect buttonFrame = CGRectMake(0, 0, 40, 40);

    //Create left Button
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];

    //make the button rounded
    button.layer.cornerRadius = button.frame.size.height / 2;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0].CGColor;

    [button setImage:profileImage forState:UIControlStateNormal];

    //add at tap gesture recognizer to the left button
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(profileImageTapped:)];
    [button addGestureRecognizer:tapGesture];


    //create a custom view for the button
    UIView *profileButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    profileButtonView.bounds = CGRectOffset(profileButtonView.bounds, 10, 0);

    //add the button to the custom view
    [profileButtonView addSubview:button];

    UIBarButtonItem *profileButtonItem = [[UIBarButtonItem alloc]initWithCustomView:profileButtonView];

    self.navigationItem.leftBarButtonItem = profileButtonItem;

    //CREATE RIGHT BUTTON FOR POST


}
//helper method to show user's profile.

-(void)profileImageTapped:(UIBarButtonItem* )sender{
    NSLog(@"Image tapped");

    //present the account view controller to display menus for user
    //if the current user does not exist, then make him/her sign up.
    if ([User currentUser] == nil) {
        [self presentActionSheetToLogInUser];

    }else{
        UIStoryboard *accountStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
        UITabBarController *AccountAndSettingsNavVC = [accountStoryboard instantiateViewControllerWithIdentifier:@"accountAndSettingsNavVC"];
    [self presentViewController:AccountAndSettingsNavVC animated:YES completion:nil];

    }
}


//on post event button pressed
- (IBAction)onPostButtonPressed:(UIBarButtonItem *)sender {

    //if the current user does not exist, then make him/her sign up.
    if ([User currentUser] == nil) {
        [self presentActionSheetToLogInUser];

    }else{

        NSLog(@"user is logged in");
        UIStoryboard *postEventStoryboard = [UIStoryboard storyboardWithName:@"PostEvent" bundle:nil];
        UIViewController *postEventNavVC = [postEventStoryboard instantiateViewControllerWithIdentifier:@"postEventNavVC"];

        [self presentViewController:postEventNavVC animated:YES completion:nil];
        


    }
}

//helper method to create actionsheet
-(void)presentActionSheetToLogInUser{
    NSString *actionSheetTitle = @"You must be logged in to post events";
    NSString *button1 = @"Sign In";
    NSString *button2 = @"Sign Up";
    NSString *button3 = @"Sign in with Facebook";
    NSString *button4 = @"Sign in with Twitter";
    NSString *cancelTitle = @"Never Mind";

    //create the action sheet.

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles:button1,button2, button3, button4, nil];

    //present the actionsheet in the current view.
    [actionSheet showInView:self.view];

}

#pragma Mark - ActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        //if the first button is tapped, then present  sign in storyboard
        UIStoryboard *signInStoryBoard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
        UIViewController *signInVC = [signInStoryBoard instantiateViewControllerWithIdentifier:@"signInNavVC"];
        [self presentViewController:signInVC animated:YES completion:nil];

    }else if(buttonIndex == 1){
        //if the second button is tapped, then present the sign up storyboard/vc

        UIStoryboard *signUpStoryBoard = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];

        UIViewController *signUpVC = [signUpStoryBoard instantiateViewControllerWithIdentifier:@"SignUpNavVC"];
        [self presentViewController:signUpVC animated:YES completion:nil];

    }else if(buttonIndex == 2){

        //Setting up loginwith facebook

        //1. need to get user's permissions.
        NSArray *permissionsArray = @[ @"email", @"public_profile"];

        [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
                //enable the inbox and profile
                self.navigationItem.leftBarButtonItem.enabled = YES;
                [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
            } else {
                NSLog(@"User logged in through Facebook!");
                //enable inbox and profile
                self.navigationItem.leftBarButtonItem.enabled = YES;
                [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
            }
        }];


    }else if(buttonIndex == 3){

        [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Twitter login.");
                return;
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in with Twitter!");
                 self.navigationItem.leftBarButtonItem.enabled = YES;
            } else {
                NSLog(@"User logged in with Twitter!");
                 self.navigationItem.leftBarButtonItem.enabled = YES;
            }
        }];

    }
}
#pragma Mark - Search bar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];

}


#pragma Mark - CLLocationManager Delegate Methods


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

    //Get the user's current location, zoom to user's location on the map.

//    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
    //zooming map to current location at startup
//    if(!self.didGetUserLocation){
//
//        //zooming map to current location at startup
//        double latitude = self.locationManager.location.coordinate.latitude;
//        double longitude = self.locationManager.location.coordinate.longitude;
//        [self.locationManager stopUpdatingLocation];
//
//        [self zoom:&latitude :&longitude];
//
//        self.didGetUserLocation = true;
//
//        
//    }

    if (!self.initialLocation) {
        self.initialLocation = userLocation.location;
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;

        [mapView setRegion:mapRegion animated: YES];
    }



}
//helper method to zoom in
-(void)zoom:(double *)latitude :(double *)logitude
{
    //    double delayInSeconds = 0.5;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    //        {
    MKCoordinateRegion region;
    region.center.latitude = *latitude;
    region.center.longitude = *logitude;
    region.span.latitudeDelta = 0.04;
    region.span.longitudeDelta = 0.04;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
    //        });
}





@end
