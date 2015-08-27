//
//  RequestVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/30/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "RequestVC.h"
#import "RequestCustomCell.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "User.h"
#import "History.h"
#import "Inbox.h"
#import "SocialTracker.h"

@interface RequestVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* activitiestArray;
@property (nonatomic, strong) SocialTracker *socialTracker;

@end

@implementation RequestVC

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performInitialSetUp];

}
-(void)viewWillAppear:(BOOL)animated{
    [self performInitialSetUp];


    [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
}

-(void)performInitialSetUp{

    [self downloadActivityRequests];

    //Set the title for the VC.
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Requests";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];;
    [self.navigationItem setTitleView:titleView];

    //self.navigationItem.rightBarButtonItem = nil;

}

- (IBAction)onAcceptButtonTapped:(UIButton *)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    Activity *activity = self.activitiestArray[indexPath.section];


    //get the user who we are sending the request to and add it to the accepted people array.
    User *tempUser = [User new];
    tempUser = activity.RequestsArray[indexPath.row];

    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = activity.acceptedPeopleArray.mutableCopy;
    [tempArray addObject:tempUser];
    activity.acceptedPeopleArray = tempArray.copy;
    [activity.RequestsArray removeObjectAtIndex: indexPath.row];

    //Add users to inbox.
    Inbox *newContact = [Inbox new];

    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

//Create history record for user.

            History *historyRecord = [History new];
            historyRecord.activityJoined = activity;
            historyRecord.user = tempUser;
            [historyRecord saveInBackground];

            // Create our Installation query
            PFQuery *pushQuery = [PFInstallation query];
            // only return Installations that belong to a User that

            [pushQuery whereKey:@"user" equalTo:tempUser];

            // Send push notification to query
            PFPush *push = [[PFPush alloc] init];
            [push setQuery:pushQuery]; // Set our Installation query
            [push setMessage:[NSString stringWithFormat:@"%@ has accepted your request!", [User currentUser].name]];
            [push sendPushInBackground];


            newContact.inboxOwner = [User currentUser];
            newContact.inboxOwnerUsername = [User currentUser].username;
            newContact.messageContact = tempUser;
            newContact.messageContactUsername = tempUser.username;
            [newContact saveInBackground];


            //Update Social Tracker

            if ([User currentUser] != nil) {

                self.socialTracker = [SocialTracker new];
                self.socialTracker.points = @3;
                self.socialTracker.pointsOwner = tempUser;
                [self.socialTracker saveInBackground];

            }

        }
    }];




    [self downloadActivityRequests];

    indexPath = nil;

    [self.tableView reloadData];

}
- (IBAction)onRejectButtonTapped:(UIButton *)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Activity *activity = self.activitiestArray[indexPath.section];

    //get the user who we are sending the request to and add it to the accepted people array.

    User *tempUser = [User new];
    tempUser = activity.RequestsArray[indexPath.row];
    [activity.RequestsArray removeObjectAtIndex: indexPath.row];

    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            // Create our Installation query
            PFQuery *pushQuery = [PFInstallation query];
            // only return Installations that belong to a User that

            [pushQuery whereKey:@"user" equalTo:tempUser];

            // Send push notification to query
            PFPush *push = [[PFPush alloc] init];
            [push setQuery:pushQuery]; // Set our Installation query
            [push setMessage:[NSString stringWithFormat:@"%@ has rejected your request. Don't give up keep looking for other activities!", [User currentUser].name]];
            [push sendPushInBackground];
        }
    }];

    [self downloadActivityRequests];

    indexPath = nil;

    [self.tableView reloadData];

}

- (IBAction)onProfileButtonTapped:(UIButton *)sender {

    //get the indexPath for the request.

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    //use the indexPath to get the activity related to the request.
    Activity *activity = self.activitiestArray[indexPath.section];

    //get the participant for that activity based on the index Path.
    User *participant = (User *)activity.RequestsArray[indexPath.row];

    //Set the selectedUser which will be used in the Profile Detail.

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


    appDelegate.selectedUser = participant;


    UIStoryboard *UserDetailStoryboard = [UIStoryboard storyboardWithName:@"UserDetail" bundle:nil];
    UINavigationController *userDetailNavVC = [UserDetailStoryboard instantiateViewControllerWithIdentifier:@"userDetailNavVC"];

    [self presentViewController:userDetailNavVC animated:YES completion:nil];
    
}


//helper method to download the activities

-(void)downloadActivityRequests{

    PFQuery *query = [Activity query];

    [query whereKey:@"host" equalTo:[User currentUser]];
    [query whereKey:@"numberOfpaticipants" notEqualTo:@0];
    [query includeKey:@"RequestsArray"];
    [query includeKey:@"Reward"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){

        // NSArray *activitiesArray = activities;
        if (!error) {
            //get a copy of all activities
            // Add activities to the map.
            dispatch_async(dispatch_get_main_queue(), ^{

                self.activitiestArray = [NSMutableArray arrayWithArray:activities].copy;
                [self.tableView reloadData];

            });

        }
    }];

}

-(void)displayAlertWithTitle:(NSString *)title andWithError:(NSString *)error{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}


#pragma mark - TableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [((Activity*)[self.activitiestArray objectAtIndex:section]).RequestsArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.activitiestArray.count;
}

/*Return the title for each section if and only if the row count for each section is not 0. */
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }else{

    return ((Activity *)self.activitiestArray[section]).activityTitle;
    }
}

-(RequestCustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //set up the cell
    RequestCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //change the color of text
    cell.textLabel.textColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];

    //change the background color
    cell.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];

    //Add background image to table view
    tableView.backgroundColor = [UIColor whiteColor];

    //change the selection color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    Activity *activity = self.activitiestArray[indexPath.section];
    User *participant = (User *)activity.RequestsArray[indexPath.row];

    cell.nameLabel.text = participant.name;
    cell.aboutParticipant.text = participant.aboutMe;
    
    [participant.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.userProfileImage.image = image;
        }
        
    }];
    
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    if ([tableView numberOfRowsInSection:section] == 0) {
//        return 0.01f;
//    }else{
//
//    return 4.0f;
//    }
//}
@end
