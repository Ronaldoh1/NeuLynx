//
//  ProfileTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/29/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "ProfileTVC.h"
#import "User.h"
#import "PreferencesVC.h"
#import <CoreText/CoreText.h>
#import "MRProgressOverlayView.h"
#import "MRProgress.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileTVC ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;

//*********Define Current User*******

@property User *currentUser;

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

@implementation ProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

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

-(void)viewWillDisappear:(BOOL)animated{
    

}

//Initial set up of Nav Bar, User, Profile Image, Set up Delegates.
-(void)performInitialSetUp{

    //*******Setup Current User*********//
    self.currentUser = [User currentUser];
    //Make profile image round

    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 4.0;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;



    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Profile";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //set up textfield delegates.
    [self setUpTextFieldDelegates];


    //Dim the colors of language buttons
    self.portugueseButton.alpha = 0.3;
    self.spanishButton.alpha = 0.3;
    self.englishButton.alpha = 0.3;
    self.frenchButton.alpha = 0.3;

//    //add borders to the textView
//    self.aboutMeTextView.layer.borderWidth = 4.0f;
//    self.aboutMeTextView.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;

}

//helper method to get user's languages
-(void)getUsersPersonalInformation{
    //******Get the information of the current user********//
    self.nameTextField.text = self.currentUser.name;
    self.ageTextField.text = self.currentUser.age;
    self.aboutMeTextView.text = self.currentUser.aboutMe;
    //get user's gender
    if ([self.currentUser.gender isEqualToString:@"Male"]) {
        self.genderPicker.selectedSegmentIndex = 0;

    }else if ([self.currentUser.gender isEqualToString:@"Female"]){
        self.genderPicker.selectedSegmentIndex = 1;

    }else {
        //in the case the that the user hasnt selected one just set it to male.
        self.genderPicker.selectedSegmentIndex = 0;
    }

    //get user's orientation
    if ([self.currentUser.orientation isEqualToString:@"Straight"]) {
        self.orientationPicker.selectedSegmentIndex = 0;

    }else if([self.currentUser.orientation isEqualToString:@"Bisexual"]){
        self.orientationPicker.selectedSegmentIndex = 1;

    }else if([self.currentUser.orientation isEqualToString:@"Gay"]){
        self.orientationPicker.selectedSegmentIndex = 2;

    }else if ([self.currentUser.orientation isEqualToString:@"Lesbian"]){
        self.orientationPicker.selectedSegmentIndex = 3;

    }else if ([self.currentUser.orientation isEqualToString:@"Transgender"]){
        self.orientationPicker.selectedSegmentIndex = 4;

    }else{
        self.orientationPicker.selectedSegmentIndex = 0;
    }

    //get user's languages
    self.languageArray = [[NSMutableArray alloc] initWithArray:self.currentUser.languageArray.mutableCopy];

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



//Helper method to download user's profile image
-(void)getUsersProfileImage{

    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.profileImage.image = image;
        }

    }];
}

//#pragma mark - Action Buttons 
////Show the View and enable the picker
//- (IBAction)onSetAgeButtonTapped:(UIButton *)sender {
//
//    self.secondaryView.hidden = NO;
//    self.secondaryView.userInteractionEnabled = YES;
//    self.agePicker.hidden = NO;
//    self.agePicker.userInteractionEnabled = YES;
//    [self.nameTextField resignFirstResponder];
//
//}
////hide the Age Picker
//- (IBAction)onDoneButtonHideAgePicker:(UIButton *)sender {
//    //Hide the View and Disable the picker
//    self.secondaryView.hidden = YES;
//    self.secondaryView.userInteractionEnabled = NO;
//    self.agePicker.hidden = YES;
//    self.agePicker.userInteractionEnabled = NO;
//    self.ageTextField.text = self.selectedEntry;
//
//}

//********Choose Profile Image ***********
- (IBAction)onChooseImageButtonTapped:(id)sender {

    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];

}

//**********Save the user's information************
- (IBAction)onSaveButtonTapped:(UIBarButtonItem *)sender {


    if ([self.nameTextField.text isEqualToString:@""] || [self.ageTextField.text isEqualToString:@""]) {
        [self displayAlertWithTitle:@"Error in Form" andWithMessage:@"Personal information cannot be blank"];
    } else {
        self.currentUser.name = self.nameTextField.text;
        self.currentUser.age = self.ageTextField.text;

        if (self.genderPicker.selectedSegmentIndex == 0) {
            self.currentUser.gender = @"Male";

        } else if(self.genderPicker.selectedSegmentIndex == 1){
            self.currentUser.gender = @"Female";
        }
        if (self.orientationPicker.selectedSegmentIndex == 0) {
            self.currentUser.orientation = @"Straight";

        } else if(self.orientationPicker.selectedSegmentIndex == 1){
            self.currentUser.orientation = @"Bisexual";

        }else if(self.orientationPicker.selectedSegmentIndex == 2){
            self.currentUser.orientation = @"Gay";

        }else if(self.orientationPicker.selectedSegmentIndex == 3){
            self.currentUser.orientation = @"Lesbian";

        }else if(self.orientationPicker.selectedSegmentIndex == 4){
            self.currentUser.orientation = @"Transgender";

        }

        self.currentUser.languageArray = self.languageArray;
        self.currentUser.aboutMe = self.aboutMeTextView.text;

        NSData *imageData = UIImagePNGRepresentation(self.profileImage.image);
        PFFile *imageFile = [PFFile fileWithData:imageData];

        self.currentUser.profileImage = imageFile;

        //disable the save button

        self.navigationItem.rightBarButtonItem.enabled = NO;

        //Get user's information and display current location and profile picture.
        [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Saving..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];


        [self saveUserInformationToParse:^{

            [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {


                if (succeeded) {

                    // [self displaySuccessMessage]


                    [MRProgressOverlayView dismissOverlayForView: self.view animated:YES];

                    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Success!" mode:MRProgressOverlayViewModeCheckmark animated:YES];

                    [self dismissIndicator:^{

                        //once we get user's
                        self.navigationItem.rightBarButtonItem.enabled = YES;


                        [MRProgressOverlayView dismissOverlayForView: self.view animated:YES];


                        UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *mapNavVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
                        [self presentViewController:mapNavVC animated:YES completion:nil];
                        
                        
                    } afterDelay:1.5];
                    
                    
                    
                    
                } else {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    [self displayErrorMessage:error.localizedDescription];
                    
                    
                }
                
                
            }];
            
            
            
            
        } afterDelay:1.5];
    }
    
}

