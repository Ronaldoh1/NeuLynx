//
//  inbox.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/23/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"


@interface Inbox : PFObject<PFSubclassing>
@property User *messageContact;
@property User *inboxOwner;
@property NSString *messageContactUsername;
@property NSString *inboxOwnerUsername;

@end
