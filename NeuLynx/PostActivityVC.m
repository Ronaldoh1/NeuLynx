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
@property (weak, nonatomic) IBOutlet UITextField *activityAddress;
@property (weak, nonatomic) IBOutlet UITextField *activityMaxHeadCount;
@property (weak, nonatomic) IBOutlet UITextField *activityStartTime;
@property (weak, nonatomic) IBOutlet UITextField *activityEndTime;
@property NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property BOOL isFirstImagePicked;
@property BOOL isSecondImagePicked;
@property Activity *activity;
@property NSString *selectedCategory;
//*********Buttons***********//
@property (weak, nonatomic) IBOutlet UIButton *outdoorsButton;
@property (weak, nonatomic) IBOutlet UIButton *gastronomyButton;
@property (weak, nonatomic) IBOutlet UIButton *festivalButton;
@property (weak, nonatomic) IBOutlet UIButton *nightOutButton;
@property (weak, nonatomic) IBOutlet UIButton *culturalButton;
@property (weak, nonatomic) IBOutlet UIButton *fitnessButton;

//*********Secondary View ********//
@property (weak, nonatomic) IBOutlet UIView *secondaryView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property BOOL startDateSelected;

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
    //Disable and Hide the Secondary View - initially
    self.secondaryView.hidden = YES;
    self.datePicker.hidden = YES;
    self.datePicker.enabled = NO;


    //Disable start and end time fields.
    self.activityStartTime.enabled = NO;
    self.activityStartTime.userInteractionEnabled = NO;

    self.activityEndTime.enabled = NO;
    self.activityEndTime.userInteractionEnabled = NO;

    //Change the color of the secondary view to yellow.
    self.secondaryView.backgroundColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1];

    //change the color of the date picker
    [self.datePicker setValue:[UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1] forKeyPath:@"textColor"];


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
    self.activity.activityDescription = self.activityDescription.text;
    self.activity.activityAddress = self.activityAddress.text;
    self.activity.maxHeadCount = @([self.activityMaxHeadCount.text integerValue]);
//    self.activity.startTimeAndDate = self.activityStartTime.text;
//    self.activity.endTimeAndDate = self.endTimeAndDate.text;
    self.activity.selectedCategory = self.selectedCategory;

    NSData *imageOneData = UIImagePNGRepresentation(self.image1.image);
    self.activity.activityImage1 = [PFFile fileWithData:imageOneData];

    NSData *imageTwoData = UIImagePNGRepresentation(self.image2.image);
    self.activity.activityimage2 = [PFFile fileWithData:imageTwoData];

   // self.activity.activityImage2 = self.image2.image;




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

//*******Enable and show the secondary view with date picker.******//
- (IBAction)onStartDateAndTimeButtonTapped:(UIButton *)sender {

    self.secondaryView.hidden = NO;
    self.datePicker.hidden = NO;
    self.datePicker.enabled = YES;
    //set the boolean for start date
    self.startDateSelected = YES;

    //set the activity start date

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    NSString *dateString = [dateFormatter stringFromDate:self.datePicker.date];
//
//    NSDateFormatter *timeFormatter = [NSDateFormatter new];
//    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];

}
- (IBAction)onEndDateAndTimeButtonTapped:(UIButton *)sender {
    self.secondaryView.hidden = NO;
    self.datePicker.hidden = NO;
    self.datePicker.enabled = YES;
}
- (IBAction)onDoneButtonTappedHideDatePicker:(UIButton *)sender {
    //Disable and Hide the Secondary View - initially
    self.secondaryView.hidden = YES;
    self.datePicker.hidden = YES;
    self.datePicker.enabled = NO;


    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];

    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];


    NSString *theDate = [dateFormat stringFromDate:self.datePicker.date];
    NSString *theTime = [timeFormat stringFromDate:self.datePicker.date];

    if (self.startDateSelected == YES) {
        self.startDateSelected = NO;
        self.activityStartTime.text = [NSString stringWithFormat:@"%@ @ %@",theDate, theTime];
        self.activity.startTimeAndDate = self.datePicker.date;


    } else {
        self.activityEndTime.text = [NSString stringWithFormat:@"%@ @ %@",theDate, theTime];
        self.activity.endTimeAndDate = self.datePicker.date;
    }



}

///************Select Category***************//
- (IBAction)outDoorsButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Outdoors";
    self.outdoorsButton.alpha = 1.0;
    self.gastronomyButton.alpha = 0.5;
    self.festivalButton.alpha = 0.5;
    self.nightOutButton.alpha = 0.5;
    self.culturalButton.alpha = 0.5;
    self.fitnessButton.alpha = 0.5;
}
- (IBAction)gastronomyButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Gastronomy";
    self.outdoorsButton.alpha = 0.5;
    self.gastronomyButton.alpha = 1.0;
    self.festivalButton.alpha = 0.5;
    self.nightOutButton.alpha = 0.5;
    self.culturalButton.alpha = 0.5;
    self.fitnessButton.alpha = 0.5;
}

- (IBAction)onFestivalButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Festival";
    self.outdoorsButton.alpha = 0.5;
    self.gastronomyButton.alpha = 0.5;
    self.festivalButton.alpha = 1.0;
    self.nightOutButton.alpha = 0.5;
    self.culturalButton.alpha = 0.5;
    self.fitnessButton.alpha = 0.5;

}
- (IBAction)onNightOutButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Night Out";
    self.outdoorsButton.alpha = 0.5;
    self.gastronomyButton.alpha = 0.5;
    self.festivalButton.alpha = 0.5;
    self.nightOutButton.alpha = 1.0;
    self.culturalButton.alpha = 0.5;
    self.fitnessButton.alpha = 0.5;
}
- (IBAction)onCulturalButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Cultural";
    self.outdoorsButton.alpha = 0.5;
    self.gastronomyButton.alpha = 0.5;
    self.festivalButton.alpha = 0.5;
    self.nightOutButton.alpha = 0.5;
    self.culturalButton.alpha = 1.0;
    self.fitnessButton.alpha = 0.5;
}
- (IBAction)onFitnessButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Fitness";
    self.outdoorsButton.alpha = 0.5;
    self.gastronomyButton.alpha = 0.5;
    self.festivalButton.alpha = 0.5;
    self.nightOutButton.alpha = 0.5;
    self.culturalButton.alpha = 0.5;
    self.fitnessButton.alpha = 1.0;
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
    self.activityAddress.delegate = self;
    self.activityStartTime.delegate = self;
    self.activityEndTime.delegate = self;

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
