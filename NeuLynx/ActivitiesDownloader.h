//
//  ActivitiesDownloader.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/3/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>


@interface ActivitiesDownloader : NSObject <MKMapViewDelegate>
+(void)downloadActivitiesForLocation:(CLLocation *)location withCompletion:(void(^)(NSArray *))complete;



@end
