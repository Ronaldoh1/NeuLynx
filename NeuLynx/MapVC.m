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
#import "CustomMKAnnotation.h"



@interface MapVC ()<MKMapViewDelegate, UIActionSheetDelegate, UISearchBarDelegate,CLLocationManagerDelegate>
@property UIButton *mainDiscoverButton;
@property UIButton *festivalActivityButton;
@property UIButton *culturalActivityButton;
@property UIButton *gastronomyActivityButton;
@property UIButton *nightOutActivityButton;
@property UIButton *fitnessActivityButton;
@property UIButton *outdoorsActivityButton;

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
@property NSMutableArray *activitiesArray; //contains all activities;
@property NSMutableArray *festivalActivityArray;
@property NSMutableArray *culturalActivityArray;
@property NSMutableArray *gastronomyActivityArray;
@property NSMutableArray *nightOutActivityArray;
@property NSMutableArray *fitnessActivityArray;
@property NSMutableArray *outDoorsActivityArray;


//MAP
@property CustomMKAnnotation *pinAnnotation;

//Profile Image
@property UIImage *profileImage;
@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setUpFanOutButton]; // set up fan out buttons

    [self performInitialSetup]; //do initial set up for MapVC



    [self createAndDisplayBlinkingRings];


}


-(void)viewDidAppear:(BOOL)animated{
    
    [self setUpProfileImage];

}
-(void)viewWillAppear:(BOOL)animated{

     [self setUpProfileImage];

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



    //Get Current User
    self.currentUser = [User currentUser];

    //set up profile image
     [self setUpProfileImage];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    //add animation to the rings
    [self addAnimation:self.ring1ImageView andTo:self.ring2ImageView];

    //add actions to each button
    [self.festivalActivityButton addTarget:self action:@selector(festivalButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.culturalActivityButton addTarget:self action:@selector(culturalButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.gastronomyActivityButton addTarget:self action:@selector(gastronomyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.nightOutActivityButton addTarget:self action:@selector(nightoutButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.fitnessActivityButton addTarget:self action:@selector(fitnessButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.outdoorsActivityButton addTarget:self action:@selector(outdoorsButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    


    //Setup Activity's array - initialize and allocate
    self.festivalActivityArray = [NSMutableArray new];
    self.fitnessActivityArray = [NSMutableArray new];
    self.gastronomyActivityArray = [NSMutableArray new];
    self.nightOutActivityArray = [NSMutableArray new];
    self.fitnessActivityArray = [NSMutableArray new];
    self.outDoorsActivityArray = [NSMutableArray new];


    //Get reference to entire window
    self.window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];


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
//        if (self.currentUser != nil) {
//            self.tempImage = [UIImage imageNamed:@"defaultImage.png"];
//        }

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

    self.festivalActivityButton = [self createButton:@"Festival" willShow:YES];
    self.culturalActivityButton = [self createButton:@"Cultural" willShow:YES];
    self.gastronomyActivityButton = [self createButton:@"Gastronomy" willShow:YES];
    self.nightOutActivityButton = [self createButton:@"Night Out" willShow:YES];
    self.fitnessActivityButton = [self createButton:@"Fitness" willShow:YES];
    self.outdoorsActivityButton = [self createButton:@"Outdoors" willShow:YES];
    self.mainDiscoverButton = [self createButton:@"" willShow:NO];



    //set the images for each button
    [self.mainDiscoverButton setBackgroundImage:[UIImage imageNamed:@"discover"] forState:UIControlStateNormal];
    [self.festivalActivityButton setBackgroundImage:[UIImage imageNamed:@"mainFestival"] forState:UIControlStateNormal];
    [self.culturalActivityButton setBackgroundImage:[UIImage imageNamed:@"mainCultural"] forState:UIControlStateNormal];
    [self.gastronomyActivityButton setBackgroundImage:[UIImage imageNamed:@"mainGastronomy"] forState:UIControlStateNormal];
    [self.nightOutActivityButton setBackgroundImage:[UIImage imageNamed:@"mainNightout"] forState:UIControlStateNormal];
    [self.fitnessActivityButton setBackgroundImage:[UIImage imageNamed:@"mainFitness"] forState:UIControlStateNormal];
    [self.outdoorsActivityButton setBackgroundImage:[UIImage imageNamed:@"mainOutdoors"] forState:UIControlStateNormal];
    [self.mainDiscoverButton addTarget:self action:@selector(fanButtons:) forControlEvents:UIControlEventTouchUpInside];

    //Initially hide the buttons

    for(UIView *view in self.festivalActivityButton.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.culturalActivityButton.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.gastronomyActivityButton.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.nightOutActivityButton.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.fitnessActivityButton.subviews){
        view.hidden = YES;
    }
    for(UIView *view in self.outdoorsActivityButton.subviews){
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

        for(UIView *view in self.festivalActivityButton.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.culturalActivityButton.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.gastronomyActivityButton.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.nightOutActivityButton.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.fitnessActivityButton.subviews){
            view.hidden = NO;

        }
        for(UIView *view in self.outdoorsActivityButton.subviews){
            view.hidden = NO;


        }

        //remove animations of the rings and hide them.
        [self.ring1ImageView.layer removeAllAnimations];
        [self.ring2ImageView.layer removeAllAnimations];
        self.ring1ImageView.hidden = YES;
        self.ring2ImageView.hidden = YES;



    }else {
        [self snapButton:self.festivalActivityButton toPoint:self.mainDiscoverButton.center];
        [self snapButton:self.culturalActivityButton toPoint:self.mainDiscoverButton.center];
        [self snapButton:self.gastronomyActivityButton toPoint:self.mainDiscoverButton.center];
        [self snapButton:self.nightOutActivityButton toPoint:self.mainDiscoverButton.center];
        [self snapButton:self.fitnessActivityButton toPoint:self.mainDiscoverButton.center];
        [self snapButton:self.outdoorsActivityButton toPoint:self.mainDiscoverButton.center];

        for(UIView *view in self.festivalActivityButton.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.culturalActivityButton.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.gastronomyActivityButton.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.nightOutActivityButton.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.fitnessActivityButton.subviews){
            view.hidden = YES;
        }
        for(UIView *view in self.outdoorsActivityButton.subviews){
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
    [self snapButton:self.festivalActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 60.0, self.mainDiscoverButton.frame.origin.y + 20.0)];
    [self snapButton:self.culturalActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 55.0, self.mainDiscoverButton.frame.origin.y - 35.0)];
    [self snapButton:self.gastronomyActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 45.0, self.mainDiscoverButton.frame.origin.y - 90.0)];
    [self snapButton:self.nightOutActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 35.0, self.mainDiscoverButton.frame.origin.y - 145.0)];
    [self snapButton:self.fitnessActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 15.0, self.mainDiscoverButton.frame.origin.y - 200.0)];
    [self snapButton:self.outdoorsActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x + 20.0, self.mainDiscoverButton.frame.origin.y - 245.0)];

}


-(IBAction)buttonPressed:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSLog(@"button tapped %ld", (long)button.tag);
}

#pragma mark - Button selectors for each button 
-(void)festivalButtonTapped{
    NSLog(@"festival button tapped");



    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotations:self.festivalActivityArray];
//
//    [self.mapView removeAnnotations:self.culturalActivityArray];
//
//
//    [self.mapView removeAnnotations:self.gastronomyActivityArray];
//
//    [self.mapView removeAnnotations:self.nightOutActivityArray];
//
//
//    [self.mapView removeAnnotations:self.fitnessActivityArray];
//
//    [self.mapView removeAnnotations:self.outDoorsActivityArray];


}

