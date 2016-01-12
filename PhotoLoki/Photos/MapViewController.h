//
//  MapViewController.h
//  Photos
//
//  Created by Melissa Boring on 5/22/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Photo.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak,nonatomic) Photo *mapPhoto;

@end
