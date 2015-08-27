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

@property (strong, atomic) User *recipient;
@property (strong, atomic) NSString *recipientUsername;
@property (strong, atomic) NSString *senderUsername;
@property (strong, atomic) User *sender;
@property (strong, atomic) NSNumber *messageIsNew; //0 = no, 1 = yes;

@end
