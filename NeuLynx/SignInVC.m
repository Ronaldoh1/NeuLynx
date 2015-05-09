//
//  SignInVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SignInVC.h"
#import "User.h"
#import <Parse/Parse.h>

@interface SignInVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTextFields];

}


- (IBAction)onsignInWithFacebook:(UIButton *)sender {

}
- (IBAction)onCancelButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)onSignInButtonTapped:(UIButton *)sender {
    NSString *error = @"";

    if ([self.email.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {
        error = @"All fields are required, please try again!";
    }else{

        [User logInWithUsernameInBackground:self.email.text password:self.password.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                // Do stuff after successful login.
                                                NSLog(@"logged in");

                                            } else {
                                                // The login failed. Check error to see why.
                                            }
                                        }];

    }

}
-(void)setUpTextFields{
    self.email.delegate = self;
    self.password.delegate = self;
}


#pragma Marks - hiding keyboard
//hide keyboard when the user clicks return
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

//move the view when the user clicks on a textfield

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    return YES;
}
//move the view when the keyboard hides.

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [self.view endEditing:YES];
    return YES;
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


@end
