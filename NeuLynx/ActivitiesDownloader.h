//
//  ActivitiesDownloader.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/12/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

//Use delegation to download the activities.


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ActivitiesDownloader : NSObject

@property NSMutableArray *activitiesArray;


+(void)downloadActivitiesForLocation:(CLLocation *)location andCategory:(NSString *)category withCompletion:(void (^)(NSArray *))complete;


@end
