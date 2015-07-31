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
#import "AppDelegate.h"



@interface MapVC ()<MKMapViewDelegate, UIActionSheetDelegate, UISearchBarDelegate,CLLocationManagerDelegate>
@property UIButton *mainDiscoverButton;
@property UIButton *festivalActivityButton;
@property UIButton *culturalActivityButton;
@property UIButton *gastronomyActivityButton;
@property UIButton *nightOutActivityButton;
@property UIButton *fitnessActivityButton;
@property UIButton *outdoorsActivityButton;
@property UIButton *studentLifeActivityButton;

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
@property NSMutableArray *lgbtFilteredActivitiesArray;
@property NSMutableArray *festivalActivityArray;
@property NSMutableArray *culturalActivityArray;
@property NSMutableArray *gastronomyActivityArray;
@property NSMutableArray *nightOutActivityArray;
@property NSMutableArray *fitnessActivityArray;
@property NSMutableArray *outDoorsActivityArray;
@property NSMutableArray *studentLifeActivityArray;


//MAP
@property CustomMKAnnotation *pinAnnotation;
@property NSArray *annotationArray;
@property NSArray *allActivitiesArray;
@property NSMutableArray *activitySearchResults;
@property BOOL activityIsSelected;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lgbtActivitySelector;

//Profile Image
@property UIImage *profileImage;

@end

NSString* const ANNOTATION_SELECTED_DESELECTED = @"mapAnnotationSelectedOrDeselected";

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setUpFanOutButton]; // set up fan out buttons

    [self performInitialSetup]; //do initial set up for MapVC



    [self createAndDisplayBlinkingRings];
    //[[UINavigationBar appearance]setBarTintColor:[UIColor purpleColor]];


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
    [self.studentLifeActivityButton addTarget:self action:@selector(studentLifeButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    //Set up activity LGBT filter
    self.lgbtActivitySelector.tintColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    self.lgbtActivitySelector.backgroundColor = [UIColor whiteColor];


    //Setup Activity's array - initialize and allocate
    self.festivalActivityArray = [NSMutableArray new];
    self.culturalActivityArray = [NSMutableArray new];
    self.fitnessActivityArray = [NSMutableArray new];
    self.gastronomyActivityArray = [NSMutableArray new];
    self.nightOutActivityArray = [NSMutableArray new];
    self.fitnessActivityArray = [NSMutableArray new];
    self.outDoorsActivityArray = [NSMutableArray new];
    self.studentLifeActivityArray = [NSMutableArray new];

    self.allActivitiesArray = [NSMutableArray new];
    self.lgbtFilteredActivitiesArray = [NSMutableArray new];



    //Get reference to entire window
    self.window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];



    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    titleView.text = @"NeuLynx";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
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


    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL tmpBool = appDelegate.hideDoneButtonForRequests;



    tmpBool = YES;

    appDelegate.hideDoneButtonForRequests = &(tmpBool);


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
    self.studentLifeActivityButton = [self createButton:@"Student Life" willShow:YES];
    self.mainDiscoverButton = [self createButton:@"" willShow:NO];



    //set the images for each button
    [self.mainDiscoverButton setBackgroundImage:[UIImage imageNamed:@"discover"] forState:UIControlStateNormal];
    [self.festivalActivityButton setBackgroundImage:[UIImage imageNamed:@"mainFestival"] forState:UIControlStateNormal];
    [self.culturalActivityButton setBackgroundImage:[UIImage imageNamed:@"mainCultural"] forState:UIControlStateNormal];
    [self.gastronomyActivityButton setBackgroundImage:[UIImage imageNamed:@"mainGastronomy"] forState:UIControlStateNormal];
    [self.nightOutActivityButton setBackgroundImage:[UIImage imageNamed:@"mainNightout"] forState:UIControlStateNormal];
    [self.fitnessActivityButton setBackgroundImage:[UIImage imageNamed:@"mainFitness"] forState:UIControlStateNormal];
    [self.outdoorsActivityButton setBackgroundImage:[UIImage imageNamed:@"mainOutdoors"] forState:UIControlStateNormal];
    [self.studentLifeActivityButton setBackgroundImage:[UIImage imageNamed:@"mainStudentLife"] forState:UIControlStateNormal];
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
    for(UIView *view in self.studentLifeActivityButton.subviews){
        view.hidden = YES;
    }


}

