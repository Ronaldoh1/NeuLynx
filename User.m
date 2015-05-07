//
//  User.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic name;

+(void)load {
    [self registerSubclass];
}

@end
