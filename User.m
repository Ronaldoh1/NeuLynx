//
//  User.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic name;
@dynamic aboutMe;
@dynamic profileImage;
@dynamic userHomeLocation;
@dynamic gender;
@dynamic orientation;
@dynamic languageArray;
@dynamic age;
@dynamic travelPreferences;
@dynamic userCurrentCity;
@dynamic userAdministrativeArea;
@dynamic userCountryCode;
@dynamic TravelPreferencesBoolArray;
@dynamic travelPreferencesArray;
@dynamic personalityBoolArray;
@dynamic personalityArray;
@dynamic isFbUser;
@dynamic userRating;
@dynamic pastActivities;
@dynamic inboxArray;
@dynamic currentLoccation;
@dynamic exclusiveInvitesArray;
@dynamic activitiesJoinedCounter;

+(void)load {
    [self registerSubclass];
}

@end
