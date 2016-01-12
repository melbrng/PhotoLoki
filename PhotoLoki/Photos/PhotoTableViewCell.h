//
//  PhotoTableViewCell.h
//  Photos
//
//  Created by Melissa Boring on 5/7/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *locationLabel;
@property (nonatomic,strong) IBOutlet UIImageView *photoImageView;

@end
