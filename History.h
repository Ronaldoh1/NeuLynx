//
//  History.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/19/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
#import "User.h"


@interface History : PFObject<PFSubclassing>

@property Activity *activityJoined;
@property User *user;

@end