//
//  Reward.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/25/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

@class  User;

@interface SocialTracker : PFObject<PFSubclassing>


@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) User *pointsOwner;
@property (nonatomic, strong) NSNumber *points;

@end
