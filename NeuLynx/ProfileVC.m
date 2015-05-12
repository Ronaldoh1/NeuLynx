//
//  ProfileVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "ProfileVC.h"
#import "User.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onLogOutButtonTapped:(UIBarButtonItem *)sender {

    [User logOut];

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)onBackButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