//Helper method to create button

-(UIButton *)createButton:(NSString *)buttonTitle willShow:(BOOL)show{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 66.0, self.view.frame.size.height - 116.0, 53.0, 53.0)];

    button.backgroundColor = [UIColor whiteColor];


    [button setTitleColor:[UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0] forState: UIControlStateNormal];

    //button setTitle:title forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;

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
        for(UIView *view in self.studentLifeActivityButton.subviews){
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
        [self snapButton:self.studentLifeActivityButton toPoint:self.mainDiscoverButton.center];

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
        for(UIView *view in self.studentLifeActivityButton.subviews){
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
    [self snapButton:self.festivalActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 85.0, self.mainDiscoverButton.frame.origin.y + 40.0)];
    [self snapButton:self.culturalActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 80.0, self.mainDiscoverButton.frame.origin.y - 13.0)];
    [self snapButton:self.gastronomyActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 70.0, self.mainDiscoverButton.frame.origin.y - 65.0)];
    [self snapButton:self.nightOutActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 60.0, self.mainDiscoverButton.frame.origin.y - 117.0)];
    [self snapButton:self.fitnessActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 40.0, self.mainDiscoverButton.frame.origin.y - 166.0)];
    [self snapButton:self.outdoorsActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x - 10.0, self.mainDiscoverButton.frame.origin.y - 211.0)];
    [self snapButton:self.studentLifeActivityButton toPoint:CGPointMake(self.mainDiscoverButton.frame.origin.x + 32.0, self.mainDiscoverButton.frame.origin.y - 244.0)];
}


-(IBAction)buttonPressed:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSLog(@"button tapped %ld", (long)button.tag);
}

#pragma mark - Button selectors for each button
-(void)festivalButtonTapped{


    [self.mapView removeAnnotations:self.mapView.annotations];

    if (self.lgbtActivitySelector.selectedSegmentIndex == 0){

        [self.mapView addAnnotations:self.festivalActivityArray];

    } else if(self.lgbtActivitySelector.selectedSegmentIndex == 1) {


        [self.mapView addAnnotations:[self filterLGBTactivities:self.festivalActivityArray]];

    }


}

