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

@interface SearchVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>

//TABLE VIEW
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *activitiesForSearchArray;

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




    NSMutableArray *activitiesForSearchArray = [NSMutableArray new];

//
//    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.currentLocation];
//    PFQuery *query = [Activity query];
//
//
//
//    [query whereKey:@"activityLocation" nearGeoPoint:geoPoint withinMiles:50.0];
//    [query whereKey:@"selectedCategory" equalTo:self.selectedCategory];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){
//
//        // NSArray *activitiesArray = activities;
//        NSLog(@"%@ wattttt", activities);
//
//
//        if (!error) {
//            // Add activities to the map.
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                // NSLog(@"activities are %@",activitiesArray);
//
//                for (Activity *activity in activities){
//                    NSLog(@"%@", activity);
//                    [self.activitiesForSearchArray addObject:activity];
//                         [self.tableView reloadData];
//
//                }
//
//
//                //[self.mapView addAnnotations:self.gastronomyActivityArray];
//                
//
//            });
//        }
//
//
//    }];


}



//-(void)gotActivities:(NSArray *)activitiesArray{
//
//    self.activitiesArray = activitiesArray.mutableCopy;
//
//    NSLog(@"%@", self.activitiesArray);
//
//
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
//                dispatch_async(dispatch_get_main_queue(), ^{
//    
//                    // NSLog(@"activities are %@",activitiesArray);
//    
//                    for (Activity *activity in activities){
//                        NSLog(@"%@", activity);
//                        [self.activitiesForSearchArray addObject:activity];
//                             [self.tableView reloadData];
//    
//                    }
//    
//    
//                    //[self.mapView addAnnotations:self.gastronomyActivityArray];
//                    
//    
//                });
            }
            [self.tableView reloadData];
    
    
        }];

}

-(void)download{

    [ActivitiesDownloader downloadActivitiesForLocation:self.currentLocation andCategory:self.selectedCategory withCompletion:^(NSArray * array) {
        self.activitiesForSearchArray = [NSMutableArray arrayWithArray:array];

    }];


}

//-(void)downloadActivitiesAndDisplayOnMap{
//
//    self.activitiesForSearchArray = [NSMutableArray new];
//
//        NSLog(@"%@ ahhhhh", self.currentLocation);
//
//    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.currentLocation];
//    PFQuery *query = [Activity query];
//
//
//
//    [query whereKey:@"activityLocation" nearGeoPoint:geoPoint withinMiles:50.0];
//    [query whereKey:@"selectedCategory" equalTo:self.selectedCategory];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){
//
//        // NSArray *activitiesArray = activities;
//         NSLog(@"%@ wattttt", activities);
//
//
//        if (!error) {
//            // Add activities to the map.
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                // NSLog(@"activities are %@",activitiesArray);
//
//                for (Activity *activity in activities){
//                    NSLog(@"%@", activity);
//                    [self.activitiesForSearchArray addObject:activity];
//
//                }
//
//
//                //[self.mapView addAnnotations:self.gastronomyActivityArray];
//
//
//            });
//
//
//
//        } else {
//           //display error
//
//
//        }
//
//
//    }
//
//
//
//
//     ];
//    //once we have the array with activity, we need to ad them to the map.
//    //    [self.mapView addAnnotations:self.festivalActivityArray];
//    //                [self.mapView addAnnotations:self.culturalActivityArray];
//    //                [self.mapView addAnnotations:self.gastronomyActivityArray];
//    //    //            [self.mapView addAnnotations:self.nightOutActivityArray];
//    //    //             [self.mapView addAnnotations:self.fitnessActivityArray];
//    //    //            [self.mapView addAnnotations:self.outDoorsActivityArray];
//    
//    
//    
//    // NSLog(@"%@", self.gastronomyActivityArray);
//
//    
//}


#pragma marks - TableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSLog(@"%lu YOOOOOOOOOOOO", (unsigned long)self.activitiesForSearchArray.count);
    return self.activitiesForSearchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //set up the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //for every row in parse, we are getting a PFObject back. In our case, we will be getting an activity. For every activity, we will be retrieving values to populate the cell.

    Activity *tempActivity = [self.activitiesForSearchArray objectAtIndex:indexPath.row];

//    NSDictionary *tempDictionary = [[NSDictionary alloc]initWithDictionary:[self.activitiesForSearchArray objectAtIndex:indexPath.row]];

    cell.textLabel.text = [tempActivity objectForKey:@"activityTitle"];

    cell.detailTextLabel.text = [tempActivity objectForKey:@"activityDescription"];


    return cell;
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
