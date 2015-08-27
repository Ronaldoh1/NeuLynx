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

@property (strong, atomic) User *exclusiveInvitee;
@property (strong, atomic) Activity *activity;
//**0 = No 1 = Yes**
@property (strong, atomic) NSNumber *isDispositioned;


@end
