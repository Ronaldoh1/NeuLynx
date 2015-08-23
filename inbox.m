//
//  inbox.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/23/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "inbox.h"

@implementation inbox

@dynamic inboxOwner;
@dynamic messageContact;


+(void)load {
    [self registerSubclass];
}
+ (NSString *)parseClassName{
    return @"Inbox";
}

@end
