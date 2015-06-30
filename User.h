//
//  User.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>
@property NSString *name;
@property NSString *aboutMe;
@property PFFile *profileImage;
@property PFGeoPoint *userHomeLocation;
@property NSString *gender;
@property NSString *orientation;
@property NSMutableArray *languageArray;
@property NSString *age;
@property NSDictionary *travelPreferences;
@property NSString *userCurrentCity;
@property NSString *userAdministrativeArea;
@property NSString *userCountryCode;

//Preferences
@property NSMutableArray *travelPreferencesArray;
@property NSMutableArray *TravelPreferencesBoolArray;

@property NSMutableArray *personalityArray;
@property NSMutableArray *personalityBoolArray;
@property BOOL isFbUser;

//User Rating
@property NSNumber *userRating;


@end