-(void)culturalButtonTapped{

    [self.mapView removeAnnotations:self.mapView.annotations];

    if (self.lgbtActivitySelector.selectedSegmentIndex == 0){

        [self.mapView addAnnotations:self.culturalActivityArray];

    } else if(self.lgbtActivitySelector.selectedSegmentIndex == 1) {

        [self.mapView addAnnotations:[self filterLGBTactivities:self.culturalActivityArray]];

    }

}
-(void)gastronomyButtonTapped{
    [self.mapView removeAnnotations:self.mapView.annotations];

    if (self.lgbtActivitySelector.selectedSegmentIndex == 0){

        [self.mapView addAnnotations:self.gastronomyActivityArray];

    } else if(self.lgbtActivitySelector.selectedSegmentIndex == 1) {

        [self.mapView addAnnotations:[self filterLGBTactivities:self.gastronomyActivityArray]];

    }

}
-(void)nightoutButtonTapped{
    [self.mapView removeAnnotations:self.mapView.annotations];

    if (self.lgbtActivitySelector.selectedSegmentIndex == 0){

        [self.mapView addAnnotations:self.nightOutActivityArray];

    } else if(self.lgbtActivitySelector.selectedSegmentIndex == 1) {

        [self.mapView addAnnotations:[self filterLGBTactivities:self.nightOutActivityArray]];

    }

}
-(void)fitnessButtonTapped{
    [self.mapView removeAnnotations:self.mapView.annotations];

    if (self.lgbtActivitySelector.selectedSegmentIndex == 0){

        [self.mapView addAnnotations:self.fitnessActivityArray];

    } else if(self.lgbtActivitySelector.selectedSegmentIndex == 1) {

        [self.mapView addAnnotations:[self filterLGBTactivities:self.fitnessActivityArray]];

    }

}
-(void)outdoorsButtonTapped{
    [self.mapView removeAnnotations:self.mapView.annotations];

    if (self.lgbtActivitySelector.selectedSegmentIndex == 0){

        [self.mapView addAnnotations:self.outDoorsActivityArray];

    } else if(self.lgbtActivitySelector.selectedSegmentIndex == 1) {

        [self.mapView addAnnotations:[self filterLGBTactivities:self.outDoorsActivityArray]];

    }

}
-(void)studentLifeButtonTapped{
    [self.mapView removeAnnotations:self.mapView.annotations];

    if (self.lgbtActivitySelector.selectedSegmentIndex == 0){

        [self.mapView addAnnotations:self.studentLifeActivityArray];

    } else if(self.lgbtActivitySelector.selectedSegmentIndex == 1) {

        [self.mapView addAnnotations:[self filterLGBTactivities:self.studentLifeActivityArray]];

    }

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

                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tempImage = image;
                });

            }

        }];


    }else if (self.currentUser == nil){


        dispatch_async(dispatch_get_main_queue(), ^{
              self.tempImage = [UIImage imageNamed:@"defaultImage.png"];
        });

    }


    UIImage *profileImage = self.tempImage;


    //create button frame
    CGRect buttonFrame = CGRectMake(0, 0, 40, 40);

    //Create left Button
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];

    //make the button rounded
    button.layer.cornerRadius = button.frame.size.height / 2;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;

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

            dispatch_async(dispatch_get_main_queue(), ^{
                self.profileImage = tempImage;
            });

        }

    }];

    image = self.profileImage;

    return image;
}

//helper method to show user's profile.

