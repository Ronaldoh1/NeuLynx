//
//  SearchVC.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/30/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchVC : UIViewController
@property NSString *selectedCategory;
@property CLLocation *currentLocation;
@end
