//
//  Reward.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/25/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SocialTracker.h"

@implementation SocialTracker

@dynamic pointsOwner;
@dynamic username;
@dynamic points;
;

+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"SocialTracker";
}
@end