-(void)profileImageTapped:(UIBarButtonItem* )sender{


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
    [query includeKey:@"isLGBT"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){

        // NSArray *activitiesArray = activities;

        if (!error) {
            //get a copy of all activities
            self.allActivitiesArray = activities.copy;

            // Add activities to the map.


            for (Activity *activity in activities){



                self.pinAnnotation = [[CustomMKAnnotation alloc]initWithTitle:activity.activityTitle Location:CLLocationCoordinate2DMake(activity.activityLocation.latitude, activity.activityLocation.longitude) andWithActivity:activity];
                ;
                if ([activity.selectedCategory isEqualToString:@"Festival"]) {
                    [self.festivalActivityArray addObject:self.pinAnnotation];

                }else if ([activity.selectedCategory isEqualToString:@"Cultural"]) {
                    [self.culturalActivityArray addObject:self.pinAnnotation];

                } else if ([activity.selectedCategory isEqualToString:@"Gastronomy"]) {
                    [self.gastronomyActivityArray addObject:self.pinAnnotation];

                } else if ([activity.selectedCategory isEqualToString:@"Night Out"]) {
                    [self.nightOutActivityArray addObject:self.pinAnnotation];

                } else if ([activity.selectedCategory isEqualToString:@"Fitness"]) {
                    [self.fitnessActivityArray addObject:self.pinAnnotation];

                } else if ([activity.selectedCategory isEqualToString:@"Outdoors"]) {
                    [self.outDoorsActivityArray addObject:self.pinAnnotation];

                } else if ([activity.selectedCategory isEqualToString:@"Student Life"]) {
                    [self.studentLifeActivityArray addObject:self.pinAnnotation];
                }


                dispatch_async(dispatch_get_main_queue(), ^{


                    [self.mapView addAnnotation:self.pinAnnotation];
                });


            }



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

#pragma Mark - methods to filter Services with SegmentedControl
- (IBAction)onSegmentSelected:(UISegmentedControl *)sender {

    [self filterLGBTActivities:sender];


}

-(void)filterLGBTActivities:(UISegmentedControl *)sender{

    //remove all anotations from map.
    self.annotationArray = self.mapView.annotations;
    [self.mapView removeAnnotations:self.annotationArray];

    self.lgbtFilteredActivitiesArray = [NSMutableArray new];

    for (Activity * activity in self.activitiesArray) {
        if (sender.selectedSegmentIndex == 1 || (NSInteger)activity.isLBGT == 1) {
            [self.lgbtFilteredActivitiesArray addObject:activity];
            [self addAnnotationsToMapFromSearchResultArray:self.lgbtFilteredActivitiesArray];

        } else {

        }
    }




}

//returns an NSArray of pinAnnotations (CustomMKAnnotation)

-(NSArray *)filterLGBTactivities:(NSMutableArray *)activitiesArray{

    NSMutableArray *filteredActivities = [NSMutableArray new];


    //remove all anotations from map.
    //self.annotationArray = self.mapView.annotations;
    //[self.mapView removeAnnotations:self.annotationArray];

    //self.lgbtFilteredActivitiesArray = [NSMutableArray new];

    for (CustomMKAnnotation * pinAnnotation in activitiesArray) {

        if ([pinAnnotation.activity.isLBGT integerValue] == 1) {

            [filteredActivities addObject:pinAnnotation];
            //   [self addAnnotationsToMapFromSearchResultArray:self.lgbtFilteredActivitiesArray];

        }
        //filteredActivities = self.lgbtFilteredActivitiesArray.copy;
    }

    return filteredActivities;

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

             dispatch_async(dispatch_get_main_queue(), ^{

                 [User currentUser].profileImage = file;
             });

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

    //remove all annotation from map.
    self.annotationArray = self.mapView.annotations;
    [self.mapView removeAnnotations:self.mapView.annotations];

    self.activitySearchResults = [NSMutableArray new];

    if (![searchBar.text isEqualToString:@""]) {

        for (Activity *activity in self.allActivitiesArray) {


            if ([[activity objectForKey:@"activityTitle"] localizedCaseInsensitiveContainsString:searchBar.text] || [[activity objectForKey:@"activityDescription"] localizedCaseInsensitiveContainsString:searchBar.text]) {

                [self.activitySearchResults addObject:activity];

            }
        }


    }

    [self addAnnotationsToMapFromSearchResultArray:self.activitySearchResults];

    [searchBar resignFirstResponder];

}

//helper method

-(void)addAnnotationsToMapFromSearchResultArray:(NSArray *)searchResult{



    for (Activity *activity in searchResult){
        self.pinAnnotation = [[CustomMKAnnotation alloc]initWithTitle:activity.activityTitle Location:CLLocationCoordinate2DMake(activity.activityLocation.latitude, activity.activityLocation.longitude) andWithActivity:activity];
        if ([activity.selectedCategory isEqualToString:@"Festival"]) {
            [self.festivalActivityArray addObject:self.pinAnnotation];

        }else if ([activity.selectedCategory isEqualToString:@"Cultural"]) {
            [self.culturalActivityArray addObject:self.pinAnnotation];

        } else if ([activity.selectedCategory isEqualToString:@"Gastronomy"]) {
            [self.gastronomyActivityArray addObject:self.pinAnnotation];

        } else if ([activity.selectedCategory isEqualToString:@"Night Out"]) {
            [self.nightOutActivityArray addObject:self.pinAnnotation];

        } else if ([activity.selectedCategory isEqualToString:@"Fitness"]) {
            [self.fitnessActivityArray addObject:self.pinAnnotation];

        } else if ([activity.selectedCategory isEqualToString:@"Outdoors"]) {
            [self.outDoorsActivityArray addObject:self.pinAnnotation];

        } else if ([activity.selectedCategory isEqualToString:@"Student Life"]) {
            [self.outDoorsActivityArray addObject:self.pinAnnotation];
        }

        [self.mapView addAnnotation:self.pinAnnotation];
    }
}

#pragma Mark - CLLocationManager Delegate Methods


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{



    if (!self.initialLocation) {
        self.initialLocation = userLocation.location;
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;

        [mapView setRegion:mapRegion animated: NO];
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
    [self.mapView setRegion:region animated:NO];

}


#pragma Mark - MKMapView Delegate Methods.

//returns the view for the selected annotation method.

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{


    //for every custom annotation, check the category, and display the appropriate image/pin for each annotation.

    if ([annotation isKindOfClass:[CustomMKAnnotation class]]) {

        CustomMKAnnotation *pinAnnotation = (CustomMKAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"customAnnotation"];

        //add shadow
        annotationView.layer.shadowColor = [UIColor grayColor].CGColor;
        annotationView.layer.shadowOffset = CGSizeMake(5, 1);
        annotationView.layer.shadowOpacity = 1;
        annotationView.layer.shadowRadius = 2.0;
        annotationView.clipsToBounds = NO;


        //define left call out image


        UIImage *leftCallOutimage = [UIImage new];

        if ([pinAnnotation.activity.selectedCategory isEqualToString:@"Cultural"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@0]) {

            UIImage *image = [UIImage imageNamed:@"culturalPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainCultural.png"];


        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Gastronomy"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@0]){

            UIImage *image = [UIImage imageNamed:@"gastronomyPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainGastronomy.png"];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Night Out"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@0]){

            UIImage *image = [UIImage imageNamed:@"nightOutPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainNightout.png"];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Festival"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@0]){

            UIImage *image = [UIImage imageNamed:@"festivalPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainFestival.png"];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Fitness"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@0]){

            UIImage *image = [UIImage imageNamed:@"fitnessPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainFitness.png"];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Outdoors"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@0]){

            UIImage *image = [UIImage imageNamed:@"outdoorsPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainOutdoors.png"];

        } else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Student Life"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@0]){

            UIImage *image = [UIImage imageNamed:@"studentLifePin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainOutdoors.png"];

        } else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Outdoors"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@1]){

            UIImage *image = [UIImage imageNamed:@"uOutdoorsPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainOutdoors.png"];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Fitness"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@1]){

            UIImage *image = [UIImage imageNamed:@"uFitnessPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainOutdoors.png"];
        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Festival"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@1]){

            UIImage *image = [UIImage imageNamed:@"uFestivalPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainOutdoors.png"];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Night Out"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@1]){

            UIImage *image = [UIImage imageNamed:@"uNightOutPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainOutdoors.png"];

        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Gastronomy"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@1]){

            UIImage *image = [UIImage imageNamed:@"uGastronomyPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainOutdoors.png"];
        }else if([pinAnnotation.activity.selectedCategory isEqualToString:@"Cultural"] && [(NSNumber *)pinAnnotation.activity.studentsOnly isEqual:@1]){

            UIImage *image = [UIImage imageNamed:@"uCulturalPin.png"];
            annotationView.image =  [self resizeImageForPins:image];
            leftCallOutimage = [UIImage imageNamed:@"mainOutdoors.png"];
        }



        //add profile image to annotation call out
        PFQuery *activityQuery = [Activity query];
        [activityQuery includeKey:@"host"];
        // activityQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;


        [activityQuery getObjectInBackgroundWithId:pinAnnotation.activity.objectId block:^(PFObject *object, NSError *error) {


            Activity *activity = pinAnnotation.activity;
            User *host = activity.host;

            //check if the user exists for the activity and check if the user has a picture.
            if(!(host.profileImage == nil) || !(host == nil)){


                [pinAnnotation.activity.host.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

                    //if there is no error then display the image for the user who posted activity.
                    if(!error){

                        dispatch_async(dispatch_get_main_queue(), ^{


                            UIImage *image = [UIImage imageWithData:data];
                            CGSize scaledSize = CGSizeMake(40, 40);
                            UIGraphicsBeginImageContext(scaledSize);
                            [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
                            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            UIImageView *profileImageView = [[UIImageView alloc]initWithImage:scaledImage];
                            profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2;
                            profileImageView.layer.masksToBounds = YES;
                            profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
                            profileImageView.clipsToBounds = YES;
                            profileImageView.userInteractionEnabled = YES;
                            annotationView.leftCalloutAccessoryView = profileImageView;


                        });

                    }





                } ];


            }else{

                dispatch_async(dispatch_get_main_queue(), ^{


                    UIImage *image = [UIImage imageNamed:@"defaultImage.png"];
                    CGSize scaledSize = CGSizeMake(40, 40);
                    UIGraphicsBeginImageContext(scaledSize);
                    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
                    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    UIImageView *profileImageView = [[UIImageView alloc]initWithImage:scaledImage];
                    profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2;
                    profileImageView.layer.masksToBounds = YES;
                    profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
                    profileImageView.clipsToBounds = YES;
                    profileImageView.userInteractionEnabled = YES;
                    annotationView.leftCalloutAccessoryView = profileImageView;

                });

            }

        }];


        if(annotationView == nil){
            annotationView = pinAnnotation.annotationView;
        }else{
            annotationView.annotation = annotation;
        }


        return annotationView;
    } else{
        return nil;
    }



}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    NSString *action = (__bridge NSString *)context;
    if ([action isEqualToString:ANNOTATION_SELECTED_DESELECTED]) {
        BOOL annotationSelected = [[change valueForKey:@"new"] boolValue];
        if (annotationSelected) {

            self.activityIsSelected = YES;
            // Accions when annotation selected
        }else {
            self.activityIsSelected = NO;
            // Accions when annotation deselected
        }
    }
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *anAnnotationView in views) {
        [anAnnotationView setCanShowCallout:YES];
        [anAnnotationView addObserver:self
                           forKeyPath:@"selected"
                              options:NSKeyValueObservingOptionNew
                              context:(__bridge void *)(ANNOTATION_SELECTED_DESELECTED)];
    }
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // Annotation is your custom class that holds information about the annotation
    if ([view.annotation isKindOfClass:[CustomMKAnnotation class]]) {
        CustomMKAnnotation *annot = view.annotation;
        // NSInteger index = [self.annotationArray indexOfObject:annot];


        //add profile image to annotation call out
        PFQuery *activityQuery = [Activity query];
        [activityQuery includeKey:@"host"];
        // activityQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [activityQuery getObjectInBackgroundWithId:annot.activity.objectId block:^(PFObject *object, NSError *error) {
            if(error){
                return;
            }

            Activity *activity = (Activity *)object;
            User *host = activity.host;

            //check if the user exists for the activity and check if the user has a picture.
            if(!(host.profileImage == nil) || !(host == nil)){
                [host.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

                    //if there is no error then display the image for the user who posted activity.
                    if(!error){


                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImage *image = [UIImage imageWithData:data];
                            CGSize scaledSize = CGSizeMake(40, 40);
                            UIGraphicsBeginImageContext(scaledSize);
                            [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
                            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            UIImageView *profileImageView = [[UIImageView alloc]initWithImage:scaledImage];
                            profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2;
                            profileImageView.layer.masksToBounds = YES;
                            profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
                            profileImageView.clipsToBounds = YES;
                            profileImageView.userInteractionEnabled = YES;
                            
                        });

                    }
                    
                    
                }
                 
                 
                 ];
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIImage *image = [UIImage imageNamed:@"defaultImage.png"];
                    CGSize scaledSize = CGSizeMake(40, 40);
                    UIGraphicsBeginImageContext(scaledSize);
                    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
                    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    UIImageView *profileImageView = [[UIImageView alloc]initWithImage:scaledImage];
                    profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2;
                    profileImageView.layer.masksToBounds = YES;
                    profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
                    profileImageView.clipsToBounds = YES;
                    profileImageView.userInteractionEnabled = YES;
                    //                annotationView.leftCalloutAccessoryView = profileImageView;
                });
            }
            
            
            
        } ];
        
        
        
        
    }
}


//Allow user to select their activity.

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    
    UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UIViewController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:@"detailNavVc"];
    
    //set the activity that is goign to be shared through out the app - to dispay to the user when the user clicks on detail.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CustomMKAnnotation *annotation = view.annotation;
    appDelegate.sharedActivity = annotation.activity;
    
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
