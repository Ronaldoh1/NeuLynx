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
#import "CustomCell.h"
#import "SearchResultsTVC.h"

@interface SearchVC ()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CLLocationManagerDelegate>

//Search Controller
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;


//TABLE VIEW
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *activities;
@property NSMutableArray *filteredTableDataArray;
@property BOOL isFiltered;
@property BOOL isAscending;

//CORE LOCATION
@property CLLocationManager *locationManager;
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
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = [NSString stringWithFormat:@"Search for %@", self.selectedCategory];
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Set up initial location manager - initialize and set delegate.
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];

    //Instantiate View Controller with Iddentifier - this is necessary because there is no connection in our storyboard to our search results.

    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];

    //get an instance of UISearch Controller
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:searchResultsController];

    self.searchController.searchResultsUpdater = self;

    // We need to create our SearchBar Programatically
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);

    self.tableView.tableHeaderView = self.searchController.searchBar;

}

-(void)pulldata{

    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.currentLocation];
    PFQuery *query = [Activity query];
    [query whereKey:@"activityLocation" nearGeoPoint:geoPoint withinMiles:50.0];
    [query whereKey:@"selectedCategory" equalTo:self.selectedCategory];

    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){
        if (!error) {

            self.activities = [[NSArray alloc]initWithArray:activities];
            [self.tableView reloadData];

        }
    }];

}

#pragma marks - TableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.activities.count;
}
-(CustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //set up the cell
    CustomCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //for every row in parse, we are getting a PFObject back. In our case, we will be getting an activity. For every activity, we will be retrieving values to populate the cell.
    Activity *tempActivity = [Activity new];

    tempActivity = [self.activities objectAtIndex:indexPath.row];

    //change the background color
    cell.backgroundColor = [UIColor clearColor];

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    //chnage the cell accessory
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    // Set searchString equal to what's typed into the searchbar
    NSString *searchString = self.searchController.searchBar.text;

    [self updateFilteredContentForActivity:searchString];

    // If searchResultsController
    if (self.searchController.searchResultsController) {

        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;

        // Present SearchResultsTableViewController as the topViewController
        SearchResultsTVC *vc = (SearchResultsTVC *)navController.topViewController;

        // Update searchResults
        vc.searchResults = self.searchResults;

        // And reload the tableView with the new data
        [vc.tableView reloadData];
    }
}

// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForActivity:(NSString *)searchStr{

    if (searchStr == nil) {

        // If empty the search results are the same as the original data
        self.searchResults = [self.searchResults mutableCopy];

    } else {

        NSMutableArray *searchResults = [[NSMutableArray alloc] init];

        //here we want to make sure that we return the activities that contain the string for non-case sensitive strings.

        for (Activity *activity in self.activities) {
            NSRange titleRange = [activity.activityTitle rangeOfString:searchStr options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [activity.activityDescription rangeOfString:searchStr options:NSCaseInsensitiveSearch];

            if (titleRange.location != NSNotFound || descriptionRange.location != NSNotFound) {

                [searchResults addObject:activity];
            }
        }

        self.searchResults = searchResults;

    }
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
        appDelegate.sharedActivity = self.activities[indexPath.row];
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
    
    [self.locationManager stopUpdatingLocation];
}
@end
