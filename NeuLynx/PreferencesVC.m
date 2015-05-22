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
@property NSIndexPath *lastIndexPath;
@property NSMutableArray *stateArrayForCheckmark;
@end

@implementation PreferencesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

-(void)initialSetUp{

    //Create a new state array for the checkmarks
    self.stateArrayForCheckmark = [NSMutableArray new];

    //to add the boolean values to the NSMutable Array you need to add it as an NS Number. Ex. [mutableArray addObject[NSNumber numberWithBool:YES]]; or in a for loop like the one below. 

    for(int i = 0; i<15; i++){
    [self.stateArrayForCheckmark addObject:@NO];
    }



    //change the tint for table view

    [self.tableView setTintColor:[UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1]];
    
    //set up personality array;
    self.travelPreferenceArray = @[@"Business Traveler", @"Adventurer Traveler", @"Solo Traveler", @"Gay Traveler", @"Group Traveler", @"The Techie", @"The Planner", @"The Chiller", @"No Budget", @"The Budgeter", @"The helpless", @"Guidebook Memorizer", @"The Minimalist", @"The Repeater", @"The Fit Traveler"];
    self.personalityArray = @[@"Social", @"Party Animal", @"Introverted", @"Extroverted", @"The Artist", @"The Idealist", @"The Scientist/Engineer", @"The Visionary", @"The Executive"];


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

    if (self.vCtoPresent == 0) {
        return self.travelPreferenceArray.count;
    }else{
        return self.personalityArray.count;
    }
}
//***********************NOTES******************************//
//*In order to get a checkmark on selected table view, we need to store
//*Use one identifier for one type of cell - Using multiple identifiers is really only needed when you use diffferent UITableViewCell - subclasses in one table view and you have to rely on thier different behaviours for different cells
///* The cell you reuse can be in any state, which means you have to configure every aspect of the cell again, especially checkmarks/ images/text/accessoryViews/accessoryTypes and more.

//What you need to do is to create a storage for your checkmark states - a simple array containing bools (or NSArray boolean number objects respectively) should do it. Then you neeed to do the checks in cellForRowAtIndexPath

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //CREATE CELL
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //if vc to present is = 0, then present the travel preference array.
    //else present the personality array.

    if (self.vCtoPresent == 0) {
        cell.textLabel.text = self.travelPreferenceArray[indexPath.row];
    }else{
        cell.textLabel.text = self.personalityArray[indexPath.row];
    }

//    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }

    //CONFIGURE CELL
    cell.textLabel.textColor = [UIColor colorWithRed:250/255.0 green:223/255.0 blue:6/255.0 alpha:1];

    //change the background color
    cell.backgroundColor = [UIColor clearColor];

    //Add background image to table view
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground"]];

    //change the selection color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];

    //Add CheckMarks
    if ([[self.stateArrayForCheckmark objectAtIndex:indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    //change the color of scrollbar
    tableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;

    return cell;
}


//*******************REACT TO USE'S TAP***************************//
//

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.stateArrayForCheckmark replaceObjectAtIndex:indexPath.row
                                           withObject:[NSNumber numberWithBool:![[self.stateArrayForCheckmark objectAtIndex:indexPath.row] boolValue]]];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];



}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{


}


@end
