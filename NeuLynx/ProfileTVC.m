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

@interface ProfileTVC ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

//*********Define Current User*******

@property User *currentUser;
@end

@implementation ProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self performInitialSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)performInitialSetUp{

    //*******Setup Current User*********//
    self.currentUser = [User currentUser];
    //Make profile image round

    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 4.0;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor;

    //get user's profile Image
    [self getUsersProfileImage];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Profile";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //set up textfield delegates.
    [self setUpTextFieldDelegates];


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

#pragma mark - Action Buttons 

//********Choose Profile Image ***********
- (IBAction)onChooseImageButtonTapped:(id)sender {

    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];

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
//Helper method to set up the textfield delegates
-(void)setUpTextFieldDelegates{
    self.nameTextField.delegate = self;
    self.ageTextField.delegate = self;
}

@end
