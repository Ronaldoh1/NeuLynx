//
//  DetailVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "DetailVC.h"

@interface DetailVC ()

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performInitialSetUp];
}

-(void)performInitialSetUp{
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Activity Detail";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];
}

///*************ACTION BUTTONS***************************//

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onJoinButtonTapped:(UIBarButtonItem *)sender {

}



@end
