//
//  SelectLocationVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/26/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SelectLocationVC.h"
#import <MapKit/MapKit.h>
#import "User.h"
#import "MRProgressOverlayView.h"
#import "MRProgress.h"


@interface SelectLocationVC ()<MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property UIWindow *window;

//*********Core Location Properties***********//
@property CLLocationManager *locationManager;
@property CLLocation *initialLocation;
@property BOOL didGetUserLocation;

@end

@implementation SelectLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    


}
-(void)initialSetUp{



    //Get reference to entire window
    self.window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];


    //did get user's location should initially be set to false.
    self.didGetUserLocation = NO;



    //set color for search bar
    self.searchBar.barTintColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Set Location!";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    [self.searchBar setTintColor:[UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1]];

    //Get user's information and display current location and profile picture.
    [MRProgressOverlayView showOverlayAddedTo:self.window title:@"Loading" mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [self displayUserLocation:^{
        [self getUserCurrentLocation];

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

#pragma mark - UISearchBar Delegate Methods

//**in this delegate method, we can hide keyboard, when search button is clicked. Also in this method we perform the search of the string entered by the user and drop a pin annotation on our map.

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    //dismiss keyboard
    [self.searchBar resignFirstResponder];

    //Instatiate geolocation
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder geocodeAddressString:self.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {

        //Mark location and center
        CLPlacemark *placemark = [placemarks objectAtIndex:0];

        MKCoordinateRegion region;

        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];

        //Drop the Pin

        MKPointAnnotation *annotation = [MKPointAnnotation new];
        [annotation setCoordinate:newLocation];
        [annotation setTitle:self.searchBar.text];
        [self.mapView addAnnotation:annotation];

        //Scroll to search result

        MKMapRect mapRect = [self.mapView visibleMapRect];
        MKMapPoint mapPoint = MKMapPointForCoordinate([annotation coordinate]);
        mapRect.origin.x = mapPoint.x - mapRect.size.width * 0.5;
        mapRect.origin.y = mapPoint.y - mapRect.size.height * 0.25;
        [self.mapView setVisibleMapRect:mapRect animated:YES];


    }];

}

#pragma mark - MapKit Delegate Methods

//get user's location and zoom to that location - zoom not animated.

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

    if (!self.initialLocation) {
        self.initialLocation = userLocation.location;
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;

        [mapView setRegion:mapRegion animated: NO];
    }

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    pinAnnotation.canShowCallout = YES;

    UIButton *selectLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectLocationButton.frame = CGRectMake(0, 0, 70, 20);
    [selectLocationButton setTitle:@"Select" forState:UIControlStateNormal];
    [selectLocationButton setTitleColor:[UIColor colorWithRed:34.0/255.0 green:85.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    selectLocationButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [selectLocationButton.layer setBorderWidth:1];
    [selectLocationButton.layer setBorderColor:[UIColor blueColor].CGColor];
    pinAnnotation.rightCalloutAccessoryView = selectLocationButton;



//    NSLog(@"%f", [annotation coordinate].latitude);
//    NSLog(@"%f", [annotation coordinate].longitude);
    return pinAnnotation;
}




- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"Latitude: %f", view.annotation.coordinate.latitude);
    NSLog(@"Longitude: %f", view.annotation.coordinate.longitude);
}

//Allow user to select their location.

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{

    //ask the view to give you the coordinate lat and long

    NSLog(@"lat is: %f and long is: %f", [[view annotation] coordinate].latitude, [[view annotation] coordinate].longitude);

    self.activityGeoPoint = [PFGeoPoint new];

    self.activityGeoPoint.latitude = [[view annotation] coordinate].latitude;
    self.activityGeoPoint.longitude = [[view annotation] coordinate].longitude;

    [self performSegueWithIdentifier:@"backToPostActivity" sender:self];
}

//**********************BLOCKS***********************************************//
-(void)displayUserLocation:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}



@end
