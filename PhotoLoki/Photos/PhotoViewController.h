//
//  PhotoTableViewController.h
//  Photos
//
//  Created by Melissa Boring on 4/30/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPopViewController.h"


@class PhotoViewController;
@class Photo;

@protocol PhotoViewControllerDelegate <NSObject>
- (void)photoViewControllerDidCancel:(PhotoViewController *)controller;
- (void)photoViewControllerDidSave:(Photo *)photo;
@end

@interface PhotoViewController : UIViewController <UITextFieldDelegate,UIViewControllerTransitioningDelegate,SearchViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UIImage *image;
@property(nonatomic,strong) Photo *photo;
@property(nonatomic,strong) NSString *mode;
@property (nonatomic, weak) id <PhotoViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;


@end
