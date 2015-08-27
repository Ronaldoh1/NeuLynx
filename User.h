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
@property (strong, atomic) NSString *name;
@property (strong, atomic) NSString *aboutMe;
@property (strong, atomic) PFFile *profileImage;
@property (strong, atomic) PFGeoPoint *userHomeLocation;
@property (strong, atomic) NSString *gender;
@property (strong, atomic) NSString *orientation;
@property (strong, atomic) NSMutableArray *languageArray;
@property (strong, atomic) NSString *age;
@property (strong, atomic) NSDictionary *travelPreferences;
@property (strong, atomic) NSString *userCurrentCity;
@property (strong, atomic) NSString *userAdministrativeArea;
@property (strong, atomic) NSString *userCountryCode;
@property (strong, atomic) PFGeoPoint *currentLoccation;

//List of Users who sent Messages
@property (strong, atomic) NSMutableArray *inboxArray;

//Preferences
@property (strong, atomic) NSMutableArray *travelPreferencesArray;
@property (strong, atomic) NSMutableArray *TravelPreferencesBoolArray;

@property (strong, atomic) NSMutableArray *personalityArray;
@property (strong, atomic) NSMutableArray *personalityBoolArray;
@property (assign) BOOL isFbUser;

//User Rating
@property (strong, atomic) NSNumber *userRating;

//Activities Joined & Accepted
@property (strong, atomic) NSMutableArray *pastActivities;

@property (strong, atomic) NSMutableArray *exclusiveInvitesArray;
@property (strong, atomic) NSNumber *activitiesJoinedCounter;


@end
