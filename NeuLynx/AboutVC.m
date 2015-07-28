//
//  AboutVC.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/27/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "AboutVC.h"
#import "MRProgressOverlayView.h"
#import "MRProgress.h"

@interface AboutVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property UIWindow *window;
@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initialSetUp];
}

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initialSetUp{
    //setting image to Navigation Bar's title

    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:20];
    titleView.text = @"About NeuLynx";
    titleView.textColor = [UIColor colorWithRed:193/255.0 green:8/255.0 blue:24/255.0 alpha:1];
    [self.navigationItem setTitleView:titleView];

    //Load the NeuLynx Website
    //Get user's information and display current location and profile picture.

    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Loading..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [self loadNeuLynxWebPage:^{
        [self loadNeuLynx];

         [MRProgressOverlayView dismissOverlayForView: self.view animated:YES];

    } afterDelay:2];
}

-(void)loadNeuLynx{

    //create a string that will hold the url- this will be replaced with the neulyx.com
    NSString *urlString = @"http://signup.neulynx.com";

    //create an NSURl from the string above
    NSURL *url = [NSURL URLWithString:urlString];

    //create an NSURL request from the string above.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //use the request to load the webview and present it to the user.
    [self.webView loadRequest:request];

}

//**********************BLOCKS***********************************************//
-(void)loadNeuLynxWebPage:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime,dispatch_get_main_queue(), block);
}

@end
