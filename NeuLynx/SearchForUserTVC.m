//
//  SearchForUserTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/14/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SearchForUserTVC.h"
#import "UserCustomCell.h"
#import "User.h"
#import <Parse/Parse.h>
#import "UserSearchResultTVC.h"
#import "ExclusiveInvite.h"

@interface SearchForUserTVC ()<UISearchResultsUpdating, CLLocationManagerDelegate>

//Search Controller
@property (nonatomic, strong) NSMutableArray *searchResultsArray;
@property (nonatomic, strong) NSArray *usersArray;
@property (nonatomic, strong) UISearchController *searchController;


//CORE LOCATION
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;


@end

@implementation SearchForUserTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetUp];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialSetUp{

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Send Activity to Friends";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Set up initial location manager - initialize and set delegate.
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];




    //Get the initial information to display and populate our tableView

    //There's no transition in our storyboard to our search results tableView Controller or nagigation controller, therefore we'll have to grab it using the instantiateViewControllerWithIdentifer: Method

    UINavigationController *userSearchNagivationController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SearchResultsNavVC"];

    //Our instance of UISearchController will use userSearchResults

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:userSearchNagivationController];

    //the search controller's searchResultUpdater property will contain our tableView.
    self.searchController.searchResultsUpdater = self;

    //Create our searchBar programmatically.

    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);

    self.tableView.tableHeaderView = self.searchController.searchBar;




}

-(void)pullData{

    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.currentLocation];
    PFQuery *query = [User query];
    [query whereKey:@"currentLoccation" nearGeoPoint:geoPoint withinMiles:50.0];

    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error){
        if (!error) {

            self.usersArray = [[NSArray alloc]initWithArray:users];

            NSLog(@"%lu hitttttttt", (unsigned long)self.usersArray.count);

            [self.tableView reloadData];

        }
    }];


}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}

//To get access of the button tapped, we need to get the button position and obtain the indexPath for the cell that was tapped.

- (IBAction)onSendButtonTapped:(UIButton *)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    User *user = (User *)self.usersArray[indexPath.row];

    //NSLog(@"%@ userrrrr", user);

    //NSLog(@"%@ activityyyyyyyyyyy", self.exclusiveActivity);

    ExclusiveInvite *exclusiveInvite = [ExclusiveInvite new];

    exclusiveInvite.exclusiveInvitee = user;
    exclusiveInvite.activity = self.exclusiveActivity;

//
//    NSMutableArray *tempArray = [NSMutableArray new];
//
//       [tempArray addObject:self.exclusiveActivity];
//
//    user.exclusiveInvitesArray = tempArray.copy;

    [exclusiveInvite saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        if (succeeded) {

            NSLog(@"it saved exclusive activity");

        }else{

            NSLog(@"%@", error.localizedDescription);
        }

    }];


//    [PFCloud callFunctionInBackground:@"updateUser" withParameters:@{@"objectId":user.objectId, @"exclusiveActivity":self.exclusiveActivity.objectId} block:^(NSString *result, NSError *error)
//     {
//         if (!error) {
//             NSLog(@"%@",result);
//         }else if(error){
//             NSLog(@"%@", error);
//         }
//     }];



}

-(void)downloadExclusiveInvitesForUser:(User *)user{

    PFQuery *query = [PFQuery queryWithClassName:@"ExclusiveInvite"];
    [query whereKey:@"exclusiveInvitee" equalTo:user];

    [query findObjectsInBackgroundWithBlock:^(NSArray *invitesArray, NSError *error) {
        if (error) {
            // There was an error
            NSLog(@"%@", error.description);
        } else {
            // objects has all the Posts the current user liked.

            NSLog(@"%@",invitesArray);

        }
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.usersArray.count;
}


- (UserCustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //set up the cell
    UserCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];

    //For every row in parse, we are getting a PFObject back for the users that meet the criteria
    User *tempUser = [User new];

    tempUser =[self.usersArray objectAtIndex:indexPath.row];

    //change the background color.

    cell.backgroundColor = [UIColor clearColor];

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    //change the cell accessory
    cell.accessoryType = UITableViewCellAccessoryNone;

    //get the profile Image for each user.

    [tempUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        if(!error){
            UIImage *image = [UIImage imageWithData:data];
            cell.userProfileImage.image = image;
        }

    }];

    cell.nameLabel.text = tempUser.name;

    
    // Configure the cell...
    
    return cell;
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

//Called when the search bar becomes first responder

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    NSString *searchString = self.searchController.searchBar.text;

    [self updateFilteredContentForUser:searchString];

    //if searchResultsController
    if (self.searchController.searchResultsController) {

        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;

        //Present UserSearchResultsTableViewController as topViewController
        UserSearchResultTVC *vc = (UserSearchResultTVC *)navController.topViewController;

        //Update User Search Results;

        vc.searchResultsArray = self.searchResultsArray;

        //Reload the tableView with new data

        [vc.tableView reloadData];


    }



}

-(void)updateFilteredContentForUser:(NSString *)searchStr{

    //If empty the search result is going to be the same as the original data.
    if (searchStr == nil) {
        self.searchResultsArray = [self.usersArray mutableCopy];
    }else {

    //Here we want to make sure that we return the users that contain the string non-case sentive strings for user's name.

        NSMutableArray *searchResults = [NSMutableArray new];

        for (User *user in self.usersArray) {

            NSRange nameRange =[user.name rangeOfString:searchStr options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [searchResults addObject:user];
            }
        }
        self.searchResultsArray = searchResults;

        // Using NSPredicate
//        NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name BEGINSWITH '%@'", searchStr]];
//
//
//        PFQuery *query = [PFQuery queryWithClassName:@"User" predicate:pred];
//
//        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error){
//            if (!error) {
//
//                NSLog(@"%@ userrrrrrssss", users);
//
//
//            }else{
//
//                  NSLog(@"%@ errorrrrrrrr", error.description);
//
//            }
//
//         }];



    }




}
//First we get the user's location - and then download the activities that are within 50 miles radius.

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = locations.firstObject;

    if (self.currentLocation) {
        //[self downloadActivitiesAndDisplayOnMap];

       [self pullData];

    }

    [self.locationManager stopUpdatingLocation];
}

@end
