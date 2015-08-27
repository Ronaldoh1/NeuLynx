//
//  BugReportVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/12/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "BugReportVC.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface BugReportVC ()<MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *problemTitle;
@property (weak, nonatomic) IBOutlet UITextView *messageBody;
@property (assign) CGFloat animatedDistance;

@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation BugReportVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetUp];
}

-(void)initialSetUp{
    //setting image to Navigation Bar's title

    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Report a Problem";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];


}


///////////////ACTION BUTTONS//////////////////////////////
- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)onSendEmailButtonTapped:(UIBarButtonItem *)sender {

    if([self.problemTitle.text isEqualToString:@""] || [self.messageBody.text isEqualToString:@""]){

        [self displayAlert:@"Error Sending Message" andWithError:@"Please include a subject title and a message"];


    }else {

        //allocate mail composer
        MFMailComposeViewController *composer = [MFMailComposeViewController new];
        //set the delegate
        [composer setMailComposeDelegate:self ];

        //check if devise can send email

        if ([MFMailComposeViewController canSendMail]){
            [composer setToRecipients:[NSArray arrayWithObjects:@"support@neulynx.com", nil]];
            [composer setSubject:self.problemTitle.text];
            [composer setMessageBody:self.messageBody.text isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:composer animated:YES completion:nil];

        } else {

            [self displayAlert:@"Cannot Send Email" andWithError:@"Please try again"];
        }
    }

}

////////////////*****************HELPER METHODS************************///////////////////
//display alert method
-(void)displayAlertWithTitle:(NSString *)title andWith:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:[NSString stringWithFormat:@"Error %@", [error description]]
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
}
-(void)displayAlert:(NSString *)title andWithError:(NSString *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:error
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Mail Delegate Method

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{

    //if there is no errror
    if (!error) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.problemTitle.text = @"";
            self.messageBody.text = @"Please describe in detailsthe problem you encountered.  If something isn't working please let us know - e.g. features, notifications etc. Or simply provide general feedback. We would love to hear from you.";
            self.navigationItem.leftBarButtonItem.title = @"Cancel";
        }];

        //if there is an error we present an alert.
    } else {
        [self displayAlertWithTitle:@"Error Sending Email" andWith:error];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}
#pragma Marks - hiding keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    [self.view endEditing:true];
    return true;
}

//hide keyboard when user touches outside.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma Marks - TextView Delegate
//clear text when user beings editing
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}


#pragma Marks - hiding keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0){
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0){
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown){
        self.animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else{
        self.animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= self.animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

    [self.view setFrame:viewFrame];

    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += self.animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
