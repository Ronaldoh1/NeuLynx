//
//  User.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SocialTracker.h"

@class SocialTracker;

@interface User : PFUser<PFSubclassing>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *aboutMe;
@property (nonatomic, strong) PFFile *profileImage;
@property (nonatomic, strong) PFGeoPoint *userHomeLocation;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *orientation;
@property (nonatomic, strong) NSMutableArray *languageArray;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSDictionary *travelPreferences;
@property (nonatomic, strong) NSString *userCurrentCity;
@property (nonatomic, strong) NSString *userAdministrativeArea;
@property (nonatomic, strong) NSString *userCountryCode;
@property (nonatomic, strong) PFGeoPoint *currentLoccation;

//List of Users who sent Messages
@property (nonatomic, strong) NSMutableArray *inboxArray;

//Preferences
@property (nonatomic, strong) NSMutableArray *travelPreferencesArray;
@property (nonatomic, strong) NSMutableArray *TravelPreferencesBoolArray;

@property (nonatomic, strong) NSMutableArray *personalityArray;
@property (nonatomic, strong) NSMutableArray *personalityBoolArray;
@property (assign) BOOL isFbUser;

//User Rating
@property (nonatomic, strong) NSNumber *userRating;

//Activities Joined & Accepted
@property (nonatomic, strong) NSMutableArray *pastActivities;

@property (nonatomic, strong) NSMutableArray *exclusiveInvitesArray;
@property (nonatomic, strong) NSNumber *activitiesJoinedCounter;


@end
