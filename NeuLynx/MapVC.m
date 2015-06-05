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
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "Activity.h"
#import "MRProgressOverlayView.h"
#import "MRProgress.h"



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
@property User *currentUser;
@property UIImage *tempImage;
@property UIWindow *window;
@property CLLocation *currentLocation;

//ring variables
@property UIImageView *ring1ImageView;
@property UIImageView *ring2ImageView;

//Activities
@property NSMutableArray *activitiesArray;
@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setUpFanOutButton]; // set up fan out buttons

    [self performInitialSetup]; //do initial set up for MapVC

    [self setUpProfileImage];
    [self createAndDisplayBlinkingRings];

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    //add animation to the rings
    [self addAnimation:self.ring1ImageView andTo:self.ring2ImageView];


}
#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];

                       [User currentUser].userCurrentCity = placemark.locality;
                       [User currentUser].userAdministrativeArea = placemark.administrativeArea;
                       [User currentUser].userCountryCode = placemark.country;

                   }];
}

-(void)viewDidAppear:(BOOL)animated{
    [self setUpProfileImage];
}
-(void)viewWillAppear:(BOOL)animated{



    [self addAnimation:self.ring1ImageView andTo:self.ring2ImageView];

    //If the user is logged in, then we want to allow him to tab on history
    if ([User currentUser] != nil) {

        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
         [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];

    }else{
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
         [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:NO];
    }




}


//helper method for initial set up

-(void)performInitialSetup{


    //Get reference to entire window
    self.window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    //Get Current User
    self.currentUser = [User currentUser];

    //Set the Searchbar Tint color.

//    self.searchBar.barTintColor = [UIColor colorWithRed:34.0/255.0 green:85.0/255.0 blue:255.0/255.0 alpha:1];

    //Set the Title and Color
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"NeuLynx";
    titleView.textColor = [UIColor colorWithRed:34.0/255.0 green:85.0/255.0 blue:255.0/255.0 alpha:1];
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


    //Get user's information and display current location and profile picture.
    [MRProgressOverlayView showOverlayAddedTo:self.window title:@"Loading..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [self getUserInformationFromParse:^{
        [self getUserCurrentLocation];
        [self setUpProfileImage];

        [MRProgressOverlayView dismissOverlayForView: self.window animated:YES];
    } afterDelay:2.0];




}

//Get user's current location
-(void)getUserCurrentLocation{

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
//Helper method to dismiss keyboard
-(void)dismissKeyboard{
    [self.searchBar resignFirstResponder];
}
//set up FanOut Buttons
-(void)setUpFanOutButton{
    //create dynamic animator
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.mainButton1 = [self createButton:@"Festival" willShow:YES];
    self.mainButton2 = [self createButton:@"Cultural" willShow:YES];
    self.mainButton3 = [self createButton:@"Gastronomy" willShow:YES];
    self.mainButton4 = [self createButton:@"Night Out" willShow:YES];
    self.mainButton5 = [self createButton:@"Fitness" willShow:YES];
    self.mainButton6 = [self createButton:@"Outdoors" willShow:YES];
    self.mainButton = [self createButton:@"" willShow:NO];



    //set the images for each button
    [self.mainButton setBackgroundImage:[UIImage imageNamed:@"discover"] forState:UIControlStateNormal];
    [self.mainButton1 setBackgroundImage:[UIImage imageNamed:@"mainFestival"] forState:UIControlStateNormal];
    [self.mainButton2 setBackgroundImage:[UIImage imageNamed:@"mainCultural"] forState:UIControlStateNormal];
    [self.mainButton3 setBackgroundImage:[UIImage imageNamed:@"mainGastronomy"] forState:UIControlStateNormal];
    [self.mainButton4 setBackgroundImage:[UIImage imageNamed:@"mainNightout"] forState:UIControlStateNormal];
    [self.mainButton5 setBackgroundImage:[UIImage imageNamed:@"mainFitness"] forState:UIControlStateNormal];
    [self.mainButton6 setBackgroundImage:[UIImage imageNamed:@"mainOutdoors"] forState:UIControlStateNormal];
    [self.mainButton addTarget:self action:@selector(fanButtons:) forControlEvents:UIControlEventTouchUpInside];

    //Initially hide the buttons

    for(UIView *view in self.mainButton1.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.mainButton2.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.mainButton3.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.mainButton4.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.mainButton5.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.mainButton6.subviews){
        view.hidden = YES;
    }


}

//Helper method to create button

-(UIButton *)createButton:(NSString *)buttonTitle willShow:(BOOL)show{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 66.0, self.view.frame.size.height - 116.0, 53.0, 53.0)];

    button.backgroundColor = [UIColor whiteColor];


    [button setTitleColor:[UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0] forState: UIControlStateNormal];

    //button setTitle:title forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor colorWithRed:34.0/255.0 green:85.0/255.0 blue:255.0/255.0 alpha:1].CGColor;

    button.layer.borderWidth = 0.0;
    button.layer.cornerRadius = button.frame.size.width/2;


    //create the label for the button

    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(-73, 5, 70, 20)];
