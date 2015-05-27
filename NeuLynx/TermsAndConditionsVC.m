//
//  TermsAndConditionsVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/27/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "TermsAndConditionsVC.h"

@interface TermsAndConditionsVC ()

@end

@implementation TermsAndConditionsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self performInitialSetUp];
}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)performInitialSetUp{
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Terms & Conditions";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

}


@end
