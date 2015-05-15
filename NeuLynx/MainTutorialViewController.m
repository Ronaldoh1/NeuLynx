//
//  MainTutorialViewController.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/14/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "MainTutorialViewController.h"
#import "PageContentViewController.h"

@interface MainTutorialViewController () <UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (nonatomic,strong) NSArray *arrayPageFirstLabel;
@property (nonatomic,strong) NSArray *arrayPageSecondLabel;
@property (nonatomic,strong) NSArray *arrayImages;

@end

@implementation MainTutorialViewController

@synthesize PageViewController,arrayPageFirstLabel;

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
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"Welcome to NeuLynx!";
    titleView.textColor = [UIColor colorWithRed:0/255.0  green:134/255.0 blue:179/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];


    self.arrayPageFirstLabel = @[@"Text 1",@"Text 2",@"Text 3", @"Text 4", @"Text 5"];

    self.arrayPageSecondLabel = @[@"another text 1", @"Another text 2",@"Another text 3", @"Another text 4", @"Another text 5"];

    self.arrayImages = @[@"Logo", @"Logo", @"Logo", @"Logo", @"Logo"];

    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.PageViewController.dataSource = self;

    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
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


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    if (index == [self.arrayPageFirstLabel count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.arrayPageFirstLabel count] == 0) || (index >= [self.arrayPageFirstLabel count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];

    pageContentViewController.textForLabel1 = self.arrayPageFirstLabel[index];
    pageContentViewController.textForLabel2 = self.arrayPageSecondLabel[index];
    pageContentViewController.imageFileName = self.arrayImages[index];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.arrayPageFirstLabel count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


@end
