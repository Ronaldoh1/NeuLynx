//
//  ExclusiveInvite.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/17/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "ExclusiveInvite.h"

@implementation ExclusiveInvite
@dynamic exclusiveInvitee;
@dynamic activity;

+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"ExclusiveInvite";
}

@end
