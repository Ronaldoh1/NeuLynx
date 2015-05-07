//
//  RootTabBarController.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];


     [self setUpTabBars];



}
-(void)setUpTabBars{
    //create the first tab - get the storybody, then use the storyboard to present the first view controller
    //also set an image for the first tab.
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UITabBarController *mapNavVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MapNavVC"];
    [self addChildViewController:mapNavVC];
    mapNavVC.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"mapIcon"] scaledToSize:CGSizeMake(35, 35)];
    mapNavVC.tabBarItem.title = @"Map";

    //create the second tab - get the storybody, then use the storyboard to present the first view controller
    //also set an image for the first tab.
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    UITabBarController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
    [self addChildViewController:profileNavVC];
    profileNavVC.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"profileIcon"] scaledToSize:CGSizeMake(35, 35)];
    profileNavVC.tabBarItem.title = @"Profile";

    //create the third tab - get the storybody, then use the storyboard to present the first view controller
    //also set an image for the first tab.
    UIStoryboard *mailStoryboard = [UIStoryboard storyboardWithName:@"Mail" bundle:nil];
    UITabBarController *mailNavVC = [mailStoryboard instantiateViewControllerWithIdentifier:@"mailNavVC"];
    [self addChildViewController:mailNavVC];
    mailNavVC.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"mailIcon"] scaledToSize:CGSizeMake(35, 35)];
    mailNavVC.tabBarItem.title = @"Messages";

}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 1, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
