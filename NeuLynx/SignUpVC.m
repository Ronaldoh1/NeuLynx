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

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

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
    [self initialSetUp];
}
-(void)initialSetUp{
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Let's Get Started!";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];
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
    //Setting up loginwith facebook

    //1. need to get user's permissions.
    NSArray *permissionsArray = @[@"email", @"public_profile"];

    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            self.navigationItem.leftBarButtonItem.enabled = YES;
            
            UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
            [self presentViewController:profileNavVC animated:YES completion:nil];

        } else {
            NSLog(@"User logged in through Facebook!");
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }
    }];


}
- (IBAction)onSignUpWithTwitter:(UIButton *)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            self.navigationItem.leftBarButtonItem.enabled = YES;
            UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
            [self presentViewController:profileNavVC animated:YES completion:nil];

        } else {
            NSLog(@"User logged in with Twitter!");
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }
    }];
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

- (IBAction)onTermsAndConditionsButtonTapped:(UIButton *)sender {

    UIStoryboard *termsAndConditionsStoryBoard = [UIStoryboard storyboardWithName:@"TermsAndConditions" bundle:nil];
    UINavigationController *termsAndConditionsNavVC = [termsAndConditionsStoryBoard instantiateViewControllerWithIdentifier:@"TermsAndConditionsNavVC"];
    [self presentViewController:termsAndConditionsNavVC animated:YES completion:nil];


}


-(void)signUp{
    User *user = [User new];
    user.username = self.email.text;
    user.password = self.password.text;
    user.email = self.email.text;



    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            //If the user is new then present the profile

            UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
            [self presentViewController:profileNavVC animated:YES completion:nil];

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