//    label.layer.shadowColor =[UIColor colorWithRed:34.0/255.0 green:85.0/255.0 blue:255.0/255.0 alpha:1].CGColor;
//    label.layer.shadowOpacity = .75;

    label.layer.masksToBounds = NO;
    label.text= buttonTitle;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];




    if(show == YES){
        label.alpha = 1.0;
    }else if(show == NO){
        label.alpha = 0.0;


        [self addAnimation:self.ring1ImageView andTo:self.ring2ImageView];



    }




    [button addSubview:label];

    [self.view addSubview:button];

//    UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(self.view.frame.size.width - 60.0, self.view.frame.size.height - 110.0, 53.0, 53.0)];
//    label.text = @"text";
//    [self.view addSubview:label];




    return button;
}

//Helper method to do the fan out annimation
-(void) fanButtons:(id)sender{

    [self.dynamicAnimator removeAllBehaviors];

    if (!self.isFannedOut) {
        [self fanButtonOut];

        for(UIView *view in self.mainButton1.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.mainButton2.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.mainButton3.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.mainButton4.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.mainButton5.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.mainButton6.subviews){
            view.hidden = NO;


        }

        //remove animations of the rings and hide them.
        [self.ring1ImageView.layer removeAllAnimations];
        [self.ring2ImageView.layer removeAllAnimations];
        self.ring1ImageView.hidden = YES;
        self.ring2ImageView.hidden = YES;



    }else {
        [self snapButton:self.mainButton1 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton2 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton3 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton4 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton5 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton6 toPoint:self.mainButton.center];

        for(UIView *view in self.mainButton1.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.mainButton2.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.mainButton3.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.mainButton4.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.mainButton5.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.mainButton6.subviews){
            view.hidden = YES;
        }

        //add animation to the rings and show them
        [self addAnimation:self.ring1ImageView andTo:self.ring2ImageView];
        self.ring1ImageView.hidden = NO;
        self.ring2ImageView.hidden = NO;



    }
    self.isFannedOut = !self.isFannedOut;


}

//helper method to show buttons
-(void)fanButtonOut{
    [self snapButton:self.mainButton1 toPoint:CGPointMake(self.mainButton.frame.origin.x - 60.0, self.mainButton.frame.origin.y + 20.0)];
    [self snapButton:self.mainButton2 toPoint:CGPointMake(self.mainButton.frame.origin.x - 55.0, self.mainButton.frame.origin.y - 35.0)];
    [self snapButton:self.mainButton3 toPoint:CGPointMake(self.mainButton.frame.origin.x - 45.0, self.mainButton.frame.origin.y - 90.0)];
    [self snapButton:self.mainButton4 toPoint:CGPointMake(self.mainButton.frame.origin.x - 35.0, self.mainButton.frame.origin.y - 145.0)];
    [self snapButton:self.mainButton5 toPoint:CGPointMake(self.mainButton.frame.origin.x - 15.0, self.mainButton.frame.origin.y - 200.0)];
    [self snapButton:self.mainButton6 toPoint:CGPointMake(self.mainButton.frame.origin.x + 20.0, self.mainButton.frame.origin.y - 245.0)];

}

//helper method to create blinking ring images.
-(void)createAndDisplayBlinkingRings{
    UIImage *ring1 = [UIImage imageNamed:@"bluering.png"];
    //UIImage *image2 = [UIImage imageNamed:@"image2.png"];

    self.ring1ImageView = [[UIImageView alloc] initWithImage:ring1];
    [self.ring1ImageView setFrame:CGRectMake(self.view.frame.size.width - 72.0, self.view.frame.size.height - 122.0, 65.0, 65.0)];

    [self.view addSubview:self.ring1ImageView];
    UIImage *ring2 = [UIImage imageNamed:@"bluering.png"];
    //UIImage *image2 = [UIImage imageNamed:@"image2.png"];

    self.ring2ImageView = [[UIImageView alloc] initWithImage:ring2];
    [self.ring2ImageView setFrame:CGRectMake(self.view.frame.size.width - 77.0, self.view.frame.size.height - 127.0, 75.0, 75.0)];

    [self.view addSubview:self.ring2ImageView];






}

