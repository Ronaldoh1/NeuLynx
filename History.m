//
//  History.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/19/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "History.h"

@implementation History

@dynamic user;
@dynamic activityJoined;

+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"History";
}

@end