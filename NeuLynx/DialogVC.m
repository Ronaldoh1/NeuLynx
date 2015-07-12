//
//  DialogVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/11/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "DialogVC.h"
#import "User.h"
#import <Parse/Parse.h>
#import "Message.h"

@interface DialogVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property NSMutableArray *MessageArray;

@end

@implementation DialogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self initialSetUp];
}
-(void)initialSetUp{
    //setting image to Navigation Bar's title

    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Messages";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];


    //add gesture tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewTapped)];
    [self.tableView addGestureRecognizer:tapGesture];

    //retreive messages from parse.
    [self retrieveMessages];

}

#pragma UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.MessageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];

    cell.textLabel.text = ((Message *)self.MessageArray[indexPath.row]).messageText;


    return cell;
}
#pragma mark - Helper Methods


-(void)tableViewTapped{

    [self.messageTextField endEditing:YES];
}

-(void)retrieveMessages{

    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){

        self.MessageArray = [NSMutableArray new];


        if (!error) {

            for (Message *message in objects) {

                [self.MessageArray addObject:message];


            }

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }];
}


#pragma mark - UITextField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        self.heightConstraint.constant = 300;
        [self.view layoutIfNeeded];

    } completion:nil];

    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        self.heightConstraint.constant = 60;
        [self.view layoutIfNeeded];

    } completion:nil];
}


#pragma mark - Action Buttons 

- (IBAction)onSendButtonTapped:(UIButton *)sender {

    //call the end editing method for text field to dismiss keyboard
    [self.messageTextField endEditing:YES];

    //disable the textfield and button
    self.messageTextField.enabled = NO;
    self.sendButton.enabled = NO;

    PFObject *message = [PFObject objectWithClassName:@"Message"];


    //Set the text key to the text of the message textfield
    message[@"messageText"] = self.messageTextField.text;
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.

            // The object has been saved.
            //retrieve the latest message and reload data.

            self.messageTextField.enabled = YES;
            self.sendButton.enabled = YES;

            [self retrieveMessages];
        } else {
            // There was a problem, check error.description

            NSLog(@"%@", error.description);
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            //enable the textfield and button
            self.messageTextField.enabled = YES;
            self.sendButton.enabled = YES;
            self.messageTextField.text = @"";

        });


    }];


    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        self.heightConstraint.constant = 60;
        [self.view layoutIfNeeded];

    } completion:nil];
}


@end
