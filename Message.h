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
@property NSString *subject;
@property User *recipient;
@property NSString *recipientUsername;
@property NSString *senderUsername;
@property User *sender;
@property NSString *messageText;

+(NSString *)parseClassName;



@end
