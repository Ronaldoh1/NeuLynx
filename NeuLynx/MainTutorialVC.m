//
//  MainTutorialViewController.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/14/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "MainTutorialVC.h"
#import "PageContentVC.h"

@interface MainTutorialVC () <UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (nonatomic,strong) NSArray *arrayImages;

@end

@implementation MainTutorialVC

@synthesize PageViewController;

- (void)viewDidLoad {
    [super viewDidLoad];

    //INITIAL SET UP
    [self initialSetUp];

}
-(void)initialSetUp{

    //setup color tint
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Welcome to NeuLynx!";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Set up arrays



    self.arrayImages = @[@"intro1.jpg", @"intro2.jpg", @"intro3.jpg", @"intro4.jpg"];

    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.PageViewController.dataSource = self;

    PageContentVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    // Change the size of page view controller
    self.PageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0);

    [self addChildViewController:PageViewController];
    [self.view addSubview:PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];

}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mapTabVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mapTabVC animated:true completion:nil];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{

    NSUInteger index = ((PageContentVC*) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound)){
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{

    NSUInteger index = ((PageContentVC*) viewController).pageIndex;
    if (index == NSNotFound){

        return nil;
    }
    index++;
    if (index == [self.arrayImages count]){
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (PageContentVC *)viewControllerAtIndex:(NSUInteger)index{

    if (([self.arrayImages count] == 0) || (index >= [self.arrayImages count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    PageContentVC *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];

    pageContentViewController.imageFileName = self.arrayImages[index];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [self.arrayImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}
@end
