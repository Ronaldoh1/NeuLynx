//
//  PageContentViewController.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/14/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "PageContentVC.h"

@interface PageContentVC ()

@end

@implementation PageContentVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageForScreen.image = [UIImage imageNamed:self.imageFileName];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end