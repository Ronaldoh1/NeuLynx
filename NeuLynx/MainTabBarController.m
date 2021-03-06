//
//  RootTabBarController.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "MainTabBarController.h"

#import "AppDelegate.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];


     [self setUpTabBars];



}
-(void)viewDidAppear:(BOOL)animated{

    [self setUpTabBars];
}


-(void)setUpTabBars{

    //set up the tint for the tabbar



    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1]];


    /*create the first tab - get the storyboard , then use the storyboard to present the first view controller also set an image for the first tab.*/
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UITabBarController *mapNavVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MapNavVC"];
    [self addChildViewController:mapNavVC];
    mapNavVC.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"mapTabButton"] scaledToSize:CGSizeMake(35, 35)];
    mapNavVC.tabBarItem.title = @"Map";



     /*create the second tab - get the storyboard , then use the storyboard to present the second view controller also set an image for the first tab.*/
    UIStoryboard *mailStoryboard = [UIStoryboard storyboardWithName:@"Mail" bundle:nil];
    UITabBarController *mailNavVC = [mailStoryboard instantiateViewControllerWithIdentifier:@"mailNavVC"];
    [self addChildViewController:mailNavVC];
    mailNavVC.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"mailIcon"] scaledToSize:CGSizeMake(35, 35)];
    mailNavVC.tabBarItem.title = @"Messages";
    mailNavVC.tabBarItem.enabled = NO;


    /*create the third tab - get the storyboard, then use the storyboard to present the third  view controller also set an image for the first tab.*/
    UIStoryboard *requestStoryboard = [UIStoryboard storyboardWithName:@"Request" bundle:nil];
    UITabBarController *requestNavVC = [requestStoryboard instantiateViewControllerWithIdentifier:@"RequestNavVC"];
    [self addChildViewController:requestNavVC];
    requestNavVC.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"requestIcon2"] scaledToSize:CGSizeMake(35, 35)];
    requestNavVC.tabBarItem.title = @"Requests";
    requestNavVC.tabBarItem.enabled = YES;

    //create fourth tab. Get the storyboard, then use the storyboard to present the fourth view controller.

    UIStoryboard *historyStoryboard = [UIStoryboard storyboardWithName:@"History" bundle:nil];
    UITabBarController *historyNavVC = [historyStoryboard instantiateViewControllerWithIdentifier:@"HistoryNavVC"];
    [self addChildViewController:historyNavVC];
    historyNavVC.tabBarItem.image = [self imageWithImage:[UIImage imageNamed:@"historyIcon.png"] scaledToSize:CGSizeMake(35,35 )];
    historyNavVC.tabBarItem.title = @"History";
    historyNavVC.tabBarItem.enabled = YES;


}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 1, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
