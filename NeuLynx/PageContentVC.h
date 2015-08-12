//
//  PageContentViewController.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 5/14/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentVC : UIViewController


@property NSString *textForLabel1;
@property NSString *textForLabel2;
@property NSString *imageFileName;

@property  NSUInteger pageIndex;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIImageView *imageForScreen;

@end
