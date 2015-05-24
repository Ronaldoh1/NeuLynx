//
//  Activity.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/22/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

@interface Activity : PFObject<PFSubclassing>

@property NSString *activityTitle;
@property NSString *activityDescription;
@property PFGeoPoint *activityLocation;
@property NSDate *startTimeAndDate;
@property NSDate *endTimeAndDate;
@property PFFile *activityImage1;
@property PFFile *activityimage2;
@property User *host;

+(NSString *)parseClassName;



@end

