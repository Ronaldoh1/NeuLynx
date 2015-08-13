//
//  SelectTimeVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 7/3/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SelectTimeTVC.h"

@interface SelectTimeTVC ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSString *tempString1;
@property NSString *tempString2;

@end

@implementation SelectTimeTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Select Time For Activity";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma marks - UItableView Delegate Methods.
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return indexPath;
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 && indexPath.row == 0) {

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyyy"];

        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"hh:mm a"];


        NSString *theDate = [dateFormat stringFromDate:self.datePicker.date];
        NSString *theTime = [timeFormat stringFromDate:self.datePicker.date];


        self.startTimeLabel.text = [NSString stringWithFormat:@"%@ @ %@",theDate, theTime];
        self.tempString1 = [NSString stringWithFormat:@"%@ @ %@",theDate, theTime];

        self.activity.startTimeAndDate = self.datePicker.date;

        self.startDateAndTime = self.datePicker.date;


    }else if(indexPath.section == 0 && indexPath.row == 1){

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyyy"];

        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"hh:mm a"];


        NSString *theDate = [dateFormat stringFromDate:self.datePicker.date];
        NSString *theTime = [timeFormat stringFromDate:self.datePicker.date];


        self.endTimeLabel.text = [NSString stringWithFormat:@"%@ @ %@",theDate, theTime];
        self.activity.endTimeAndDate = self.datePicker.date;
        self.endDateAndTime = self.datePicker.date;
        
    }
}



@end
