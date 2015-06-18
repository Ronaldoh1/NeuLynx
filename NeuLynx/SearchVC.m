//
//  SearchVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/30/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SearchVC.h"
#import <Parse/Parse.h>
#import "Activity.h"
#import <CoreLocation/CoreLocation.h>
#import "ActivitiesDownloader.h"
#import "AppDelegate.h"
#import "CustomMKAnnotation.h"

@interface SearchVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>

//TABLE VIEW
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *activitiesForSearchArray;
@property NSMutableArray *filteredTableDataArray;
@property BOOL isFiltered;
@property BOOL isAscending;

//CORE LOCATION
@property CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSMutableArray *activitiesArray;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performInitialSetUp];
    [self performSelector:@selector(pulldata)];

}


-(void)performInitialSetUp{

    //Set the title for the VC.
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = [NSString stringWithFormat:@"Search for %@", self.selectedCategory];
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Set up initial location manager - initialize and set delegate.
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];




}

//Helper Method to sort Array by distance
//-(void)sortArrayByDistance{
//
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"distanceFromCurrentLocation" ascending:self.isAscending];
//}



-(void)pulldata{

        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.currentLocation];
        PFQuery *query = [Activity query];
    
    
    
        [query whereKey:@"activityLocation" nearGeoPoint:geoPoint withinMiles:50.0];
        [query whereKey:@"selectedCategory" equalTo:self.selectedCategory];
        [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){
    
            // NSArray *activitiesArray = activities;
            NSLog(@"%@ wattttt", activities);
    
    
            if (!error) {

                self.activitiesForSearchArray = [[NSArray alloc]initWithArray:activities];
                [self.tableView reloadData];

            }

    
        }];

}

-(void)download{

    [ActivitiesDownloader downloadActivitiesForLocation:self.currentLocation andCategory:self.selectedCategory withCompletion:^(NSArray * array) {
        self.activitiesForSearchArray = [NSMutableArray arrayWithArray:array];

    }];


}

#pragma mark - UISearchBarDelegate Delegate 

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (self.searchBar.text.length == 0) {
        self.isFiltered = NO;
    }else{
        self.isFiltered = YES;
        self.filteredTableDataArray = [NSMutableArray new];

        for (Activity *activity in self.activitiesForSearchArray) {
            NSRange titleRange = [activity.activityTitle rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
              NSRange descriptionRange = [activity.activityTitle rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];

            if (titleRange.location != NSNotFound || descriptionRange.location != NSNotFound) {

                [self.filteredTableDataArray addObject:activity];
            }
        }

    }
    [self.tableView reloadData];
}



#pragma marks - TableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.isFiltered)
        return self.filteredTableDataArray.count;
    else
    return self.activitiesForSearchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //set up the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //for every row in parse, we are getting a PFObject back. In our case, we will be getting an activity. For every activity, we will be retrieving values to populate the cell.
    Activity *tempActivity = [Activity new];

    if (self.isFiltered == YES) {

        tempActivity = [self.filteredTableDataArray objectAtIndex:indexPath.row];
    }else{

    tempActivity = [self.activitiesForSearchArray objectAtIndex:indexPath.row];
    }

//    NSDictionary *tempDictionary = [[NSDictionary alloc]initWithDictionary:[self.activitiesForSearchArray objectAtIndex:indexPath.row]];


    //change the color of text
    cell.textLabel.textColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];

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

    //Use CoreLocation to get distance between activity and user's location.
    CLLocation *activityLocation = [[CLLocation alloc]initWithLatitude:tempActivity.activityLocation.latitude longitude:tempActivity.activityLocation.longitude];

    CLLocationDistance distance = [activityLocation distanceFromLocation:self.currentLocation];

    double distanceInMiles = distance * (0.00062137);

    cell.textLabel.text = [tempActivity objectForKey:@"activityTitle"];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f Miles Away", distanceInMiles];


    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
UIViewController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:@"detailNavVc"];

//set the activity that is goign to be shared through out the app - to dispay to the user when the user clicks on detail.
AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

//CustomMKAnnotation *annotation = view.annotation;
    if (self.isFiltered) {
        appDelegate.sharedActivity = self.filteredTableDataArray[indexPath.row];
    } else {
        appDelegate.sharedActivity = self.activitiesForSearchArray[indexPath.row];
    }


[self presentViewController:detailVC animated:YES completion:nil];

}
#pragma marks - Corelocation

//First we get the user's location - and then download the activities that are within 50 miles radius.


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = locations.firstObject;

    if (self.currentLocation) {
           //[self downloadActivitiesAndDisplayOnMap];


            [self pulldata];


    }




    NSLog(@"%@", self.currentLocation);
    [self.locationManager stopUpdatingLocation];
}


@end
