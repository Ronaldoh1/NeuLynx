//
//  PostActivityTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/3/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "PostActivityTVC.h"
#import "Activity.h"
#import "SelectLocationVC.h"
#import "MRProgressOverlayView.h"
#import "MRProgress.h"
#import "SelectTimeTVC.h"


@interface PostActivityTVC ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *activityDescriptionText;
@property (weak, nonatomic) IBOutlet UITextField *activityNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *activityHeadCount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *privacySelector;
@property (weak, nonatomic) IBOutlet UILabel *activityAddress;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

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


@end

@implementation PostActivityTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


    [self initialSetUp];
    //[self setTextFieldsDelegates];


}
-(void)viewWillAppear:(BOOL)animated{
    if (self.imageArray.count == 1){
        self.image1.image = self.imageArray[0];
    }else if(self.imageArray.count == 2){
        self.image2.image = self.imageArray[1];
    }
}

-(void)initialSetUp{

    //set up the textView Description
    self.activityDescriptionText.delegate = self;

    self.activityDescriptionText.text = @"Activity Description - What is it? What's good? What's popping? etc.";
    self.activityDescriptionText.textColor = [UIColor lightGrayColor]; //optional

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Post Activity";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];


//    self.gotPicturesLabel.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
//    self.pickCategoryLabel.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];

    //Disable and Hide the Secondary View - initially
//    self.secondaryView.hidden = YES;
//    self.datePicker.hidden = YES;
//    self.datePicker.enabled = NO;


    //Disable start and end time fields.
//    self.activityStartTime.enabled = NO;
//    self.activityStartTime.userInteractionEnabled = NO;
//
//    self.activityEndTime.enabled = NO;
//    self.activityEndTime.userInteractionEnabled = NO;

//    //Change the color of the secondary view to yellow.
//    self.secondaryView.backgroundColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1];
//
//    //change the color of the date picker
//    [self.datePicker setValue:[UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1] forKeyPath:@"textColor"];


    //Initialize the Activity
    self.activity = [Activity new];

    //Initialize the image array
    self.imageArray = [NSMutableArray new];

    //set up segmented control
    self.privacySelector.tintColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Buttons

- (IBAction)onPostButtonTapped:(UIBarButtonItem *)sender {

    NSString *textFieldError  = @"";

    //if any of the fields are blank, then we show the user an error - all fields are required.
    if ([self.activityNameTextField.text isEqualToString:@""] || [self.activityDescriptionText.text isEqualToString:@""] || [self.activityAddress.text isEqualToString:@""] || [self.activityHeadCount.text isEqualToString:@""] ) {
        textFieldError = @"Error in Form - All fields are required.";

        //|| [self.activityStartTime.text isEqualToString:@""] || [self.activityEndTime.text isEqualToString:@""]
    }

    if ([textFieldError isEqualToString:@""]) {


        self.activity.activityTitle =  self.activityNameTextField.text;
        self.activity.activityDescription = self.activityDescriptionText.text;
        self.activity.activityAddress = self.activityAddress.text;
        self.activity.activityLocation = self.activityGeoPoint;
        self.activity.numberOfpaticipants = @0;
        self.activity.host = [User currentUser];
        self.activity.maxNumberOfParticipants = @([self.activityHeadCount.text integerValue]);
        self.activity.activityPrivacy = [NSNumber numberWithInteger:self.privacySelector.selectedSegmentIndex];

        //saving images if the first is picked only save the first image.
        self.activity.selectedCategory = self.selectedCategory;
        if (self.imageArray.count == 1) {


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

- (IBAction)onCancelButtonTapped:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil]; 
}




- (IBAction)onImageOneSelected:(UIButton *)sender {

    self.isFirstImagePicked = YES;
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];

}
- (IBAction)onImageTwoSelected:(UIButton *)sender {

    self.isSecondImagePicked = YES;
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];
}

///************Select Category***************//


- (IBAction)onFestivalButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Festival";
    self.outdoorsButton.alpha = 0.3;
    self.gastronomyButton.alpha = 0.3;
    self.festivalButton.alpha = 1.0;
    self.nightOutButton.alpha = 0.3;
    self.culturalButton.alpha = 0.3;
    self.fitnessButton.alpha = 0.3;

}

- (IBAction)onCulturalButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Cultural";
    self.outdoorsButton.alpha = 0.3;
    self.gastronomyButton.alpha = 0.3;
    self.festivalButton.alpha = 0.3;
    self.nightOutButton.alpha = 0.3;
    self.culturalButton.alpha = 1.0;
    self.fitnessButton.alpha = 0.3;
}
- (IBAction)gastronomyButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Gastronomy";
    self.outdoorsButton.alpha = 0.3;
    self.gastronomyButton.alpha = 1.0;
    self.festivalButton.alpha = 0.3;
    self.nightOutButton.alpha = 0.3;
    self.culturalButton.alpha = 0.3;
    self.fitnessButton.alpha = 0.3;
}
- (IBAction)onNightOutButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Night Out";
    self.outdoorsButton.alpha = 0.3;
    self.gastronomyButton.alpha = 0.3;
    self.festivalButton.alpha = 0.3;
    self.nightOutButton.alpha = 1.0;
    self.culturalButton.alpha = 0.3;
    self.fitnessButton.alpha = 0.3;
}

- (IBAction)onFitnessButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Fitness";
    self.outdoorsButton.alpha = 0.3;
    self.gastronomyButton.alpha = 0.3;
    self.festivalButton.alpha = 0.3;
    self.nightOutButton.alpha = 0.3;
    self.culturalButton.alpha = 0.3;
    self.fitnessButton.alpha = 1.0;
}
- (IBAction)outDoorsButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Outdoors";
    self.outdoorsButton.alpha = 1.0;
    self.gastronomyButton.alpha = 0.3;
    self.festivalButton.alpha = 0.3;
    self.nightOutButton.alpha = 0.3;
    self.culturalButton.alpha = 0.3;
    self.fitnessButton.alpha = 0.3;
}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Activity Description - What is it? What's good? What's popping? etc."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Activity Description - What is it? What's good? What's popping? etc.";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


#pragma Marks - hiding keyboard
//hide keyboard when the user clicks return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    [self.view endEditing:true];
    return true;
}
//helper method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.activityDescriptionText resignFirstResponder];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source
//The following method is used to managed which cells are selectable.

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0 && indexPath.section == 1) {
        return indexPath;
    } if (indexPath.row == 0 && indexPath.section == 2){
        return indexPath;
    }else {
        return nil;
    }
    
}
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


//Helper Method to dismiss picker when user cancels.

-(void)cancelPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(IBAction)unwindSegueFromSetActivityTimeViewController:(UIStoryboardSegue *)segue{

if([segue.sourceViewController isKindOfClass:[SelectTimeTVC class]]){
    SelectTimeTVC *selectTimeVC = [segue sourceViewController];
    self.activity.startTimeAndDate = selectTimeVC.activity.startTimeAndDate;
    self.activity.endTimeAndDate = selectTimeVC.activity.endTimeAndDate;
    self.startTimeLabel.text = [NSString stringWithFormat:@"Start: %@", selectTimeVC.startTimeLabel.text];
    self.endTimeLabel.text = [NSString stringWithFormat:@"End: %@",selectTimeVC.endTimeLabel.text];
    self.tempLabel.text = @"";


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
