//
//  User.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>
@property NSString *name;


@end
