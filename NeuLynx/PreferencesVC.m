//
//  TravelPreferencesVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/19/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "PreferencesVC.h"
#import "User.h"


@interface PreferencesVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *personalityArrayForTableView;
@property NSArray *travelPreferenceArrayForTableView;
@property NSIndexPath *lastIndexPath;
@property NSMutableArray *stateArrayForCheckmark;
@property NSMutableArray *selectedPersonalityArray;
@property User *currentUser;


@property NSMutableArray *localTravelPreferencesArray;
@property NSMutableArray *localTravelPreferencesBoolArray;

@property NSMutableArray *localPersonalityArray;
@property NSMutableArray *localPersonalityBoolArray;

@end

@implementation PreferencesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

-(void)viewWillDisappear:(BOOL)animated{

    if (self.vCtoPresent == 0) {
        self.currentUser.TravelPreferencesBoolArray = self.localTravelPreferencesBoolArray.copy;
        self.currentUser.travelPreferencesArray = self.localTravelPreferencesArray.copy;

        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {



            if (succeeded) {
                //[self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self displayErrorMessage:error.description];

            }
        }];
    } else {

        self.currentUser.personalityBoolArray = self.localPersonalityBoolArray.copy;
        self.currentUser.personalityArray = self.localPersonalityArray.copy;

        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {



            if (succeeded) {
               // [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self displayErrorMessage:error.description];
                
            }
        }];
    }

}
-(void)initialSetUp{

    //set up preference array;
    self.travelPreferenceArrayForTableView = @[@"Business Traveler", @"Adventurer Traveler", @"Solo Traveler", @"Gay Traveler", @"Group Traveler", @"The Techie", @"The Planner", @"The Chiller", @"No Budget", @"The Budgeter", @"The helpless", @"Guidebook Memorizer", @"The Minimalist", @"The Repeater", @"The Fit Traveler"];

    self.personalityArrayForTableView = @[@"Social", @"Party Animal", @"Introverted", @"Extroverted", @"The Artist", @"The Idealist", @"The Scientist/Engineer", @"The Visionary", @"The Executive"];
    //get reference to current user
    self.currentUser = [User currentUser];

    //set up the arrays for travel preference.
    self.localTravelPreferencesArray = [NSMutableArray arrayWithArray:self.currentUser.travelPreferencesArray];
    self.localTravelPreferencesBoolArray = [NSMutableArray arrayWithArray:self.currentUser.TravelPreferencesBoolArray];


    //set up the arrays for personality
    self.localPersonalityArray = [NSMutableArray arrayWithArray:self.currentUser.personalityArray];
    self.localPersonalityBoolArray = [NSMutableArray arrayWithArray:self.currentUser.personalityBoolArray];







    //Create a new state array for the checkmarks
    self.stateArrayForCheckmark = [NSMutableArray new];





    //to add the boolean values to the NSMutable Array you need to add it as an NS Number. Ex. [mutableArray addObject[NSNumber numberWithBool:YES]]; or in a for loop like the one below.

    //if VC to present is equal to 0, then we use the travel preference array.
    //else we need to present the personality array.
    if (self.vCtoPresent == 0) {

        if (self.localTravelPreferencesArray.count != 0) {



            for (id preference in self.localTravelPreferencesBoolArray) {

                BOOL preferenceBool = [preference boolValue];

                if (preferenceBool == YES) {
                     [self.stateArrayForCheckmark addObject:@YES];
                }else  if (preferenceBool == NO){
                    [self.stateArrayForCheckmark addObject:@NO];

                }
            }

        }else{
            for(int i = 0; i<15; i++){


                [self.stateArrayForCheckmark addObject:@NO];
                [self.localTravelPreferencesBoolArray addObject:@NO];


            }

        }

    } else if (self.vCtoPresent == 1) {

        if (self.localPersonalityArray.count != 0) {

        for (id preference in self.localPersonalityBoolArray) {
            BOOL preferenceBool = [preference boolValue];
            if (preferenceBool == YES) {
                [self.stateArrayForCheckmark addObject:@YES];
            }else if (preferenceBool == NO){
                [self.stateArrayForCheckmark addObject:@NO];
            }
        }
        }else {
            for (int i = 0; i<15; i++) {
                [self.stateArrayForCheckmark addObject:@NO];
                [self.localPersonalityBoolArray addObject:@NO];
            }
        }

    }





    //change the tint for table view

    [self.tableView setTintColor:[UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1]];
    


    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = self.navBarTitle;
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

}

