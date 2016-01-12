//
//  Photo.m
//  Photos
//
//  Created by Melissa Boring on 5/13/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(id)initWithCoder:(NSCoder *)decoder{
  
    
    self = [super init];
    if(!self) {
        return nil;
    }
    
    self.photoLocationDescription = [decoder decodeObjectForKey:@"photoLocationDescription"];
    self.photoDateTime = [decoder decodeObjectForKey:@"photoDateTime"];
    self.photoLocation = [decoder decodeObjectForKey:@"photoLocation"];
    
    
    NSData *data = [decoder decodeObjectForKey:@"photo"];
    self.photo = [UIImage imageWithData:data];
    
    return self;
}


-(void)encodeWithCoder:(NSCoder *)coder{
  
    
    [coder encodeObject:self.photoLocationDescription forKey:@"photoLocationDescription"];
    [coder encodeObject:self.photoDateTime forKey:@"photoDateTime"];
    [coder encodeObject:self.photoLocation forKey:@"photoLocation"];
    
    NSData *data = UIImagePNGRepresentation(self.photo);
    [coder encodeObject:data forKey:@"photo"];
}


@end
