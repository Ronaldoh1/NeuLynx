//
//  UserSearchResultTVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 8/15/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "UserSearchResultTVC.h"
#import "UserCustomCell.h"
#import "User.h"
@interface UserSearchResultTVC ()

@property (nonatomic, strong) NSArray *array;
@end

@implementation UserSearchResultTVC

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
    return self.searchResultsArray.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}


- (UserCustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //set up the cell
    UserCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];

    //For every row in parse, we are getting a PFObject back for the users that meet the criteria
    User *tempUser = [User new];

    tempUser =[self.searchResultsArray objectAtIndex:indexPath.row];

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

    return cell;

}

@end
