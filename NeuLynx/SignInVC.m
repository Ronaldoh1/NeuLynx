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

@interface SignInVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

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

//**********************BLOCKS***********************************************//

-(void)saveFbUserInfoToParse:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}


@end
