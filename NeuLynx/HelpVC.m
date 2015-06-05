//
//  HelpVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/27/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "HelpVC.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface HelpVC ()<MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *subjectTitle;
@property (weak, nonatomic) IBOutlet UITextView *messageBody;

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initialSetUp];
}

-(void)initialSetUp{
    //setting image to Navigation Bar's title

    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Need Help?";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];


    //set delegates for title and body
    self.subjectTitle.delegate = self;
    self.messageBody.delegate = self;

}

///////////////ACTION BUTTONS//////////////////////////////
- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)onSendEmailButtonTapped:(UIBarButtonItem *)sender {

    if([self.subjectTitle.text isEqualToString:@""] || [self.messageBody.text isEqualToString:@""]){
        
        [self displayAlert:@"Error Sending Message" andWith:@"Please include a subject title and a message"];


    }else {

    //allocate mail composer
    MFMailComposeViewController *composer = [MFMailComposeViewController new];
    //set the delegate
    [composer setMailComposeDelegate:self ];

    //check if devise can send email

    if ([MFMailComposeViewController canSendMail]){
        [composer setToRecipients:[NSArray arrayWithObjects:@"support@neulynx.com", nil]];
        [composer setSubject:self.subjectTitle.text];
        [composer setMessageBody:self.messageBody.text isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:composer animated:YES completion:nil];

    } else {
        NSLog(@"Can't send mail");
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
-(void)displayAlert:(NSString *)title andWith:(NSString *)error{
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
            self.subjectTitle.text = @"";
            self.messageBody.text = @"How can we help?";
            self.navigationItem.leftBarButtonItem.title = @"Back";
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


- (IBAction)hideKeyBoardForLocationTextField:(UITextField *)sender {
    [sender resignFirstResponder];
    
}

//hide keyboard when user touches outside.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma Marks - TextView Delegate
//clear text when user beings editing
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}





@end
