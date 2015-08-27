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


@property (strong, atomic) NSString *username;
@property (strong, atomic) User *pointsOwner;
@property (strong, atomic) NSNumber *points;

@end
