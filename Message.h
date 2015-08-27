//
//  Message.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/11/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"
#import "Activity.h"

@interface Message : PFObject<PFSubclassing>

@property (strong, atomic) NSString *subject;
@property (strong, atomic) User *recipient;
@property (strong, atomic) NSString *recipientUsername;
@property (strong, atomic) NSString *senderUsername;
@property (strong, atomic) User *sender;
@property (strong, atomic) NSString *messageText;

+(NSString *)parseClassName;



@end
