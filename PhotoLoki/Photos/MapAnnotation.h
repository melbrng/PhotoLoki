//
//  MapAnnotation.h
//  PhotoLoc
//
//  Created by Melissa Boring on 3/3/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Photo.h"


@interface MapAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) Photo *mapPhoto;
- (id)initWithPhoto:(Photo*)photo;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

@end
