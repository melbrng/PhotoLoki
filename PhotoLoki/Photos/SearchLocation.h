//
//  SearchLocation.h
//  Photos
//
//  Created by Melissa Boring on 5/21/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchLocation : NSObject

@property (nonatomic,weak) NSString *locationDescription;
@property (nonatomic,assign) double locationLatitude;
@property (nonatomic,assign) double locationLongitude;
@property (nonatomic,weak) NSString *locationString;
@property (nonatomic,weak)NSString *locationDateTime;

@end
