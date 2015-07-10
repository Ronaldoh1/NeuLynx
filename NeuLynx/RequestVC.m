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
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
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


    
}
- (IBAction)onRejectButtonTapped:(UIButton *)sender {

  //  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    Activity *activity = self.tempActivitiestArray[indexPath.section];


    [activity.RequestsArray removeObjectAtIndex: indexPath.row];


    [activity saveInBackground];


     [self downloadActivityRequests];

    indexPath = nil;

    [self.tableView reloadData];

}

//helper method to download the activities

-(void)downloadActivityRequests{

    PFQuery *query = [Activity query];

    [query whereKey:@"host" equalTo:[User currentUser]];
    [query whereKey:@"numberOfpaticipants" notEqualTo:@0];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){

        // NSArray *activitiesArray = activities;

        if (!error) {
            //get a copy of all activities


            // Add activities to the map.
            dispatch_async(dispatch_get_main_queue(), ^{

                // NSLog(@"activities are %@",activitiesArray);
                self.tempActivitiestArray = [NSMutableArray arrayWithArray:activities].copy;
                [self.tableView reloadData];

                NSLog(@"it printed %lu", (unsigned long)self.tempActivitiestArray.count);
                //[self.mapView addAnnotations:self.gastronomyActivityArray];


            });



        } else {
            [self displayAlertWithTitle:@"Could Not Retrieve Activities" andWithError:@"Make sure you're connected to WiFi or Phone Network"];


        }


    }




     ];
    //once we have the array with activity, we need to ad them to the map.
    //    [self.mapView addAnnotations:self.festivalActivityArray];
    //                [self.mapView addAnnotations:self.culturalActivityArray];
    //                [self.mapView addAnnotations:self.gastronomyActivityArray];
    //    //            [self.mapView addAnnotations:self.nightOutActivityArray];
    //    //             [self.mapView addAnnotations:self.fitnessActivityArray];
    //    //            [self.mapView addAnnotations:self.outDoorsActivityArray];
    
    
    
    // NSLog(@"%@", self.gastronomyActivityArray);
    
    
}

-(void)displayAlertWithTitle:(NSString *)title andWithError:(NSString *)error{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [alert show];
    
}


#pragma mark - TableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

  //  Activity *activity = self.tempActivitiestArray[indexPath.row];

//    //here we need to get the total count of requests in case the user has posted more than one activity.
//    int count = 0;
//
//    for (int i  = 0; i<self.tempActivitiestArray.count; i++) {
//        count = count + (int)((Activity *)self.tempActivitiestArray[i]).RequestsArray.count;
//    }
    //User *participant = activity.RequestsArray[0]

    return [((Activity*)[self.tempActivitiestArray objectAtIndex:section]).RequestsArray count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%ld", (long)indexPath.row);

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
//    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground"]];

    //change the selection color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    
    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    Activity *activity = self.tempActivitiestArray[indexPath.section];
    User *participant = activity.RequestsArray[indexPath.row];

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