//**************Adding and Removing languages**********

- (IBAction)onPortugueseButtonTapped:(UIButton *)sender {

    if ([self.languageArray containsObject:@"Portuguese"] == YES) {
        [self.languageArray removeObject:@"Portuguese"];
        self.portugueseButton.alpha = 0.5;
    }else{
        [self.languageArray addObject:@"Portuguese"];
        self.portugueseButton.alpha =  1.0;
    }
}
- (IBAction)onSpanishButtonTapped:(UIButton *)sender {


    if ([self.languageArray containsObject:@"Spanish"] == YES) {
        [self.languageArray removeObject:@"Spanish"];
        self.spanishButton.alpha = 0.3;
    }else{
        [self.languageArray addObject:@"Spanish"];
        self.spanishButton.alpha =  1.0;
    }
}
- (IBAction)onEnglishbuttonTapped:(UIButton *)sender {

    if ([self.languageArray containsObject:@"English"] == YES) {
        [self.languageArray removeObject:@"English"];
        self.englishButton.alpha = 0.5;
    }else{
        [self.languageArray addObject:@"English"];
        self.englishButton.alpha =  1.0;
    }
}

- (IBAction)onFrenchButtonTapped:(UIButton *)sender {
    if ([self.languageArray containsObject:@"French"] == YES) {
        [self.languageArray removeObject:@"French"];
        self.frenchButton.alpha = 0.5;
    }else{
        [self.languageArray addObject:@"French"];
        self.frenchButton.alpha =  1.0;
    }
}

#pragma Mark - Image Picker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    //get the image from image picker
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];

    //add the image to the array.
    self.profileImage.image = image;
    //dismiss the picker viewcontroller when user chooses
    [self dismissViewControllerAnimated:YES completion:nil];

}

//dismiss the view controller when user cancels.
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self cancelPicker];

}

//Helper Method to dismiss picker when user cancels.

-(void)cancelPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITableView Delegate Methods

//the following method will not allow to select items in the first section but will allow the user to select items in the second section.
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ((indexPath.section == 3 && indexPath.row == 0) || (indexPath.section == 3 && indexPath.row == 1)) {
        return indexPath;
    } else {
        return nil;
    }
}


//#pragma mark - UIPickerView Delegate methods
////THen number of columns of data.
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//
//    return 1;
//}
////the number of rows  of data
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//
//    return self.ageArray.count;
//
//}
//
////return the data for the row and component column that's being passed in .
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//
//
//    return self.ageArray[row];
//
////}
//
////get the selected value of picker.
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//
//
//    self.selectedEntry = [self.ageArray objectAtIndex:row];
//
//
//}
//-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.ageArray[row] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1]}];
//    
//    return attString;
//}
//



#pragma Marks - hiding keyboard
//hide keyboard when the user clicks return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    [self.view endEditing:true];
    return true;
}
//helper
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.aboutMeTextView resignFirstResponder];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
//hide keyboard when user touches outside.
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}
//Helper method to set up the textfield delegates
-(void)setUpTextFieldDelegates{
    self.nameTextField.delegate = self;
    self.ageTextField.delegate = self;
}



//***********HELPER METHODS **************//

//Display general alert

-(void)displayAlertWithTitle:(NSString *)title andWithMessage:(NSString *)message{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alertView show];


}
//helper method to display a success message when information has been posted.
-(void)displaySuccessMessage{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your information has been saved!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alertView show];


}

//helper method to display error message
-(void)displayErrorMessage:(NSString *)error{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error - Please Try Again!" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alertView show];
}



//**********************BLOCKS***********************************************//
-(void)saveUserInformationToParse:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}

-(void)dismissIndicator:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}


//***************Prepare for Segue ******************
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier]isEqualToString:@"toPreferenceSelection"]){

        PreferencesVC *destinationVC = [segue destinationViewController];
        destinationVC.navBarTitle = @"Travel Preferences";
        destinationVC.vCtoPresent = ((int)[self.tableView indexPathForSelectedRow].row);
    }else if ([[segue identifier]isEqualToString:@"toPersonalitySelection"]){

        PreferencesVC *destinationVC = [segue destinationViewController];
        destinationVC.navBarTitle = @"Personality";
        destinationVC.vCtoPresent = ((int)[self.tableView indexPathForSelectedRow].row);
    }

}

@end
