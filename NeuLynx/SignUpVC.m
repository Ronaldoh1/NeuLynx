//
//  SignUpVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SignUpVC.h"
#import <Parse/Parse.h>


@interface SignUpVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];


}

-(void)setUpTextFieldDelegates{
    self.email.delegate = self;
    self.password.delegate = self;
    self.confirmPassword.delegate = self;

}

- (IBAction)onCancelButtonTapped:(UIButton *)sender {

}

- (IBAction)onSignUpButtonTapped:(UIButton *)sender {

}
- (IBAction)onFbSignUpButtonTapped:(UIButton *)sender {

}

@end
