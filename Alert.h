//
//  Alerts.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/24/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
@interface Alert : PFObject<PFSubclassing>

@property User *recipient;
@property NSString *recipientUsername;
@property NSString *senderUsername;
@property User *sender;
@property NSNumber *messageIsNew; //0 = no, 1 = yes;

@end
