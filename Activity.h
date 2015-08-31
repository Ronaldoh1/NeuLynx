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

@property (nonatomic, strong) NSString *activityTitle;
@property (strong, atomic) NSString *activityDescription;
@property (strong, atomic) PFGeoPoint *activityLocation;
@property (strong, atomic) NSString *activityAddress;
@property (strong, atomic) NSDate *startTimeAndDate;
@property (strong, atomic) NSNumber *maxNumberOfParticipants;
@property (strong, atomic) NSDate *endTimeAndDate;
@property (strong, atomic) PFFile *activityImage1;
@property (strong, atomic) PFFile *activityimage2;
@property (strong, atomic) User *host;
@property (strong, atomic) NSString *selectedCategory;
@property (strong, atomic) NSNumber *numberOfpaticipants;
@property (strong, atomic) NSMutableArray *acceptedPeopleArray;
@property (strong, atomic) NSMutableArray *RequestsArray;

//**0 = anyone 1 = students only**
@property (strong, atomic) NSNumber *studentsOnly;

//**0 = public 1 = private**
@property (strong, atomic) NSNumber *activityPrivacy;

//**0 = No 1 = Yes**
@property (strong, atomic) NSNumber *isLBGT;

@property (strong, atomic)NSMutableArray *exclusiveInvitesArray;

//**0 = No 1 = Yes**
@property (strong, atomic) NSNumber* isNew;

@property NSNumber *flagCount;

@property NSString *activityDate;

+(NSString *)parseClassName;



@end

