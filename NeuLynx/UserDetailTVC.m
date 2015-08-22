//
//  UserDetail.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/21/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "UserDetailTVC.h"
#import "User.h"
#import "AppDelegate.h"

@interface UserDetailTVC ()
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;
@property (weak, nonatomic) IBOutlet UITextView *personalityTextView;
@property (weak, nonatomic) IBOutlet UITextView *travelPreferencesTextView;

//*********Define Current User*******

@property User *selectedUser;

//****Language Buttons******
@property NSMutableArray *languageArray;

@property (weak, nonatomic) IBOutlet UIButton *portugueseButton;
@property (weak, nonatomic) IBOutlet UIButton *spanishButton;

@property (weak, nonatomic) IBOutlet UIButton *englishButton;
@property (weak, nonatomic) IBOutlet UIButton *frenchButton;

@property NSString *selectedEntry;

@property BOOL genderArraySelected;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orientationPicker;


@property UIWindow *window;

@property NSArray *preferencesSelectionArray;
@end

@implementation UserDetailTVC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self performInitialSetUp];
    //get user's profile Image
    [self getUsersProfileImage];
    //get Uer's personal information
    [self getUsersPersonalInformation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Initial set up of Nav Bar, User, Profile Image, Set up Delegates.
-(void)performInitialSetUp{

    //*******Setup Current User*********//

//
//    appDelegate.sharedActivity = (Activity *)(((ExclusiveInvite *)self.exclusiveInvitesArray[indexPath.row]).activity);
//    appDelegate.exclusiveInvite = ((ExclusiveInvite *)self.exclusiveInvitesArray[indexPath.row]);


    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.selectedUser = [User new];

    self.selectedUser = appDelegate.selectedUser;
    //Make profile image round

    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 4.0;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;


    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Profile";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

   
    //Dim the colors of language buttons
    self.portugueseButton.alpha = 0.3;
    self.spanishButton.alpha = 0.3;
    self.englishButton.alpha = 0.3;
    self.frenchButton.alpha = 0.3;

}

//helper method to get user's languages
-(void)getUsersPersonalInformation{
    //******Get the information of the current user********//
    self.nameTextField.text = self.selectedUser.name;
    self.ageTextField.text = self.selectedUser.age;
    self.aboutMeTextView.text = self.selectedUser.aboutMe;

    //get the user's personality
    if (self.selectedUser.personalityArray.count == 1) {
        self.personalityTextView.text = [NSString stringWithFormat:@"My personality can be described as %@", self.selectedUser.personalityArray[0]];

    }else if(self.selectedUser.personalityArray.count == 2){
        self.personalityTextView.text = [NSString stringWithFormat: @"My personality can be described as: %@ & %@", self.selectedUser.personalityArray[0], self.selectedUser.personalityArray[1]];

    }else if(self.selectedUser.personalityArray.count == 3){
        self.personalityTextView.text = [NSString stringWithFormat: @"My personality can be described as: %@, %@, & %@", self.selectedUser.personalityArray[0], self.selectedUser.personalityArray[1], self.selectedUser.personalityArray[2]];

    }else if(self.selectedUser.personalityArray.count == 4){

        self.personalityTextView.text = [NSString stringWithFormat: @"My personality can be described as: %@, %@, %@, &  %@", self.selectedUser.personalityArray[0], self.selectedUser.personalityArray[1], self.selectedUser.personalityArray[2], self.selectedUser.personalityArray[3]];
    }


    //get the user's travel preferences.
    if (self.selectedUser.travelPreferencesArray.count == 1) {
        self.travelPreferencesTextView.text = [NSString stringWithFormat:@"As a traveler I be best described as: %@", self.selectedUser.travelPreferencesArray[0]];

    }else if(self.selectedUser.travelPreferencesArray.count == 2){
        self.travelPreferencesTextView.text = [NSString stringWithFormat: @"As a traveler I be best described as: %@ & %@", self.selectedUser.travelPreferencesArray[0], self.selectedUser.travelPreferencesArray[1]];

    }else if(self.selectedUser.travelPreferencesArray.count == 3){
        self.travelPreferencesTextView.text = [NSString stringWithFormat: @"As a traveler I be best described as: %@, %@, & %@", self.selectedUser.travelPreferencesArray[0], self.selectedUser.travelPreferencesArray[1], self.selectedUser.travelPreferencesArray[2]];

    }else if(self.selectedUser.travelPreferencesArray.count == 4){

        self.travelPreferencesTextView.text = [NSString stringWithFormat: @"As a traveler I be best described as: %@, %@, %@, &  %@", self.selectedUser.travelPreferencesArray[0], self.selectedUser.travelPreferencesArray[1], self.selectedUser.travelPreferencesArray[2], self.selectedUser.travelPreferencesArray[3]];
    }


    //get user's gender
    if ([self.selectedUser.gender isEqualToString:@"Male"]) {
        self.genderPicker.selectedSegmentIndex = 0;

    }else if ([self.selectedUser.gender isEqualToString:@"Female"]){
        self.genderPicker.selectedSegmentIndex = 1;

    }else {
        //in the case the that the user hasnt selected one just set it to male.
        self.genderPicker.selectedSegmentIndex = 0;
    }

    //get user's orientation
    if ([self.selectedUser.orientation isEqualToString:@"Straight"]) {
        self.orientationPicker.selectedSegmentIndex = 0;

    }else if([self.selectedUser.orientation isEqualToString:@"Bisexual"]){
        self.orientationPicker.selectedSegmentIndex = 1;

    }else if([self.selectedUser.orientation isEqualToString:@"Gay"]){
        self.orientationPicker.selectedSegmentIndex = 2;

    }else if ([self.selectedUser.orientation isEqualToString:@"Lesbian"]){
        self.orientationPicker.selectedSegmentIndex = 3;

    }else if ([self.selectedUser.orientation isEqualToString:@"Transgender"]){
        self.orientationPicker.selectedSegmentIndex = 4;

    }else{
        self.orientationPicker.selectedSegmentIndex = 0;
    }

    //get user's languages
    self.languageArray = [[NSMutableArray alloc] initWithArray:self.selectedUser.languageArray.mutableCopy];

    for (int i = 0; i<self.languageArray.count; i++) {
        if ([self.languageArray[i] isEqualToString:@"Portuguese"]) {
            self.portugueseButton.alpha = 1.0;

        }else if([self.languageArray[i] isEqualToString:@"Spanish"]){
            self.spanishButton.alpha = 1.0;

        }else if([self.languageArray[i] isEqualToString:@"English"]){
            self.englishButton.alpha = 1.0;

        }else if([self.languageArray[i] isEqualToString:@"French"]){
            self.frenchButton.alpha = 1.0;

        }

    }


}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

//Helper method to download user's profile image
-(void)getUsersProfileImage{

    [self.selectedUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.profileImage.image = image;
        }
        
    }];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end