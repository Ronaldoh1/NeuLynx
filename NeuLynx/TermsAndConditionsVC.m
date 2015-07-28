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
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Terms & Conditions";
    titleView.textColor =[UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];;
    [self.navigationItem setTitleView:titleView];

}


@end