-(void)culturalButtonTapped{
    NSLog(@"cultural button tapped");
    [self.mapView removeAnnotations:self.mapView.annotations];


    [self.mapView addAnnotations:self.culturalActivityArray];
}
-(void)gastronomyButtonTapped{
    NSLog(@"gastronomy button tapped");
        [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.gastronomyActivityArray];
}
-(void)nightoutButtonTapped{
    NSLog(@"nightout tapped");
        [self.mapView removeAnnotations:self.mapView.annotations];
[self.mapView addAnnotations:self.nightOutActivityArray];
}
-(void)fitnessButtonTapped{
    NSLog(@"fitness button tapped");
        [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.fitnessActivityArray];
}
-(void)outdoorsButtonTapped{
    NSLog(@"outdoors button tapped");
        [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.outDoorsActivityArray];
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

  //  self.tempImage = [UIImage new];


    if (self.currentUser != nil){
    //create an image and assign it to defualt image



    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];

            self.tempImage = image;
            //self.profileImage.image = image;
        }

    }];
        //self.tempImage = [self getUsersProfileImage];

    }else if (self.currentUser == nil){

        self.tempImage = [UIImage imageNamed:@"defaultImage.png"];
    }

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
    [button reloadInputViews];

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

//Helper method to download user's profile image
-(UIImage *)getUsersProfileImage{
    UIImage *image = [UIImage new];
    self.profileImage = [UIImage new];

    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *tempImage = [UIImage imageWithData:data];
            self.profileImage = tempImage;
        }

    }];

    image = self.profileImage;

    return image;
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

        // NSArray *activitiesArray = activities;

        if (!error) {
            // Add activities to the map.
            dispatch_async(dispatch_get_main_queue(), ^{

                // NSLog(@"activities are %@",activitiesArray);

                for (Activity *activity in activities){
                    self.pinAnnotation = [[CustomMKAnnotation alloc]initWithTitle:activity.activityTitle Location:CLLocationCoordinate2DMake(activity.activityLocation.latitude, activity.activityLocation.longitude) andWithActivity:activity];
                    ;
                    if ([activity.selectedCategory isEqualToString:@"Festival"]) {
                        [self.fitnessActivityArray addObject:self.pinAnnotation];

                    }else if ([activity.selectedCategory isEqualToString:@"Cultural"]) {
                        [self.culturalActivityArray addObject:self.pinAnnotation];

                    } else if ([activity.selectedCategory isEqualToString:@"Gastronomy"]) {
                        [self.gastronomyActivityArray addObject:self.pinAnnotation];

                    } else if ([activity.selectedCategory isEqualToString:@"NightOut"]) {
                        [self.nightOutActivityArray addObject:self.pinAnnotation];

                    } else if ([activity.selectedCategory isEqualToString:@"Fitness"]) {
                        [self.fitnessActivityArray addObject:self.pinAnnotation];

                    } else if ([activity.selectedCategory isEqualToString:@"Outdoors"]) {
                        [self.outDoorsActivityArray addObject:self.pinAnnotation];
                    }


                    //   self.pinAnnotation.activity = activity;

                    // NSLog(@"%@", self.fitnessActivityArray);

                    //
                   [self.mapView addAnnotation:self.pinAnnotation];
                    
                }


                //[self.mapView addAnnotations:self.gastronomyActivityArray];

                
            });


            
        } else {
            [self displayAlertWithTitle:@"Could Not Retrieve Activities" andWithError:@"Make sure you're connected to WiFi or Phone Network"];
            
            
        }


    }




     ];
    //once we have the array with activity, we need to ad them to the map.
