//
//  MapVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>
#import "User.h"


@interface MapVC ()<MKMapViewDelegate, UIActionSheetDelegate, UISearchBarDelegate>
@property UIButton *mainButton;
@property UIButton *mainButton1;
@property UIButton *mainButton2;
@property UIButton *mainButton3;
@property UIButton *mainButton4;

@property UIDynamicAnimator *dynamicAnimator;
@property BOOL isFannedOut;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpProfileImage];
    [self setUpFanOutButton];
    [self performInitialSetup];
    [User logOut];



}
 //helper method for initial set up

-(void)performInitialSetup{
    //Dismiss Keyboard when user touches outside of the search bar.
    //first - create a tap gesture.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    //add the tap gesture to the current view.
    [self.view addGestureRecognizer:tap];

}
-(void)dismissKeyboard{
    [self.searchBar resignFirstResponder];
}

-(void)setUpFanOutButton{
    //create dynamic animator
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.mainButton1 = [self createButtonTitle:@"1"];
    self.mainButton2 = [self createButtonTitle:@"2"];
    self.mainButton3 = [self createButtonTitle:@"3"];
      self.mainButton4 = [self createButtonTitle:@"4"];
    self.mainButton = [self createButtonTitle:@"A"];
    [self.mainButton addTarget:self action:@selector(fanButtons:) forControlEvents:UIControlEventTouchUpInside];
}
-(UIButton *)createButtonTitle:(NSString *)title{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50.0, self.view.frame.size.height - 100.0, 50.0, 50.0)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0] forState: UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.borderColor = button.titleLabel.textColor.CGColor;

    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = button.frame.size.width/2;

    [self.view addSubview:button];

    return button;
}
-(void) fanButtons:(id)sender{

    [self.dynamicAnimator removeAllBehaviors];

    if (!self.isFannedOut) {
        [self fanButtonOut];

    }else {
        [self snapButton:self.mainButton1 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton2 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton3 toPoint:self.mainButton.center];
        [self snapButton:self.mainButton4 toPoint:self.mainButton.center];
    }
    self.isFannedOut = !self.isFannedOut;
    
    
}
-(void)fanButtonOut{
    [self snapButton:self.mainButton1 toPoint:CGPointMake(self.mainButton.frame.origin.x - 50.0, self.mainButton.frame.origin.y + 20.0)];
    [self snapButton:self.mainButton2 toPoint:CGPointMake(self.mainButton.frame.origin.x - 45.0, self.mainButton.frame.origin.y - 45.0)];
    [self snapButton:self.mainButton3 toPoint:CGPointMake(self.mainButton.frame.origin.x - 15, self.mainButton.frame.origin.y - 100.0)];
    [self snapButton:self.mainButton4 toPoint:CGPointMake(self.mainButton.frame.origin.x + 15, self.mainButton.frame.origin.y - 150.0)];
}
-(void)snapButton:(UIButton *)button toPoint:(CGPoint)point{
    UISnapBehavior *snapBehavior =[[UISnapBehavior alloc] initWithItem:button snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehavior];
}
-(void)setUpProfileImage{

    //create an image and assign it to defualt image
    UIImage *profileImage = [UIImage imageNamed:@"defaultImage"];
    //create button frame
    CGRect buttonFrame = CGRectMake(0, 0, 40, 40);

    //Create Button
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];

    //make the button rounded
    button.layer.cornerRadius = button.frame.size.height / 2;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0].CGColor;

    [button setImage:profileImage forState:UIControlStateNormal];

    //add at tap gesture recognizer to the left button
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(profileImageTapped:)];
    [button addGestureRecognizer:tapGesture];


    //create a custom view for the button
    UIView *profileButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    profileButtonView.bounds = CGRectOffset(profileButtonView.bounds, 10, 0);

    //add the button to the custom view
    [profileButtonView addSubview:button];

    UIBarButtonItem *profileButtonItem = [[UIBarButtonItem alloc]initWithCustomView:profileButtonView];

    self.navigationItem.leftBarButtonItem = profileButtonItem;


}
//helper method to show user's profile.

-(void)profileImageTapped:(UIBarButtonItem* )sender{
    NSLog(@"Image tapped");
    //    //create the second tab - get the storybody, then use the storyboard to present the first view controller
    //    //also set an image for the first tab.
        UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        UITabBarController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
    [self presentViewController:profileNavVC animated:YES completion:nil];
}

- (IBAction)onPostEventButtonTapped:(UIBarButtonItem *)sender {
    //create the third tab - get the storybody, then use the storyboard to present the first view controller
    //also set an image for the first tab.
    UIStoryboard *postEventStoryboard = [UIStoryboard storyboardWithName:@"PostEvent" bundle:nil];
    UIViewController *postEventNavVC = [postEventStoryboard instantiateViewControllerWithIdentifier:@"postEventNavVC"];

    [self presentViewController:postEventNavVC animated:YES completion:nil];


}
//on post event button pressed
- (IBAction)onPostButtonPressed:(UIBarButtonItem *)sender {

    //if the current user does not exist, then make him/her sign up.
    if ([User currentUser] == nil) {
        [self presentActionSheetToLogInUser];

    }else{

        NSLog(@"user is logged in");

    }
}

//helper method to create actionsheet
-(void)presentActionSheetToLogInUser{
    NSString *actionSheetTitle = @"You must be logged in to post events";
    NSString *button1 = @"Sign In";
    NSString *button2 = @"Sign Up";
    NSString *button3 = @"Sign in with Facebook";
    NSString *button4 = @"Sign in with Twitter";
    NSString *cancelTitle = @"Never Mind";

    //create the action sheet.

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles:button1,button2, button3, button4, nil];

    //present the actionsheet in the current view.
    [actionSheet showInView:self.view];

}

#pragma Mark - ActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        //if the first button is tapped, then present  sign in storyboard
        UIStoryboard *signInStoryBoard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
        UIViewController *signInVC = [signInStoryBoard instantiateViewControllerWithIdentifier:@"signInNavVC"];
        [self presentViewController:signInVC animated:YES completion:nil];

    }else if(buttonIndex == 1){
        //if the second button is tapped, then present the sign up storyboard/vc

        UIStoryboard *signUpStoryBoard = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];

        UIViewController *signUpVC = [signUpStoryBoard instantiateViewControllerWithIdentifier:@"SignUpNavVC"];
        [self presentViewController:signUpVC animated:YES completion:nil];

    }else if(buttonIndex == 2){

    }else if(buttonIndex == 3){

    }
}
#pragma Mark - Search bar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];

}







@end
