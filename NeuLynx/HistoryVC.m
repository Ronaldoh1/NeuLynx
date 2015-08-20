//
//  HistoryVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/7/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "HistoryVC.h"
#import "History.h"
#import "HistoryCustomCell.h"
#import "AppDelegate.h"

@interface HistoryVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *historyArray;

@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialSetUp];
}
-(void)initialSetUp{
    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"History";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    [self downloadHistoryForCurrentUser];
}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onMessageButtonTapped:(UIButton *)sender {


    //1. Get the activity that user selected.
    Activity *selectedActivity = [Activity new];


    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];


    History *historyRecord = (History *)self.historyArray[indexPath.row];

    selectedActivity = (Activity *)historyRecord.activityJoined;

    NSLog(@"%@ activityyyyyyyyyyyy", selectedActivity);

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     appDelegate.sharedActivity = selectedActivity;

    UIStoryboard *messageStoryboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
            UITabBarController *messageNavVC = [messageStoryboard instantiateViewControllerWithIdentifier:@"SendMessageNavVC"];
    
            [self presentViewController:messageNavVC animated:YES completion:nil];

}

-(void)downloadHistoryForCurrentUser{



    PFQuery *query = [History query];

    [query whereKey:@"user" equalTo:[User currentUser]];


    [query findObjectsInBackgroundWithBlock:^(NSArray *historyArray, NSError *error){


        if (!error) {
            //get a copy of all activities
            self.historyArray = [NSMutableArray arrayWithArray:historyArray];
            // Add activities to the map.
            if (self.historyArray.count == 0) {

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Activities Yet 😕" message:@"You haven't joined any activities. Be adventurous and find activities happening near you. Simply head over to the map and check them out!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];


                [alertView show];
            }

            
        }
        [self.tableView reloadData];
        
    }];
    
    
}



#pragma marks - TableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.historyArray count];
}

-(HistoryCustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HistoryCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //change the background color
    cell.backgroundColor = [UIColor clearColor];

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;



    //For every exclusive invite, we need to popuplate each cell

    History *historyRecord  = (History *)self.historyArray[indexPath.row];

    Activity *activity = (Activity *)historyRecord.activityJoined;

    [activity fetchIfNeededInBackground];

    [(User *)activity.host fetchIfNeeded];

    User * user = (User *)activity.host;

    [user.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        if (!error) {

            UIImage *image = [UIImage imageWithData:data];
            cell.userProfileImage.image = image;
        }else{
            NSLog(@" %@       errorrrrrr %@", error.localizedDescription, error.description);
        }


    }];

    cell.activityTitleLabel.text = activity.activityTitle;
    cell.activityDescriptionText.text = activity.activityDescription;



    return cell;
    
}




@end
