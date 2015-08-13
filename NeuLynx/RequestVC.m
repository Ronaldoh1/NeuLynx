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

@interface RequestVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* tempActivitiestArray;
@property (weak, nonatomic) IBOutlet UILabel *participantNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *participantProfileImage;


@end

@implementation RequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performInitialSetUp];
    [self downloadActivityRequests];
}

-(void)performInitialSetUp{

    //Set the title for the VC.
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Requests";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];;
    [self.navigationItem setTitleView:titleView];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL tmpBool = appDelegate.hideDoneButtonForRequests;

    if (tmpBool == YES) {

        tmpBool = NO;
        appDelegate.hideDoneButtonForRequests = nil;
        self.navigationItem.rightBarButtonItem = nil;

    }
}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onAcceptButtonTapped:(UIButton *)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    Activity *activity = self.tempActivitiestArray[indexPath.section];


    //get the user who we are sending the request to and add it to the accepted people array.
    User *tempUser = [User new];
    tempUser = activity.RequestsArray[indexPath.row];

    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = activity.acceptedPeopleArray.mutableCopy;
    [tempArray addObject:tempUser];
    activity.acceptedPeopleArray = tempArray.copy;
    [activity.RequestsArray removeObjectAtIndex: indexPath.row];

    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            // Create our Installation query
            PFQuery *pushQuery = [PFInstallation query];
            // only return Installations that belong to a User that
            // matches the innerQuery
            [pushQuery whereKey:@"user" matchesQuery: tempUser];

            // Send push notification to query
            PFPush *push = [[PFPush alloc] init];
            [push setQuery:pushQuery]; // Set our Installation query
            [push setMessage:[NSString stringWithFormat:@"%@ has accepted your request!", [User currentUser].name]];
            [push sendPushInBackground];
        }
    }];


    [self downloadActivityRequests];

    indexPath = nil;

    [self.tableView reloadData];

}
- (IBAction)onRejectButtonTapped:(UIButton *)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    Activity *activity = self.tempActivitiestArray[indexPath.section];

    //get the user who we are sending the request to and add it to the accepted people array.

    User *tempUser = [User new];
    tempUser = activity.RequestsArray[indexPath.row];
    [activity.RequestsArray removeObjectAtIndex: indexPath.row];

    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            // Create our Installation query
            PFQuery *pushQuery = [PFInstallation query];
            // only return Installations that belong to a User that
            // matches the innerQuery
            [pushQuery whereKey:@"user" matchesQuery: tempUser];

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

//helper method to download the activities

-(void)downloadActivityRequests{

    PFQuery *query = [Activity query];

    [query whereKey:@"host" equalTo:[User currentUser]];
    [query whereKey:@"numberOfpaticipants" notEqualTo:@0];
    [query includeKey:@"RequestsArray"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){

        // NSArray *activitiesArray = activities;
        if (!error) {
            //get a copy of all activities
            // Add activities to the map.
            dispatch_async(dispatch_get_main_queue(), ^{

                self.tempActivitiestArray = [NSMutableArray arrayWithArray:activities].copy;
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

    return [((Activity*)[self.tempActivitiestArray objectAtIndex:section]).RequestsArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.tempActivitiestArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return ((Activity *)self.tempActivitiestArray[section]).activityTitle;
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

    Activity *activity = self.tempActivitiestArray[indexPath.section];
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

@end
