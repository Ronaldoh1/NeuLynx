//
//  InboxSearchResultTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/24/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "InboxSearchResultTVC.h"
#import "User.h"
#import "DialogVC.h"
#import "InboxCustomCell.h"

@interface InboxSearchResultTVC ()
@property DialogVC *activeDialogVC;

@end

@implementation InboxSearchResultTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    InboxCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fromCell"];
    User *sender = (User *)(self.searchResults[indexPath.row]);
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

#pragma mark Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Segue to open a dialog
    if ([segue.identifier isEqualToString:@"OpenDialogSegue"]) {
        self.activeDialogVC = segue.destinationViewController;
        NSInteger chatMateIndex = [[self.tableView indexPathForCell:(UITableViewCell *)sender] row];
        self.activeDialogVC.selectedRecipient = (User *)self.searchResults[chatMateIndex];

        return;
    }
}

@end
