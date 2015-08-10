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

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <Accounts/Accounts.h>

@interface SignInVC ()<UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property CGFloat animatedDistance;

@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTextFields];
    [self initialSetUp];

}
-(void)initialSetUp{
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Welcome Back!";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];
}
- (IBAction)onSignInWithTwitterButtonTapped:(UIButton *)sender {

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


- (IBAction)onsignInWithFacebook:(UIButton *)sender {
    //Setting up loginwith facebook

    //1. need to get user's permissions.
    NSArray *permissionsArray = @[ @"email", @"public_profile"];

    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");

            [self getFacebookUserData];

            //if the user is new, then we want to get his information from facebook and store it in parse.
            [self saveFbUserInfoToParse:^{
                //If the user is new then present the profile


                self.navigationItem.leftBarButtonItem.enabled = YES;

                UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
                UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
                [self presentViewController:profileNavVC animated:YES completion:nil];
                //                [self dismissViewControllerAnimated:YES completion:nil];



            } afterDelay:2];


            //enable tabs once the user has been signed up (Profile/Inbox);

            [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
            [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];





        } else {
            NSLog(@"User logged in through Facebook!");
            //enable inbox and profile
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
            [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
            [self dismissViewControllerAnimated:YES completion:nil];
        }


    }


     ];



}



//this helper method is used to retrieve the facebook data from the user and store in parse.

- (void)getFacebookUserData{


    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // handle response
        [User currentUser].name = result[@"name"];
        [User currentUser].email = result[@"email"];
        [User currentUser].isFbUser = true;
        [[User currentUser] saveInBackground];


        [self getFbUserProfileImage:result[@"id"]];

    }];
}

//helper method to retrieve user's profile image from facebook..

-(void)getFbUserProfileImage:(id)facebookID{


    // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

    // Run network request asynchronously
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError == nil && data != nil) {
             // Set the image in the imageView
             // UIImage *image = [UIImage imageWithData:data];

             PFFile *file = [ PFFile fileWithData:data];

             [User currentUser].profileImage = file;

             [[User currentUser] saveInBackground];

         }
     }];

}
- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSignUpButtonTapped:(UIButton *)sender {

    UIStoryboard *signUpStoryBoard = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];

    UIViewController *signUpVC = [signUpStoryBoard instantiateViewControllerWithIdentifier:@"SignUpNavVC"];
    [self presentViewController:signUpVC animated:YES completion:nil];
}



- (IBAction)onSignInButtonTapped:(UIButton *)sender {
    NSString *error = @"";

    if ([self.email.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {
        error = @"All fields are required, please try again!";

        [self displayAlertWithTitle:@"All Fields Required!" andWithMessage:error];
    }else{

        [User logInWithUsernameInBackground:self.email.text password:self.password.text
                                      block:^(PFUser *user, NSError *error) {
                                          if (user) {

                                              //Enable the message and requests tabs.
                                              self.navigationItem.leftBarButtonItem.enabled = YES;
                                              [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:YES];
                                              [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:YES];

                                              
                                              // Do stuff after successful login.
                                              UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                              UIViewController *mapNavVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
                                              [self presentViewController:mapNavVC animated:YES completion:nil];

                                          } else {
                                              // The login failed. Check error to see why.
                                              [self displayAlertWithTitle:@"Error Loggin in" andWithMessage:error.localizedDescription];
                                          }
                                      }];

    }

}
-(void)setUpTextFields{
    self.email.delegate = self;
    self.password.delegate = self;
}

- (IBAction)onForgotPasswordButtonTapped:(UIButton *)sender {


   // [PFUser requestPasswordResetForEmailInBackground:@"email@example.com"];

    UIAlertController *alertController = [ UIAlertController alertControllerWithTitle:@"Reset Password" message:@"Enter your email address" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email Address";
    }];


    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    UIAlertAction *resetPasswordAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        UITextField *textField = alertController.textFields.firstObject;
        [PFUser requestPasswordResetForEmail:textField.text];
    }];

    [alertController addAction:resetPasswordAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES
                     completion:nil];


}


#pragma Marks - hiding keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0){
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0){
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown){
        self.animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else{
        self.animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= self.animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

    [self.view setFrame:viewFrame];

    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += self.animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

    [self.view setFrame:viewFrame];

    [UIView commitAnimations];
}
////hide keyboard when the user clicks return
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


//************Helper Methods ****************************//
//Display general alert

-(void)displayAlertWithTitle:(NSString *)title andWithMessage:(NSString *)message{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alertView show];
    
    
}

//**********************BLOCKS*********************************//

-(void)saveFbUserInfoToParse:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}


@end
