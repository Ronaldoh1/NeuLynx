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

   //
}

-(void)viewWillAppear:(BOOL)animated{
    [self initialSetUp];

   
}
-(void)initialSetUp{
    //setting image to Navigation Bar's title

    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
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

#define kBalloonView 1
#define kLabel 2
#define kMessage 3

/* Driving The Table View */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.MessageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    static NSString *CellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // バルーンとテキストの部分を宣言
    UIImageView *balloonView;
    UILabel *label;

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
        balloonView.tag = 1;

        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 2;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont systemFontOfSize:14.0];

        UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        message.tag = 3;
        [message addSubview:balloonView];
        [message addSubview:label];
        message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:message];

    } else {
        balloonView = (UIImageView *)[[cell.contentView viewWithTag:3] viewWithTag:1];
        label = (UILabel *)[[cell.contentView viewWithTag:3] viewWithTag:2];
    }

    NSString *text = ((Message *)[self.MessageArray objectAtIndex:indexPath.row]).messageText;

    // iOS7だとこのコードが使えないのでその下のコード
    // 後にiOS6以下でも走るよう条件分岐する必要があるかも
    // CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize size = [text boundingRectWithSize:CGSizeMake(240.0f, 480.0f)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                     context:nil].size;

    UIImage *balloon;

    // ここでセルに表示する左右の分岐
    if(indexPath.row % 2 == 0)
    {
        balloonView.frame = CGRectMake(370.0f - (size.width + 28.0f), 2.0f, size.width + 28.0f, size.height + 15.0f);
        balloon = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        label.frame = CGRectMake(357.0f - (size.width + 5.0f), 8.0f, size.width + 5.0f, size.height);
    }
    else
    {
        balloonView.frame = CGRectMake(0.0, 2.0, size.width + 28, size.height + 15);
        balloon = [[UIImage imageNamed:@"grey_2"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        label.frame = CGRectMake(16, 8, size.width + 5, size.height);
    }
    
    balloonView.image = balloon;
    label.text = text;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *body = ((Message *)self.MessageArray[indexPath.row]).messageText;
    // CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize size = [body boundingRectWithSize:CGSizeMake(240.0f, 480.0f)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                     context:nil].size;
    return size.height + 15;
}
#pragma mark - Helper Methods


-(void)tableViewTapped{

    [self.messageTextField endEditing:YES];
}

-(void)retrieveMessages{

    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
   [query whereKey:@"recepient" equalTo:self.selectedRecepient];
   [query whereKey:@"sender" equalTo:[User currentUser]];

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
        self.heightConstraint.constant = 260;
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
    message[@"sender"] = [User currentUser];
    message[@"recepient"] = self.selectedRecepient;
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
