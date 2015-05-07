//
//  SignUpVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SignUpVC.h"
#import <Parse/Parse.h>
#import "User.h"


@interface SignUpVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //setup the textfield delegates
    [self setUpTextFieldDelegates];
}

-(void)setUpTextFieldDelegates{
    self.email.delegate = self;
    self.password.delegate = self;
    self.confirmPassword.delegate = self;

}

- (IBAction)onCancelButtonTapped:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)onFbSignUpButtonTapped:(UIButton *)sender {

}

- (IBAction)onSignUpButtonTapped:(UIButton *)sender {
    NSString *signUpError = @"";

    //all fields are required for signup
    if ([self.email.text isEqualToString:@""] || [self.password.text isEqualToString:@""] || [self.confirmPassword.text isEqualToString:@""]) {

        signUpError = @"All fields are required, please try again!";

    //passwords must match
    }else if(![self.password.text isEqualToString:self.confirmPassword.text]){
        signUpError = @"Passwords do not match, please try again!";

    //password must be at least 6 characters
    }else if([self.password.text length] < 6 || [self.confirmPassword.text length] < 6){
        signUpError = @"Your Password must be at least 6 characters";

    //if the user has met all of these conditions, then we sign him up.
    }else{
        [self signUp];

    }



    //if if the error string is not empty...then show the error

    if (![signUpError isEqualToString:@""]) {
        [self displaySignUpErrorAlert:signUpError];
    }


}
-(void)signUp{
    User *user = [User new];
    user.username = self.email.text;
    user.password = self.password.text;



    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.

        } else { //show the error
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            [self displaySignUpErrorAlert:errorString];
        }
    }];
}

//helper method to show error alert to the user
-(void)displaySignUpErrorAlert:(NSString *)error{
    //create the alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //display the alert
    [alert show];

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
