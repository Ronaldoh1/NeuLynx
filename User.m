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
@dynamic profileImage;
@dynamic userHomeLocation;
@dynamic gender;
@dynamic orientation;
@dynamic languageArray;


+(void)load {
    [self registerSubclass];
}

@end
