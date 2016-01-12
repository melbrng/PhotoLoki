//
//  MapAnnotation.m
//  PhotoLoc
//
//  Created by Melissa Boring on 3/3/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation
@synthesize mapPhoto;

- (id)initWithPhoto:(Photo *)photo {
    self = [super init];
    if (self) {
        mapPhoto = photo;
    }
    return self;
}


- (CLLocationCoordinate2D)coordinate
{
    return mapPhoto.photoLocation.coordinate;
}

- (NSString *)title
{
    return mapPhoto.photoLocationDescription;
}

- (NSString *)subtitle
{
    return mapPhoto.photoDateTime;
}

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation
{
    // try to dequeue an existing pin view first
    MKAnnotationView *returnedAnnotationView =
    [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([MapAnnotation class])];
    if (returnedAnnotationView == nil)
    {
        returnedAnnotationView =
        [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                        reuseIdentifier:NSStringFromClass([MapAnnotation class])];
        
        ((MKPinAnnotationView *)returnedAnnotationView).pinTintColor = [UIColor greenColor];;
        ((MKPinAnnotationView *)returnedAnnotationView).animatesDrop = YES;
        ((MKPinAnnotationView *)returnedAnnotationView).canShowCallout = YES;
    }
    
    return returnedAnnotationView;
}

@end
