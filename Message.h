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

@interface Message : PFObject<PFSubclassing>
@property User *recepient; 
@property NSString *messageText;

+(NSString *)parseClassName;



@end
