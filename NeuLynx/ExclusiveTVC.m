//
//  ExclusiveTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/31/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "ExclusiveTVC.h"
#import "CustomCell.h"
#import "ExclusiveInvite.h"
#import "AppDelegate.h"

@interface ExclusiveTVC ()<CLLocationManagerDelegate>
@property NSMutableArray *exclusiveInvitesArray;

//CORE LOCATION
@property CLLocationManager *locationManager;
@property NSMutableArray *activitiesArray;
@property CLLocation *currentLocation;

@end

@implementation ExclusiveTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initialSetUp];
}

-(void)initialSetUp{
    //setting image to Navigation Bar's title

    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Exclusive Activities";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Set up initial location manager - initialize and set delegate.
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];

    [self downloadExclusiveInvites];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}




//Download exclusive activities


-(void)downloadExclusiveInvites{



    PFQuery *query = [PFQuery queryWithClassName:@"ExclusiveInvite"];

    [query whereKey:@"exclusiveInvitee" equalTo:[User currentUser]];
    [query whereKey:@"isDispositioned" equalTo:@0];
    [query includeKey:@"activity"];
    [query includeKey:@"activity.host"];
    [query includeKey:@"exclusiveInvitee"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *exclusiveInvitesArray, NSError *error){


        if (!error) {
            //get a copy of all activities
            self.exclusiveInvitesArray = [NSMutableArray arrayWithArray:exclusiveInvitesArray];
            // Add activities to the map.
            if (self.exclusiveInvitesArray.count == 0) {

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Invites 😕" message:@"You have 0 invites at the momment! Be adventurous and find activities happening near you. Simply head over to the map and check them out!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

                [alertView show];
            }


            }
        [self.tableView reloadData];

    }];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.exclusiveInvitesArray count];
}


- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    //change the background color
    cell.backgroundColor = [UIColor clearColor];

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    //chnage the cell accessory
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;



    //For every exclusive invite, we need to popuplate each cell

    ExclusiveInvite *exclusiveInvite = (ExclusiveInvite *)self.exclusiveInvitesArray[indexPath.row];

    Activity *activity = [Activity new];

    activity = (Activity *)exclusiveInvite.activity;

    [activity fetchIfNeededInBackground];

  //  User CoreLocation to get distance between activity and current user's location.
    CLLocation *activityLocation = [[CLLocation alloc] initWithLatitude:activity.activityLocation.latitude longitude:activity.activityLocation.longitude];

    CLLocationDistance distance = [activityLocation distanceFromLocation:self.currentLocation];


    double distanceInMiles = distance * (0.00062137);

    //[(User *)activity.host fetchInBackground];

    User * user = [User new];

    user = (User *)activity.host;
    
    [user.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        if (!error) {

            UIImage *image = [UIImage imageWithData:data];
            cell.userProfileImage.image = image;
        }else{
            NSLog(@" %@       errorrrrrr %@", error.localizedDescription, error.description);
        }


    }];

    cell.activityTitleLabel.text = activity.activityTitle;
    cell.activityDescriptionText.text = activity.activityDescription;
    cell.distanceToActivityLabel.text = [NSString stringWithFormat:@"%.2f Miles Away", distanceInMiles];



    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UIViewController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:@"detailNavVc"];

    //set the activity that is goign to be shared through out the app - to dispay to the user when the user clicks on detail.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


    appDelegate.sharedActivity = (Activity *)(((ExclusiveInvite *)self.exclusiveInvitesArray[indexPath.row]).activity);
    appDelegate.exclusiveInvite = ((ExclusiveInvite *)self.exclusiveInvitesArray[indexPath.row]);
    
    [self presentViewController:detailVC animated:YES completion:nil];
    
}

#pragma marks - Corelocation

//First we get the user's location - and then download the activities that are within 50 miles radius.

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = locations.firstObject;

    if (self.currentLocation) {
        //[self downloadActivitiesAndDisplayOnMap];

        //[self pulldata];

    }

    [self.locationManager stopUpdatingLocation];
}

@end
