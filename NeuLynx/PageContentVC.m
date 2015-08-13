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


    self.label1.text = self.textForLabel1;
    self.label2.text = self.textForLabel2;
    self.label1.textColor = [UIColor blueColor];
    self.label2.textColor = [UIColor yellowColor];
    self.imageForScreen.image = [UIImage imageNamed:self.imageFileName];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end