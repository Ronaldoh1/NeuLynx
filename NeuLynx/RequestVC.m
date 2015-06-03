//
//  RequestVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/30/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "RequestVC.h"

@interface RequestVC ()

@end

@implementation RequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performInitialSetUp];
}

-(void)performInitialSetUp{

    //Set the title for the VC.
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Requests";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];
}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
