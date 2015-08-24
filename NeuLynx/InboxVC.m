//
//  InboxVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/11/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "InboxVC.h"
#import <Parse/Parse.h>
#import "User.h"
#import "DialogVC.h"
#import "AppDelegate.h"
#import "Message.h"
#import "InboxCustomCell.h"
#import "Inbox.h"

@interface InboxVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *inboxArray;
@property DialogVC *activeDialogVC;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@end

@implementation InboxVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetUp]; 
}

-(void)viewWillAppear:(BOOL)animated{

    self.activeDialogVC = nil;

   

    [self initialSetUp];
}
-(void)initialSetUp{
    //setting image to Navigation Bar's title

    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Inbox";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //initialize the inboxArray

    [self downloadInboxForCurrentUser];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL tmpBool = appDelegate.hideDoneButtonForMessages;

    if (tmpBool == YES) {
        tmpBool = NO;
        appDelegate.hideDoneButtonForMessages = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.doneBarButton.enabled = NO;

    }
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    [self downloadInboxForCurrentUser];
}
- (IBAction)onDoneButtonDone:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.inboxArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


     InboxCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fromCell"];
    User *sender = (User *)(self.inboxArray[indexPath.row]);
    [sender fetchIfNeededInBackground];
   // Message *message = ((Message *)(self.inboxArray[indexPath.row]));
    cell.senderNameLabel.text = sender.name;

    [sender.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.userProfileImage.image = image;
        }

    }];
    //cell.detailTextLabel.text = @"You got a Message";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //deselect the cell that was selected.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Segue to open a dialog
    if ([segue.identifier isEqualToString:@"OpenDialogSegue"]) {
        self.activeDialogVC = segue.destinationViewController;
        NSInteger chatMateIndex = [[self.tableView indexPathForCell:(UITableViewCell *)sender] row];
        self.activeDialogVC.selectedRecipient = (User *)self.inboxArray[chatMateIndex];

        return;
    }
}

#pragma mark - Helper methods
//This helper method allows us retrieve an array which contains the messages that have been sent the current user. Query the database where the recepient is the current user and then iterate through each object found and add message object and sender pointer to the inboxArray if and only if it has not been previously added.

-(void)downloadInboxForCurrentUser{
    NSMutableArray *array = [NSMutableArray new];


    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat: @"(messageContactUsername = '%@') OR (inboxOwnerUsername = '%@')", [User currentUser].username, [User currentUser].username]];



    PFQuery *query = [PFQuery queryWithClassName:@"Inbox" predicate:predicate];

    //[query orderByAscending:@"updatedAt"];

//
//    PFQuery *query = [PFQuery queryWithClassName:@"Inbox"];
//    [query whereKey:@"inboxOwner" equalTo:[User currentUser]];
//    [query whereKey:@"messageContact" equalTo:[User currentUser]];
    [query includeKey:@"messageContact"];
    [query includeKey:@"inboxOwner"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){

    NSLog(@"YOOOOOOOOOOOOOO, %@", objects);

        if (!error) {
            for (Inbox *contact in objects) {



                if (![array containsObject:contact.messageContact] && contact.messageContact != [User currentUser])  {
                    [array addObject:contact.messageContact];

                }else if (![array containsObject:contact.inboxOwner]  && contact.inboxOwner != [User currentUser]){
                    
                    [array addObject:contact.inboxOwner];
                }
                }

           // NSLog(@"%@", array);
            self.inboxArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
            
        }
        
    }];
}
@end
