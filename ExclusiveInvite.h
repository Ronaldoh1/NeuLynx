//
//  ExclusiveInvite.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/17/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
#import "User.h"


@interface ExclusiveInvite : PFObject<PFSubclassing>

@property User *exclusiveInvitee;
@property Activity *activity;


@end
