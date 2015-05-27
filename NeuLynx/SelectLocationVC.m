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

@interface SelectLocationVC ()<MKMapViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SelectLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    


}
-(void)initialSetUp{





    //set color for search bar
    self.searchBar.barTintColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Set Location!";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    [self.searchBar setTintColor:[UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1]];
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



@end
