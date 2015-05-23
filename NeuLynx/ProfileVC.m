//
//  ProfileVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "ProfileVC.h"
#import "User.h"
#import "PreferencesVC.h"
#import <CoreText/CoreText.h>

@interface ProfileVC ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource >
@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property NSString *selectedEntry;

@property BOOL genderArraySelected;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orientationPicker;
@property NSMutableArray *languageArray;


@property NSArray *preferencesSelectionArray;

//****Language Buttons******
@property (weak, nonatomic) IBOutlet UIButton *portugueseButton;
@property (weak, nonatomic) IBOutlet UIButton *spanishButton;

@property (weak, nonatomic) IBOutlet UIButton *englishButton;
@property (weak, nonatomic) IBOutlet UIButton *frenchButton;

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpTextFieldDelegates];
    [self initialSetUp];

}
-(void)viewWillAppear:(BOOL)animated{

}

-(void)initialSetUp{

    // Initializing languageArray

    self.languageArray = [NSMutableArray new];

    //Dim the colors of language buttons
    self.portugueseButton.alpha = 0.5;
    self.spanishButton.alpha = 0.5;
    self.englishButton.alpha = 0.5;
    self.frenchButton.alpha = 0.5;

    //Change the Tint For segmented controls.
    [self.genderPicker setTintColor:[UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1]];
    [self.orientationPicker setTintColor:[UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1]];
    self.genderArraySelected = NO;
    //Hide the secondary view initially


    //Set the preferences

    self.preferencesSelectionArray = @[@"Travel Preferences", @"Personality"];

    //Make profile image round

    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 4.0;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1].CGColor;
    

//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"Preferences"];
//    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
//                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
//                      range:(NSRange){0,[attString length]}];
//    self.preferenceLabel.attributedText = attString;
//    self.preferenceLabel.textColor = [UIColor yellowColor];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Profile";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];
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
        self.spanishButton.alpha = 0.5;
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

- (IBAction)onLogOutButtonTapped:(UIBarButtonItem *)sender {

    [User logOut];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];

    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)onChooseProfilePictureTapped:(id)sender {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)onBackButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

//Helper method to set up the textfield delegates
-(void)setUpTextFieldDelegates{
    self.name.delegate = self;
    self.phoneNumber.delegate = self;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    

    //set the cell's row to preferences array.
    cell.textLabel.text = self.preferencesSelectionArray[indexPath.row];

    cell.textLabel.textColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1];

    //center the text
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    //change the background color
    cell.backgroundColor = [UIColor clearColor];

    //add accessory to each cell

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    //Add background image to table view
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground"]];

    //change the selection color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    return cell;


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.preferencesSelectionArray.count;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier]isEqualToString:@"toPreferenceSelection"]){
        PreferencesVC *destinationVC = [segue destinationViewController];

        destinationVC.navBarTitle = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].textLabel.text;
        destinationVC.vCtoPresent = ((int)[self.tableView indexPathForSelectedRow].row);
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
//    if (pickerView == self.genderPicker) {
//        return self.genderArray.count;
//    }else {
//        return self.orientationArray.count;
//    }
//
//}
//
////return the data for the row and component column that's being passed in .
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//
//    if (pickerView == self.genderPicker) {
//          return self.genderArray[row];
//    }else{
//        return self.orientationArray[row];
//    }
//
//
//}
//
////get the selected value of picker.
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//
//    if (pickerView == self.genderPicker) {
//         self.selectedEntry = [self.genderArray objectAtIndex:row];
//    }else{
//         self.selectedEntry = [self.orientationArray objectAtIndex:row];
//    }
//
//}
//



@end
