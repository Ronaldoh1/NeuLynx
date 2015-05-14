//
//  ProfileVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "ProfileVC.h"
#import "User.h"

@interface ProfileVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *orientation;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpTextFieldDelegates];

}

- (IBAction)onLogOutButtonTapped:(UIBarButtonItem *)sender {

    [User logOut];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)onBackButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Marks - hiding keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    [self.view endEditing:true];
    return true;
}
//hide keyboard when user touches outside.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-110,320,500)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.

}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,320,600)];
}

//Helper method to set up the textfield delegates
-(void)setUpTextFieldDelegates{
    self.name.delegate = self;
    self.gender.delegate = self;
    self.orientation.delegate = self;
    self.phoneNumber.delegate = self;
}

@end