//helper method to fan in buttons back to centers
-(void)snapButton:(UIButton *)button toPoint:(CGPoint)point{
    UISnapBehavior *snapBehavior =[[UISnapBehavior alloc] initWithItem:button snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];
}

//helper method to set up profile image button
-(void)setUpProfileImage{

    //create an image and assign it to defualt image


    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];

            self.tempImage = image;
            //self.profileImage.image = image;
        }

    }];

   // NSLog(@"%@", self.tempImage);
    UIImage *profileImage = self.tempImage;

    //create button frame
    CGRect buttonFrame = CGRectMake(0, 0, 40, 40);

    //Create left Button
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];

    //make the button rounded
    button.layer.cornerRadius = button.frame.size.height / 2;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [UIColor colorWithRed:34.0/255.0 green:85.0/255.0 blue:255.0/255.0 alpha:1].CGColor;

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
        UIStoryboard *postActivityStoryboard = [UIStoryboard storyboardWithName:@"PostActivity" bundle:nil];
        UIViewController *postActivityNavVC = [postActivityStoryboard instantiateViewControllerWithIdentifier:@"postActivityNavVC"];

        [self presentViewController:postActivityNavVC animated:YES completion:nil];



    }
}



//helper method to download the activities

-(void)downloadActivitiesAndDisplayOnMap{

    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.currentLocation];
    PFQuery *query = [Activity query];

    [query whereKey:@"activityLocation" nearGeoPoint:geoPoint withinMiles:50.0];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){

        NSArray *activitiesArray = activities;

        if (!error) {
            // Add activities to the map.
            dispatch_async(dispatch_get_main_queue(), ^{

                NSLog(@"activities are %@",activitiesArray);


            });

        } else {
            [self displayAlertWithTitle:@"Could Not Retrieve Activities" andWithError:@"Make sure you're connected to WiFi or Phone Network"];


        }
        
    }
     
     ];
    
    


}

////////////////////ALERT HELPER METHODS/////////////////////////////////

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

-(void)displayAlertWithTitle:(NSString *)title andWithError:(NSString *)error{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alert show];

}

//Add blinking/pulse annimation
//Need to handle the show options for label.
-(void)addAnimation:(UIImageView *)imageView1 andTo:(UIImageView *)imageView2{
    CABasicAnimation *theAnimation1;

    theAnimation1=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation1.duration=4.0;
    theAnimation1.repeatCount=HUGE_VALF;
    theAnimation1.autoreverses=YES;
    theAnimation1.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation1.toValue=[NSNumber numberWithFloat:0.0];
    [imageView1.layer addAnimation:theAnimation1 forKey:@"animateOpacity"];

    CABasicAnimation *theAnimation2;
    theAnimation2=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation2.duration=3.0;
    theAnimation2.repeatCount=HUGE_VALF;
    theAnimation2.autoreverses=YES;
    theAnimation2.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation2.toValue=[NSNumber numberWithFloat:0.0];
    [imageView2.layer addAnimation:theAnimation2 forKey:@"animateOpacity"];
    
    
    
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
                //                self.navigationItem.leftBarButtonItem.enabled = YES;
                //                [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];

                //                [User currentUser].travelPreferences = @{@YES :@"1"};

                //If the user is new then present the profile

                [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
                [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];

                UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
                UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
                [self presentViewController:profileNavVC animated:YES completion:nil];

            } else {
                NSLog(@"User logged in through Facebook!");
                //enable inbox and profile
                self.navigationItem.leftBarButtonItem.enabled = YES;
                [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
                [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
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



    if (!self.initialLocation) {
        self.initialLocation = userLocation.location;
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;

        [mapView setRegion:mapRegion animated: YES];
    }

    [self downloadActivitiesAndDisplayOnMap];

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


//******************HELPER METHODS****************************************//
//Helper method to download user's profile image
//-(void)getUsersProfileImage{
//
//    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        if (!error) {
//            UIImage *image = [UIImage imageWithData:data];
//            self.profileImage.image = image;
//        }
//
//    }];
//}
//

//**********************BLOCKS***********************************************//
-(void)getUserInformationFromParse:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}


@end
