//
//  SendMessageTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/12/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SendMessageTVC.h"
#import "Message.h"
#import "User.h"
#import "AppDelegate.h"

@interface SendMessageTVC ()<UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property NSMutableArray *inboxArray;

@end

@implementation SendMessageTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated{
    [self initialSetUp];
}

-(void)viewWillAppear:(BOOL)animated{

    [self initialSetUp];
}
-(void)initialSetUp{
    //setting image to Navigation Bar's title

    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Send Message";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];


    //initial textView Set Up
    //set up the textView Description
    self.messageText.delegate = self;

    self.messageText.text = @"Need to know info about this activity? myself? etc? Just send me a quick messsage!";
    self.messageText.textColor = [UIColor lightGrayColor]; //optional

    //initialize array.
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.inboxArray = [NSMutableArray arrayWithArray:appDelegate.sharedActivity.host.inboxArray];

    
}

#pragma mark - Table view delegate

//The following method is used to managed which cells are selectable.

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
    
}


#pragma marks - Action Buttons
- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onSendButtonTapped:(UIBarButtonItem *)sender {

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];



    Message *message = [Message new];

    message.subject = self.subjectTextField.text;
    message.messageText = self.messageText.text;
    message.senderUsername = [User currentUser].username;
    message.recipientUsername = ((User *)appDelegate.sharedActivity.host).username;




    [self.inboxArray addObject:[User currentUser]];

    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            //let the user know his message has been sent.

            [self dismissViewControllerAnimated:YES completion:^{

             [self displaySuccessMessage:appDelegate.sharedActivity.host.name];
            }];


        } else {
            // There was a problem, check error.description

            [self displayErrorMessage:error.description];

        }

        
    }];


}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Need to know info about this activity? myself? etc? Just send me a quick messsage!"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Need to know info about this activity? myself? etc? Just send me a quick messsage!";
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
//helper
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.messageText resignFirstResponder];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

//helper alert method

//helper method to display error message
-(void)displayErrorMessage:(NSString *)error{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error - Please Try Again!" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alertView show];
}

-(void)displaySuccessMessage:(NSString *)recepient{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message Sent!" message:[NSString stringWithFormat:@"Your message has been sent to %@ ", recepient]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alertView show];
}

@end
