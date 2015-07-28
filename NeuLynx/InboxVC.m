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

@interface InboxVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *inboxArray;
@property DialogVC *activeDialogVC;

@end

@implementation InboxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

    self.inboxArray = [NSMutableArray arrayWithArray:[User currentUser].inboxArray];

//    [self.inboxArray addObject:[User currentUser]];
//    [[User currentUser] save];

    

}



#pragma mark - UITableView Delegate 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.inboxArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fromCell"];

    User *sender = (User *)self.inboxArray[indexPath.row];

    NSLog(@"%@", sender.name);

    cell.textLabel.text = sender.name;

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
        self.activeDialogVC.selectedRecepient = (User *)self.inboxArray[chatMateIndex];

        return;
    }
}


#pragma mark Functional methods

////we need to retrieve the full list of individuals who have messaged the current user.
//-(NSMutableArray *)retrieveListUsersWhoMessaged{
//
//    //we need to clean the list of array so that we don't append the same twice.
//    [self.inboxArray removeAllObjects];
//
//
//    //perform query and retrieve the array that contains the users who have messaged the person.
//    PFQuery *query = [PFUser query];
//
////    [query findObjectsInBackgroundWithBlock:
////
////
////     ]
//
//
//
//
//
//}


@end
