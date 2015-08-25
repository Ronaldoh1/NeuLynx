//
//  Reward.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/25/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "Reward.h"

@implementation Reward

@dynamic activitiesJoinedCounter;
@dynamic username;
@dynamic rewardOwner;
;

+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Reward";
}
@end