//- (IBAction)onSaveButtonTapped:(UIBarButtonItem *)sender {
//
//    if (self.vCtoPresent == 0) {
//        self.currentUser.TravelPreferencesBoolArray = self.localTravelPreferencesBoolArray.copy;
//        self.currentUser.travelPreferencesArray = self.localTravelPreferencesArray.copy;
//
//        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//
//
//
//            if (succeeded) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }else{
//                [self displayErrorMessage:error.description];
//                
//            }
//        }];
//    } else {
//
//        self.currentUser.personalityBoolArray = self.localPersonalityBoolArray.copy;
//        self.currentUser.personalityArray = self.localPersonalityArray.copy;
//
//        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//
//
//
//            if (succeeded) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }else{
//                [self displayErrorMessage:error.description];
//                
//            }
//        }];
//    }
//
//}





#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.vCtoPresent == 0) {
        return self.travelPreferenceArrayForTableView.count;
    }else {
        return self.personalityArrayForTableView.count;
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
        cell.textLabel.text = self.travelPreferenceArrayForTableView[indexPath.row];
    }else{
        cell.textLabel.text = self.personalityArrayForTableView[indexPath.row];
    }

//    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }

    //CONFIGURE CELL
    cell.textLabel.textColor = [UIColor grayColor];

//    //change the background color
//    cell.backgroundColor = [UIColor clearColor];

//    //Add background image to table view
//    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBackground"]];

//    //change the selection color
//    UIView *bgColorView = [[UIView alloc] init];
//    bgColorView.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
//    [cell setSelectedBackgroundView:bgColorView];

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

   //need to check if the localTravelPreferenceArray - if it's set to no, then set it back to yes. if it's set to yes, then set it back to no. This will keep track of the selected cells that will be presented to the user.
    //Local travel preference array contain the actual travel preferences for the user. If the array already contains the preference do not add it. If the user deselects the preference, search for the preference in local Travel prefernce array if its found remove it.
    if (self.vCtoPresent == 0) {


    if ([self.localTravelPreferencesBoolArray[indexPath.row] boolValue] == NO) {

        [self.localTravelPreferencesBoolArray replaceObjectAtIndex:indexPath.row  withObject:@YES];
        if (![self.localTravelPreferencesArray containsObject:self.travelPreferenceArrayForTableView[indexPath.row]]) {
            [self.localTravelPreferencesArray addObject:self.travelPreferenceArrayForTableView[indexPath.row]];
        }




    }else if ([self.localTravelPreferencesBoolArray[indexPath.row] boolValue] == YES) {

         [self.localTravelPreferencesBoolArray replaceObjectAtIndex:indexPath.row  withObject:@NO];
        if ([self.localTravelPreferencesArray containsObject:self.travelPreferenceArrayForTableView[indexPath.row]]) {
            [self.localTravelPreferencesArray removeObject:self.travelPreferenceArrayForTableView[indexPath.row]];
        }


        
    }
    }else {

        if ([self.localPersonalityBoolArray[indexPath.row] boolValue] == NO) {
            [self.localPersonalityBoolArray replaceObjectAtIndex:indexPath.row withObject:@YES];
            if (![self.localPersonalityArray containsObject:self.personalityArrayForTableView[indexPath.row]]) {
                [self.localPersonalityArray addObject:self.personalityArrayForTableView[indexPath.row]];
            }

        } else if([self.localPersonalityBoolArray[indexPath.row] boolValue] == YES){
            [self.localPersonalityBoolArray replaceObjectAtIndex:indexPath.row withObject:@NO];
            if ([self.localPersonalityArray containsObject:self.personalityArrayForTableView[indexPath.row]]) {
                [self.localPersonalityArray removeObject:self.personalityArrayForTableView[indexPath.row]];
            }


        }


    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];



}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{


}


//helper method to display error message
    -(void)displayErrorMessage:(NSString *)error{

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error - Please Try Again!" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

        [alertView show];
    }


@end
