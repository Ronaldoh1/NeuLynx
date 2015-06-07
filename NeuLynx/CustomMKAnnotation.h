//
//  CustomMKAnnotation.h
//  NeuLynx
//
//  Created by Ronald Hernandez on 6/6/15.
//  Copyright (c) 2015 NeuLynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Activity.h"

@interface CustomMKAnnotation : NSObject<MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) Activity *activity;


-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location andWithActivity:(Activity *)activity;
-(MKAnnotationView *)annotationView;

@end
