//
//  MapVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>


@interface MapVC ()<MKMapViewDelegate>

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpProfileImage];



}
-(void)setUpProfileImage{

    //create an image and assign it to defualt image
    UIImage *profileImage = [UIImage imageNamed:@"defaultImage"];
    //create button frame
    CGRect buttonFrame = CGRectMake(0, 0, 40, 40);

    //Create Button
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];

    //make the button rounded
    button.layer.cornerRadius = button.frame.size.height / 2;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0].CGColor;

    [button setImage:profileImage forState:UIControlStateNormal];

    UIView *profileButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    profileButtonView.bounds = CGRectOffset(profileButtonView.bounds, 10, 0);

    [profileButtonView addSubview:button];

    UIBarButtonItem *profileButtonItem = [[UIBarButtonItem alloc]initWithCustomView:profileButtonView];
    self.navigationItem.leftBarButtonItem = profileButtonItem;
}

- (IBAction)onPostEventButtonTapped:(UIBarButtonItem *)sender {
    //create the third tab - get the storybody, then use the storyboard to present the first view controller
    //also set an image for the first tab.
    UIStoryboard *postEventStoryboard = [UIStoryboard storyboardWithName:@"PostEvent" bundle:nil];
    UIViewController *postEventNavVC = [postEventStoryboard instantiateViewControllerWithIdentifier:@"postEventNavVC"];

    [self presentViewController:postEventNavVC animated:YES completion:nil];


}


@end
