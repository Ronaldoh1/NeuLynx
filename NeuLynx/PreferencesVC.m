//
//  TravelPreferencesVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/19/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "PreferencesVC.h"

@interface PreferencesVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *personalityArray;
@property NSArray *travelPreferenceArray;
@end

@implementation PreferencesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

-(void)initialSetUp{

    
    //set up personality array;
    self.travelPreferenceArray = @[@"Business Traveler", @"Adventurer Traveler", @"Solo Traveler", @"Gay Traveler", @"Group Traveler", @"The Techie", @"The Planner", @"The Chiller", @"No Budget", @"The Budgeter", @"The helpless", @"Guidebook Memorizer", @"The Minimalist", @"The Repeater", @"The Fit Traveler"];
    self.personalityArray = @[@"Social", @"Party Animal", @"Introverted", @"Extroverted"];


    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = self.navBarTitle;
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

}
#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.travelPreferenceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text = self.travelPreferenceArray[indexPath.row];
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

    return cell;
}


@end
