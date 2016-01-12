//
//  Photo.h
//  Photos
//
//  Created by Melissa Boring on 5/13/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Photo : NSObject<NSCoding>

@property(nonatomic,copy) NSString *photoLocationDescription;
@property(nonatomic,strong)UIImage *photo;
@property (nonatomic,copy)NSString *photoDateTime;
@property (nonatomic,copy)CLLocation *photoLocation;

@end
