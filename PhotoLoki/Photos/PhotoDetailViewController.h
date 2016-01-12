//
//  PhotoDetailViewController.h
//  PhotoLoc
//
//  Created by Melissa Boring on 2/22/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Photo.h"
#import "PhotoViewController.h"

@interface PhotoDetailViewController : UIViewController <MKMapViewDelegate,PhotoViewControllerDelegate>

@property (strong,nonatomic) Photo *mapPhoto;


@end
