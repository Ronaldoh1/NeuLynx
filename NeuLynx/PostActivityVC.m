//
//  PostEventVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "PostActivityVC.h"
#import "Activity.h"

@interface PostActivityVC ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *activityTitle;
@property (weak, nonatomic) IBOutlet UITextField *activityDescription;
@property (weak, nonatomic) IBOutlet UITextField *activityLocation;
@property (weak, nonatomic) IBOutlet UITextField *activityMaxHeadCount;
@property (weak, nonatomic) IBOutlet UITextField *activityStartTime;
@property (weak, nonatomic) IBOutlet UITextField *activityEndTime;
@property NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property BOOL isFirstImagePicked;
@property BOOL isSecondImagePicked;
@property Activity *activity;


@end

@implementation PostActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self setTextFieldsDelegates];

}
-(void)viewWillAppear:(BOOL)animated{
    if (self.imageArray.count == 1){
        self.image1.image = self.imageArray[0];
    }else if(self.imageArray.count == 2){
        self.image2.image = self.imageArray[1];
    }
}
-(void)initialSetUp{

    //Initialize the Activity
    self.activity = [Activity new];

    //Initialize the image array
    self.imageArray = [NSMutableArray new];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Post Activity";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];
}

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil]; 

}
//- (IBAction)onPostButtonTapped:(UIBarButtonItem *)sender {
//
//
//
//}
- (IBAction)onPostButtonTapped:(UIBarButtonItem *)sender {

    self.activity.activityTitle =  self.activityTitle.text;


    [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            [self displaySuccessMessage];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // There was a problem, check error.description
            [self displayErrorMessage:error.description];
        }
    }];
}

- (IBAction)onFestivalButtonTapped:(UIButton *)sender {
}
- (IBAction)onNightOutButtonTapped:(UIButton *)sender {
}
- (IBAction)onCulturalButtonTapped:(UIButton *)sender {
}
- (IBAction)onFitnessButtonTapped:(UIButton *)sender {
}
- (IBAction)onPickFirstImageButtonTapped:(UIButton *)sender {
    self.isFirstImagePicked = YES;
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];

}

- (IBAction)onPickSecondImageButtonTapped:(UIButton *)sender {
    self.isSecondImagePicked = YES;
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];

}

//Helper Method to dismiss picker when user cancels.

-(void)cancelPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setTextFieldsDelegates{
    self.activityTitle.delegate = self;
    self.activityDescription.delegate = self;
    self.activityLocation.delegate = self;
    self.activityStartTime.delegate = self;
    self.activityEndTime.delegate = self;

}
- (IBAction)outDoorsButtonTapped:(UIButton *)sender {
}
- (IBAction)coffeeButtonTapped:(UIButton *)sender {
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

////move the view when the user clicks on a textfield
//
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//
//    return YES;
//}
////move the view when the keyboard hides.
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
//
//    [self.view endEditing:YES];
//    return YES;
//}
//
//
//- (void)keyboardDidShow:(NSNotification *)notification
//{
//    // Assign new frame to your view
//    [self.view setFrame:CGRectMake(0,-110,320,500)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
//
//}
//
//-(void)keyboardDidHide:(NSNotification *)notification
//{
//    [self.view setFrame:CGRectMake(0,0,320,600)];
//}
#pragma Mark - Image Picker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    if(self.isFirstImagePicked == YES){
        self.isFirstImagePicked = NO;


    if (self.imageArray.count == 0) {
        //get the image from image picker
        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];

        //add the image to the array.
        [self.imageArray addObject:image];



    }else if(self.imageArray[0] != nil){
        [self.imageArray removeObjectAtIndex:0];

        //get the image from image picker
        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];

        //add the image to the array.
        [self.imageArray insertObject:image atIndex:0];

    }

    }else if(self.isSecondImagePicked == YES){
        self.isSecondImagePicked = NO;
        if (self.imageArray.count == 1) {

            //get the image from image picker
            UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];

            //add the image to the array.
            [self.imageArray insertObject:image atIndex:1];



        }else if(self.imageArray[1] != nil){
            [self.imageArray removeObjectAtIndex:1];

            //get the image from image picker
            UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
            [self.imageArray insertObject:image atIndex:1];
        }

    }
    //dismiss the picker viewcontroller when user chooses
    [self dismissViewControllerAnimated:YES completion:nil];

}



//***********HELPER METHODS **************//


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

//dismiss the view controller when user cancels.
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self cancelPicker];

}

@end
