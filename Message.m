//
//  Message.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/11/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "Message.h"

@implementation Message
@dynamic subject;
@dynamic recipient;
@dynamic sender;
@dynamic messageText;

+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Message";
}


@end
