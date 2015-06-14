//
//  PostEventVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "PostActivityVC.h"
#import "Activity.h"
#import "SelectLocationVC.h"
#import "MRProgressOverlayView.h"
#import "MRProgress.h"

@interface PostActivityVC ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *activityTitle;
@property (weak, nonatomic) IBOutlet UITextField *activityDescription;
@property (weak, nonatomic) IBOutlet UITextField *activityAddress;
@property (weak, nonatomic) IBOutlet UITextField *activityMaxHeadCount;
@property (weak, nonatomic) IBOutlet UITextField *activityStartTime;
@property (weak, nonatomic) IBOutlet UITextField *activityEndTime;
//*******Images*****************//
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

- (IBAction)onPostButtonTapped:(UIBarButtonItem *)sender {

    NSString *textFieldError  = @"";

    //if any of the fields are blank, then we show the user an error - all fields are required.
    if ([self.activityTitle.text isEqualToString:@""] || [self.activityDescription.text isEqualToString:@""] || [self.activityAddress.text isEqualToString:@""] || [self.activityMaxHeadCount.text isEqualToString:@""] || [self.activityStartTime.text isEqualToString:@""] || [self.activityEndTime.text isEqualToString:@""]) {
        textFieldError = @"Error in Form - All fields are required.";

    }

    if ([textFieldError isEqualToString:@""]) {


    self.activity.activityTitle =  self.activityTitle.text;
    self.activity.activityDescription = self.activityDescription.text;
    self.activity.activityAddress = self.activityAddress.text;
    self.activity.activityLocation = self.activityGeoPoint;
        self.activity.numberOfpaticipants = @0;
        self.activity.host = [User currentUser];
    self.activity.maxNumberOfParticipants = @([self.activityMaxHeadCount.text integerValue]);

    //saving images if the first is picked only save the first image. 
    self.activity.selectedCategory = self.selectedCategory;
    if (self.imageArray.count == 1) {

        NSMutableArray *imageTempArray = [NSMutableArray new];

        NSData *imageOneData = UIImagePNGRepresentation((UIImage *) self.imageArray[0]);
        self.activity.activityImage1 = [PFFile fileWithData:imageOneData];
        //[self.activity.activityImage1 saveInBackground];

    } else if(self.imageArray.count == 2){

        //Image 1
        NSData *imageOneData = UIImagePNGRepresentation((UIImage *) self.imageArray[0]);
        self.activity.activityImage1 = [PFFile fileWithData:imageOneData];
        //Image 2
        NSData *imageTwoData = UIImagePNGRepresentation((UIImage *) self.imageArray[1]);;
        self.activity.activityimage2 = [PFFile fileWithData:imageTwoData];

        //[self.activity.activityimage2 saveInBackground];
    }


   // self.activity.activityImage2 = self.image2.image;


    //disable right nav bar item so that user does not double post.
    self.navigationItem.rightBarButtonItem.enabled = NO;

        [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Saving..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];

 [self saveUserInformationToParse:^{


    [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {

            // The object has been saved.
          //  [self displaySuccessMessage];
//            [self dismissViewControllerAnimated:YES completion:nil];
            [MRProgressOverlayView dismissOverlayForView: self.view animated:YES];

            [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Success!" mode:MRProgressOverlayViewModeCheckmark animated:YES];

            [self dismissIndicator:^{



                [MRProgressOverlayView dismissOverlayForView: self.view animated:YES];
                
                UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *mapNavVC = [mapStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
                [self presentViewController:mapNavVC animated:YES completion:nil];


            } afterDelay:3];
            





        } else {
            // There was a problem, check error.description
            [self displayErrorMessage:error.description];
        }
    }];


 } afterDelay:1.5];

    } else{
        [self displayErrorMessage:textFieldError];
    }
}

//*******Enable and show the secondary view with date picker.******//
- (IBAction)onStartDateAndTimeButtonTapped:(UIButton *)sender {

    [self.activityMaxHeadCount resignFirstResponder];
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


- (IBAction)onFestivalButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Festival";
    self.outdoorsButton.alpha = 0.5;
    self.gastronomyButton.alpha = 0.5;
    self.festivalButton.alpha = 1.0;
    self.nightOutButton.alpha = 0.5;
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
- (IBAction)gastronomyButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Gastronomy";
    self.outdoorsButton.alpha = 0.5;
    self.gastronomyButton.alpha = 1.0;
    self.festivalButton.alpha = 0.5;
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

- (IBAction)onFitnessButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Fitness";
    self.outdoorsButton.alpha = 0.5;
    self.gastronomyButton.alpha = 0.5;
    self.festivalButton.alpha = 0.5;
    self.nightOutButton.alpha = 0.5;
    self.culturalButton.alpha = 0.5;
    self.fitnessButton.alpha = 1.0;
}
- (IBAction)outDoorsButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Outdoors";
    self.outdoorsButton.alpha = 1.0;
    self.gastronomyButton.alpha = 0.5;
    self.festivalButton.alpha = 0.5;
    self.nightOutButton.alpha = 0.5;
    self.culturalButton.alpha = 0.5;
    self.fitnessButton.alpha = 0.5;
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
//Helper method to get address of location chosen

-(NSString*)getAddressFromLatLong : (NSString *)latLng {
    //  NSString *string = [[Address.text stringByAppendingFormat:@"+%@",cityTxt.text] stringByAppendingFormat:@"+%@",addressText];
    NSString *esc_addr =  [latLng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    NSMutableDictionary *data = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *dataArray = (NSMutableArray *)[data valueForKey:@"results" ];
    if (dataArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter a valid address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        for (id firstTime in dataArray) {
            NSString *jsonStr1 = [firstTime valueForKey:@"formatted_address"];
            return jsonStr1;
        }
    }

    return nil;
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

//dismiss the view controller when user cancels.
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self cancelPicker];

}


//***********************Segues********************************************//

-(IBAction)unwindSegueFromSetLocationOnMapViewController:(UIStoryboardSegue *)segue{



    //First we need to check if the sourceViewController is of the class SelectLocaitonVC class. This step is an extra safety step.
    //If it is, the we need to create the SelectLocationVC and make it equal to the sourceViewController.
    //
    if ([segue.sourceViewController isKindOfClass:[SelectLocationVC class]]) {

        SelectLocationVC *selectLocationVC = [segue sourceViewController];

        self.activityGeoPoint = [PFGeoPoint new];

       self.activityGeoPoint.latitude= selectLocationVC.activityGeoPoint.latitude;
        self.activityGeoPoint.longitude = selectLocationVC.activityGeoPoint.longitude;
        self.activityAddress.text = [self getAddressFromLatLong:[NSString stringWithFormat:@"%f,%f",self.activityGeoPoint.latitude, self.activityGeoPoint.longitude]];

        NSLog(@"the activity's geo point is %f %f", selectLocationVC.activityGeoPoint.latitude
              , selectLocationVC.activityGeoPoint.longitude);

    }
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

@end
