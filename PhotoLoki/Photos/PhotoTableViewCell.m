//
//  PhotoTableViewCell.m
//  Photos
//
//  Created by Melissa Boring on 5/7/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.locationLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.locationLabel];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
