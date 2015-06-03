//
//  SearchVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/30/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "SelectCategoryVC.h"
#import "SearchVC.h"

@interface SelectCategoryVC ()
@property NSString *selectedCategory;

@end

@implementation SelectCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self performInitialSetUp];



}
-(void)performInitialSetUp{

    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Select A Category";
    titleView.textColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:212/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];
}

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

//Selection of Category

- (IBAction)onCulturalButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Cultural";
    [self performSegueWithIdentifier:@"presentSearchVC" sender:sender];

}

- (IBAction)onFestivalButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Festival";
    [self performSegueWithIdentifier:@"presentSearchVC" sender:sender];
}

- (IBAction)onGastronomyButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Gastronomy";
    [self performSegueWithIdentifier:@"presentSearchVC" sender:sender];
}

- (IBAction)onNightOutButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Night Out";
    [self performSegueWithIdentifier:@"presentSearchVC" sender:sender];
}
- (IBAction)OnOutdoorsButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Outdoors";
    [self performSegueWithIdentifier:@"presentSearchVC" sender:sender];

}
- (IBAction)onFitnessButtonTapped:(UIButton *)sender {
    self.selectedCategory = @"Fitness";
    [self performSegueWithIdentifier:@"presentSearchVC" sender:sender];
}

//SEGUE
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([[segue identifier] isEqualToString:@"presentSearchVC"]){


        SearchVC *destVC = [segue destinationViewController];

        [destVC setSelectedCategory:self.selectedCategory];
        
    }

    


}


@end