//    [self.mapView addAnnotations:self.festivalActivityArray];
//                [self.mapView addAnnotations:self.culturalActivityArray];
//                [self.mapView addAnnotations:self.gastronomyActivityArray];
//    //            [self.mapView addAnnotations:self.nightOutActivityArray];
//    //             [self.mapView addAnnotations:self.fitnessActivityArray];
//    //            [self.mapView addAnnotations:self.outDoorsActivityArray];



   // NSLog(@"%@", self.gastronomyActivityArray);


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
    theAnimation1.duration=1.25;
    theAnimation1.repeatCount=HUGE_VALF;
    theAnimation1.autoreverses=YES;
    theAnimation1.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation1.toValue=[NSNumber numberWithFloat:0.0];
    [imageView1.layer addAnimation:theAnimation1 forKey:@"animateOpacity"];

    CABasicAnimation *theAnimation2;
    theAnimation2=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation2.duration=1.0;
    theAnimation2.repeatCount=HUGE_VALF;
    theAnimation2.autoreverses=YES;
    theAnimation2.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation2.toValue=[NSNumber numberWithFloat:0.0];
    [imageView2.layer addAnimation:theAnimation2 forKey:@"animateOpacity"];



}

//this helper method is used to retrieve the facebook data from the user and store in parse.

