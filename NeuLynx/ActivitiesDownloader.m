//
//  ActivitiesDownloader.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/12/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "ActivitiesDownloader.h"
#import <Parse/Parse.h>
#import "Activity.h"
#import "SearchVC.h"

@implementation ActivitiesDownloader

//implement the method to downlaod date from Parse

+(void)downloadActivitiesForLocation:(CLLocation *)location andCategory:(NSString *)category withCompletion:(void (^)(NSArray *))complete
{


    NSMutableArray *activitiesForSearchArray = [NSMutableArray new];


    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:location];
    PFQuery *query = [Activity query];

    [query whereKey:@"activityLocation" nearGeoPoint:geoPoint withinMiles:50.0];
    [query whereKey:@"flagCount" lessThan:@5];
    [query whereKey:@"selectedCategory" equalTo:category];
    [query includeKey:@"host"];


    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){

        // NSArray *activitiesArray = activities;
        NSLog(@"%@ wattttt", activities);


        if (!error) {
            // Add activities to the map.
            dispatch_async(dispatch_get_main_queue(), ^{

                for (Activity *activity in activities){
                    NSLog(@"%@", activity);
                    [activitiesForSearchArray addObject:activity];

                }

            });

        } else {
            //display error
        }
    }];
    
    complete(activitiesForSearchArray);
    
}




@end
