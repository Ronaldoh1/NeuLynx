//
//  AccountVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/18/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "AccountVC.h"
#import "User.h"


@interface AccountVC ()<UITableViewDelegate, UITableViewDataSource>
@property NSArray *menuArray;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property User *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *usersNameLabel;

@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetUp];
}

-(void)initialSetUp{
    //get Current User
    self.currentUser = [User currentUser];

    //get user's name
    self.usersNameLabel.text = self.currentUser.name;

    //Set up Menu Array

    self.menuArray = [NSArray new];
    self.menuArray = @[@"Home Location",@"Indox", @"Requests", @"History", @"Search Activity", @"Payments", @"Help", @"About", @"Terms & Conditions"];

    //Make Profile Image round

    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 4.0;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1].CGColor;

    //change color of logout button

    [self.logoutButton setTitleColor:[UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1] forState:UIControlStateNormal];


    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Account & Settings";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //get user profile Image
    [self getUsersProfileImage];
    
}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

//display the profile view to allow the user to edit.
- (IBAction)onViewProfileButtonTapped:(UIButton *)sender {


        UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        UINavigationController *profileNavVC = [profileStoryboard instantiateViewControllerWithIdentifier:@"profileNavVC"];
        [self presentViewController:profileNavVC animated:YES completion:nil];

}

- (IBAction)onLogOutButtonTapped:(UIButton *)sender {
    [User logOut];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma Mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //display the cells for each button
    cell.textLabel.text = self.menuArray[indexPath.row];
    //change the color of text
    cell.textLabel.textColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1];
    //change the background color
    cell.backgroundColor = [UIColor clearColor];

     //Add background image to table view
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground"]];

    //change the selection color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    //chnage the cell accessory
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuArray.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {

    }else if(indexPath.row == 1){

    }else if(indexPath.row == 2){

    }else if(indexPath.row == 3){
        UIStoryboard *historyStoryBoard = [UIStoryboard storyboardWithName:@"History" bundle:nil];
        UINavigationController *historyNavVC = [historyStoryBoard instantiateViewControllerWithIdentifier:@"HistoryNavVC"];
        [self presentViewController:historyNavVC animated:YES completion:nil];


    }else if(indexPath.row == 4){

    }else if(indexPath.row == 5){

    }else if(indexPath.row == 6){

    }else if(indexPath.row == 8){ //Present terms and Conditions

        UIStoryboard *termsAndConditionsStoryBoard = [UIStoryboard storyboardWithName:@"TermsAndConditions" bundle:nil];
        UINavigationController *termsAndConditionsNavVC = [termsAndConditionsStoryBoard instantiateViewControllerWithIdentifier:@"TermsAndConditionsNavVC"];
        [self presentViewController:termsAndConditionsNavVC animated:YES completion:nil];



    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{




}


//*******************Helper Method***************************//
//Helper method to download user's profile image
-(void)getUsersProfileImage{

    [self.currentUser.profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.profileImage.image = image;
        }

    }];
}

@end