- (void)getFacebookUserData{


    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // handle response
        [User currentUser].name = result[@"name"];
        [User currentUser].email = result[@"email"];
        [User currentUser].isFbUser = true;
        [[User currentUser] saveInBackground];


        [self getFbUserProfileImage:result[@"id"]];

    }];
}

//helper method to retrieve user's profile image from facebook..

-(void)getFbUserProfileImage:(id)facebookID{


    // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

    // Run network request asynchronously
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError == nil && data != nil) {
             // Set the image in the imageView
             // UIImage *image = [UIImage imageWithData:data];

             PFFile *file = [ PFFile fileWithData:data];

            [User currentUser].profileImage = file;

             [[User currentUser] saveInBackground];

         }
     }];
    
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

                       self.currentUser.userCurrentCity = placemark.locality;
                       self.currentUser.userAdministrativeArea = placemark.administrativeArea;
                       self.currentUser.userCountryCode = placemark.country;

                   }];
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

                  [self getFacebookUserData];

                //if the user is new, then we want to get his information from facebook and store it in parse.
                [self saveFbUserInfoToParse:^{
                    //If the user is new then present the profile
                    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
                    UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
                    [self presentViewController:profileNavVC animated:YES completion:nil];

                } afterDelay:3];


                //enable tabs once the user has been signed up (Profile/Inbox);

                [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
                [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];




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

                UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
                UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
                [self presentViewController:profileNavVC animated:YES completion:nil];
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

    MKCoordinateRegion region;
    region.center.latitude = *latitude;
    region.center.longitude = *logitude;
    region.span.latitudeDelta = 0.04;
    region.span.longitudeDelta = 0.04;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];

}


#pragma Mark - MKMapView Delegate Methods.

//returns the view for the selected annotation method.


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{


    //for every custom annotation, check the category, and display the appropriate image/pin for each annotation.

    if ([annotation isKindOfClass:[CustomMKAnnotation class]]) {

        CustomMKAnnotation *pinAnnotation = (CustomMKAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"customAnnotation"];



        if ([pinAnnotation.activity.selectedCategory isEqualToString:@"Cultural"]) {

            UIImage *image = [UIImage imageNamed:@"culturalPin.png"];
            annotationView.image =  [self resizeImageForPins:image];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Gastronomy"]){

            UIImage *image = [UIImage imageNamed:@"gastronomyPin.png"];
            annotationView.image =  [self resizeImageForPins:image];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Night Out"]){

            UIImage *image = [UIImage imageNamed:@"nightOutPin.png"];
            annotationView.image =  [self resizeImageForPins:image];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Festival"]){

            UIImage *image = [UIImage imageNamed:@"festivalPin.png"];
            annotationView.image =  [self resizeImageForPins:image];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Fitness"]){

            UIImage *image = [UIImage imageNamed:@"fitnessPin.png"];
            annotationView.image =  [self resizeImageForPins:image];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Outdoors"]){
            
            UIImage *image = [UIImage imageNamed:@"outdoorsPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
        }

        if(annotationView == nil){
            annotationView = pinAnnotation.annotationView;
        }else
            annotationView.annotation = annotation;
        return annotationView;
    } else{
        return nil;
    }
}



//Allow user to select their location.

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    
    UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UIViewController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:@"detailNavVc"];
    [self presentViewController:detailVC animated:YES completion:nil];
    
    
}



//******************HELPER METHODS****************************************//

//Helper method to resize pins for mapview

-(UIImage *)resizeImageForPins:(UIImage *)image{
    CGRect resizeRect;
    resizeRect.size.height = 35;
    resizeRect.size.width = 20;
    
    resizeRect.origin = (CGPoint){0.0f, 0.0f};
    UIGraphicsBeginImageContext(resizeRect.size);
    [image drawInRect:resizeRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}


//**********************BLOCKS***********************************************//
-(void)getUserInformationFromParse:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}


-(void)saveFbUserInfoToParse:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}






///////////******************SEGUE***************************/////////////////

-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
}

@end
