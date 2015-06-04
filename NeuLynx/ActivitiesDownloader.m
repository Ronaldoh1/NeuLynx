//
//  ActivitiesDownloader.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/3/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "ActivitiesDownloader.h"
#import "Activity.h"
#import "MapVC.h"




@implementation ActivitiesDownloader


//implement the method to download data from Parse
+(void)downloadActivitiesForLocation:(CLLocation *)location withCompletion:(void (^)(NSArray *))complete{
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:location];
    PFQuery *query = [Activity query];

    [query whereKey:@"activityLocation" nearGeoPoint:geoPoint withinMiles:50.0];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){

        NSArray *activitiesArray = activities;
            complete(activitiesArray);


    }

     ];

}



@end
