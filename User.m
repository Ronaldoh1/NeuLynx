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
@dynamic profileImage;
@dynamic userHomeLocation;
@dynamic gender;
@dynamic orientation;
@dynamic languageArray;
@dynamic personalityArray;
@dynamic travelPreferencesArray;
@dynamic age;
@dynamic personalities;
@dynamic travelPreferences;
@dynamic userCurrentCity;
@dynamic userAdministrativeArea;
@dynamic userCountryCode;


+(void)load {
    [self registerSubclass];
}

@end
