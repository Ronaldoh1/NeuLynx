//
//  Activity.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/22/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "Activity.h"

@implementation Activity
@dynamic activityTitle;
@dynamic activityDescription;
@dynamic activityLocation;
@dynamic activityAddress;
@dynamic startTimeAndDate;
@dynamic endTimeAndDate;
@dynamic activityImage1;
@dynamic activityimage2;
@dynamic maxNumberOfParticipants;
@dynamic numberOfpaticipants;
@dynamic host;
@dynamic selectedCategory;
@dynamic acceptedPeopleArray;
@dynamic RequestsArray;
@dynamic activityPrivacy;
@dynamic studentsOnly;
@dynamic isLBGT;
@dynamic exclusiveInvitesArray;

+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Activity";
}


@end
