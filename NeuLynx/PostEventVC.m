//
//  PostEventVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "PostEventVC.h"

@interface PostEventVC ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *activityTitle;
@property (weak, nonatomic) IBOutlet UITextField *activityDescription;
@property (weak, nonatomic) IBOutlet UITextField *activityLocation;
@property (weak, nonatomic) IBOutlet UITextField *activityDate;
@property (weak, nonatomic) IBOutlet UITextField *activityStartTime;
@property (weak, nonatomic) IBOutlet UITextField *activityEndTime;
@property NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIImageView *image1;


@end

@implementation PostEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self setTextFieldsDelegates];

}
-(void)viewWillAppear:(BOOL)animated{
    if (self.imageArray.count == 1){
        self.image1.image = self.imageArray[0];
    }
}
-(void)initialSetUp{

    //Initialize the image array
    self.imageArray = [NSMutableArray new];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Post Activity";
    titleView.textColor = [UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];
}

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil]; 

}
- (IBAction)onNextButtonTapped:(UIBarButtonItem *)sender {

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
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];

}

- (IBAction)onPickSecondImageButtonTapped:(UIButton *)sender {
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

    //get the image from image picker
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];

    //add the image to the array.
    [self.imageArray addObject:image];

    //dismiss the picker viewcontroller when user chooses
    [self dismissViewControllerAnimated:picker completion:nil];


}
//dismiss the view controller when user cancels.
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self cancelPicker];

}

@end
