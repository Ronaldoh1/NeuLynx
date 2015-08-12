//
//  CustomMKAnnotation.m
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import "CustomMKAnnotation.h"

@implementation CustomMKAnnotation

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location andWithActivity:(Activity *)activity{

    self = [super init];
    if(self){
        _title = newTitle;
        _coordinate = location;
        _activity = activity;
    }
    return self;
}
-(MKAnnotationView *)annotationView{

    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"customAnnotation"];
    annotationView.enabled = YES;
    //allow the pin to show the callout.
    annotationView.canShowCallout = YES;
    UIButton *selectActivityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectActivityButton.frame = CGRectMake(0, 0, 70, 20);
    [selectActivityButton setTitle:@"Details" forState:UIControlStateNormal];
    [selectActivityButton setTitleColor:[UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1] forState:UIControlStateNormal];
    selectActivityButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [selectActivityButton.layer setBorderWidth:1];
    [selectActivityButton.layer setBorderColor:[UIColor colorWithRed:12.0/255.0 green:134/255.0 blue:243/255.0 alpha:1].CGColor];
    annotationView.rightCalloutAccessoryView = selectActivityButton;




    return annotationView;



}


//        pinAnnotation.image =resizedImage;
//
//
//        //allow the pin to show the callout.
//        pinAnnotation.canShowCallout = YES;
//        UIButton *selectActivityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        selectActivityButton.frame = CGRectMake(0, 0, 70, 20);
//        [selectActivityButton setTitle:@"Details" forState:UIControlStateNormal];
//        [selectActivityButton setTitleColor:[UIColor colorWithRed:34.0/255.0 green:85.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
//        selectActivityButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        [selectActivityButton.layer setBorderWidth:1];
//        [selectActivityButton.layer setBorderColor:[UIColor colorWithRed:34.0/255.0 green:85.0/255.0 blue:255.0/255.0 alpha:1].CGColor];
//        pinAnnotation.rightCalloutAccessoryView = selectActivityButton;
//



@end
