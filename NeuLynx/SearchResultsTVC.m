//
//  SearchResultsTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/30/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SearchResultsTVC.h"
#import "CustomCell.h"
#import "Activity.h"
#import "AppDelegate.h"

@interface SearchResultsTVC ()<CLLocationManagerDelegate>

//CORE LOCATION
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation SearchResultsTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //Set up initial location manager - initialize and set delegate.
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.searchResults.count;
}

- (CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Activity *tempActivity = [Activity new];
    tempActivity = [self.searchResults objectAtIndex:indexPath.row];

    //Use CoreLocation to get distance between activity and user's location.
    CLLocation *activityLocation = [[CLLocation alloc]initWithLatitude:tempActivity.activityLocation.latitude longitude:tempActivity.activityLocation.longitude];
    CLLocationDistance distance = [activityLocation distanceFromLocation:self.currentLocation];
    double distanceInMiles = distance * (0.00062137);

    [tempActivity.host.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.userProfileImage.image = image;
        }

    }];


    cell.activityTitleLabel.text = [tempActivity objectForKey:@"activityTitle"];
    cell.activityTitleLabel.textColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1];
    cell.activityDescriptionText.text = [tempActivity objectForKey:@"activityDescription"];
    cell.distanceToActivityLabel.text = [NSString stringWithFormat:@"%.2f Miles Away", distanceInMiles];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UIViewController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:@"detailNavVc"];

    //set the activity that is goign to be shared through out the app - to dispay to the user when the user clicks on detail.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.sharedActivity = self.searchResults[indexPath.row];

    [self presentViewController:detailVC animated:YES completion:nil];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = locations.firstObject;

    if (self.currentLocation) {
        //[self downloadActivitiesAndDisplayOnMap];


        //  [self pulldata];
        
        
    }
    [self.locationManager stopUpdatingLocation];
}

@end
