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
@property NSMutableArray *acceptedHistoryArray;
@property NSMutableArray *postedHistoryArray;

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

    [self downloadActivitiesJoinedForCurrentUser];

    [self downloadActivitiesPostedForCurrentUser];
}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onMessageButtonTapped:(UIButton *)sender {


    //1. Get the activity that user selected.
    Activity *selectedActivity = [Activity new];


    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];


    History *historyRecord = (History *)self.acceptedHistoryArray[indexPath.row];

    selectedActivity = (Activity *)historyRecord.activityJoined;

    NSLog(@"%@ activityyyyyyyyyyyy", selectedActivity);

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     appDelegate.sharedActivity = selectedActivity;

    UIStoryboard *messageStoryboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
            UITabBarController *messageNavVC = [messageStoryboard instantiateViewControllerWithIdentifier:@"SendMessageNavVC"];
    
            [self presentViewController:messageNavVC animated:YES completion:nil];

}

-(void)downloadActivitiesPostedForCurrentUser{


    PFQuery *historyQuery = [PFQuery queryWithClassName:@"Activity"];
    [historyQuery whereKey:@"host" equalTo:[User currentUser]];
    [historyQuery includeKey:@"host"];



//    PFQuery *query = [History query];
//
//    [query whereKey:@"user" equalTo:[User currentUser]];
//    [query includeKey:@"activity"];
//    [query includeKey:@"exclusiveInvitee"];


    [historyQuery findObjectsInBackgroundWithBlock:^(NSArray *historyArray, NSError *error){


        if (!error) {

            NSLog(@"%@", historyArray);
            //get a copy of all activities
            self.postedHistoryArray = [NSMutableArray arrayWithArray:historyArray];
            // Add activities to the map.
            if (self.acceptedHistoryArray.count == 0) {

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Activities Yet 😕" message:@"You haven't joined any activities. Be adventurous and find activities happening near you. Simply head over to the map and check them out!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];


                //[alertView show];
            }

            
        }
        [self.tableView reloadData];
        
    }];
    
    
}


-(void)downloadActivitiesJoinedForCurrentUser{


    PFQuery *historyQuery = [PFQuery queryWithClassName:@"History"];
    [historyQuery whereKey:@"user" equalTo:[User currentUser]];
    [historyQuery includeKey:@"activityJoined"];
    [historyQuery  includeKey:@"activityJoined.host"];


    //    PFQuery *query = [History query];
    //
    //    [query whereKey:@"user" equalTo:[User currentUser]];
    //    [query includeKey:@"activity"];
    //    [query includeKey:@"exclusiveInvitee"];


    [historyQuery findObjectsInBackgroundWithBlock:^(NSArray *historyArray, NSError *error){


        if (!error) {

            //NSLog(@"%@", historyArray);
            //get a copy of all activities
            self.acceptedHistoryArray = [NSMutableArray arrayWithArray:historyArray];
            // Add activities to the map.
            if (self.acceptedHistoryArray.count == 0) {

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Activities Yet 😕" message:@"You haven't joined any activities. Be adventurous and find activities happening near you. Simply head over to the map and check them out!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];


                [alertView show];
            }
            
            
        }
        [self.tableView reloadData];
        
    }];
    
    
}

#pragma marks - TableView Delegate Methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{


    if (section == 0){

        return @"Activities You Joined";

    }else{
        return @"Activities You Posted";
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return [self.acceptedHistoryArray count];
    }else{
        return [self.postedHistoryArray count];
    }


}

-(HistoryCustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HistoryCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //change the background color
    cell.backgroundColor = [UIColor clearColor];

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;


    if (indexPath.section == 0) {



    //For every exclusive invite, we need to popuplate each cell

    History *historyRecord  = (History *)self.acceptedHistoryArray[indexPath.row];

    Activity *activity =  [Activity new];

    activity =  (Activity *)historyRecord.activityJoined;


  [activity fetchIfNeededInBackground];


    User *user = [User new];

    user = (User *)activity.host;


    [user.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        if (!error) {

            dispatch_async(dispatch_get_main_queue(), ^{
             
            UIImage *image = [UIImage imageWithData:data];
            cell.userProfileImage.image = image;

             });
        }else{
            NSLog(@" %@       errorrrrrr %@", error.localizedDescription, error.description);
        }


    }];

    cell.activityTitleLabel.text = activity.activityTitle;
    cell.activityDescriptionText.text = activity.activityDescription;



    return cell;
    }else{


        //Display activities that were posted by current user.

        //History *historyRecord  = (History *)self.acceptedHistoryArray[indexPath.row];

        Activity *activity =  [Activity new];

        activity =  (Activity *)self.postedHistoryArray[indexPath.row];

        [activity fetchIfNeededInBackground];


        User *user = [User new];

        user = (User *)activity.host;


        [user.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

            if (!error) {

                dispatch_async(dispatch_get_main_queue(), ^{

                    UIImage *image = [UIImage imageWithData:data];
                    cell.userProfileImage.image = image;

                });
            }else{
                NSLog(@" %@       errorrrrrr %@", error.localizedDescription, error.description);
            }
            
            
        }];
        
        cell.activityTitleLabel.text = activity.activityTitle;
        cell.activityDescriptionText.text = activity.activityDescription;




        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    //[self performSegueWithIdentifier:@"toDetail" sender:indexPath];//IndexPath as senderi
    if (indexPath.section == 0) {



        UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
        UIViewController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:@"detailNavVc"];

        //set the activity that is goign to be shared through out the app - to dispay to the user when the user clicks on detail.
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


        appDelegate.sharedActivity = (Activity *)(((History *)self.acceptedHistoryArray[indexPath.row]).activityJoined);
        //appDelegate.exclusiveInvite = ((ExclusiveInvite *)self.exclusiveInvitesArray[indexPath.row]);

        [self presentViewController:detailVC animated:YES completion:nil];



    }else if(indexPath.section == 1){


        UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
        UIViewController *detailVC = [detailStoryboard instantiateViewControllerWithIdentifier:@"detailNavVc"];
        detailVC.navigationItem.rightBarButtonItem = nil;

        //set the activity that is goign to be shared through out the app - to dispay to the user when the user clicks on detail.
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


        appDelegate.sharedActivity = (Activity *)(self.postedHistoryArray[indexPath.row]);
        //appDelegate.exclusiveInvite = ((ExclusiveInvite *)self.exclusiveInvitesArray[indexPath.row]);

        [self presentViewController:detailVC animated:YES completion:nil];

    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

//    if(){
//
////        DetailViewController *destinationVC = (DetailViewController *)segue.destinationViewController;
////        destinationVC.icon = self.icon;
//        NSLog(@"hiiiiiiii");
//
//    }else if([segue.identifier isEqual:@"goToRating"]){
////        RatingTableViewController *destinationVC = (RatingTableViewController *)segue.destinationViewController;
////        destinationVC.icon = self.icon;
//
//        NSLog(@"Byeee");
//    }
//    

}

@end
