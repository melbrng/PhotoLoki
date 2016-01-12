//
//  PhotoTableViewController.m
//  Photos
//
//  Created by Melissa Boring on 4/30/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import "PhotoViewController.h"
#import "Photo.h"
#import "SearchPopViewController.h"

@interface PhotoViewController () 

@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *sunnyBtn;
@property (weak, nonatomic) IBOutlet UITextField *dateAndTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *locate;
- (IBAction)saveButtonTapped:(id)sender;

@end

@implementation PhotoViewController


@synthesize image;
@synthesize photo;


- (void)viewDidLoad
{
 
    [super viewDidLoad];
    

    //check to see if you are in edit or add mode
    if([self.mode isEqualToString:@"add"]){
        self.photo = [[Photo alloc]init];
        self.photo.photo = self.image;
        [self loadPhoto:self.photo];
        
    }else if([self.mode isEqualToString:@"edit"]){
        [self loadPhoto:self.photo];
    }
  
}

#pragma mark - Cancel/Save


- (IBAction)cancel:(id)sender
{
    
    [self.delegate photoViewControllerDidCancel:self];
}


- (IBAction)saveButtonTapped:(id)sender {
    
    [self.delegate photoViewControllerDidSave:self.photo];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    if ([segue.identifier isEqualToString:@"DoSearch"])
    {
    
        SearchPopViewController *searchViewController = [segue destinationViewController];
        searchViewController.searchPhoto = self.photo;
        searchViewController.delegate = self;
        
    }
}

#pragma mark - MBSearchViewControllerDelegate

-(void)loadPhoto:(Photo *)loadedPhoto
{
    self.imageView.image = loadedPhoto.photo;
    self.photo = loadedPhoto;
    self.photo.photo = loadedPhoto.photo;
    self.photo.photoLocationDescription = loadedPhoto.photoLocationDescription;
    self.dateAndTimeTextField.text = loadedPhoto.photoDateTime;
    self.locationTextField.text  = loadedPhoto.photoLocationDescription;
}

-(void)searchViewControllerDidLocatePhoto:(Photo *)locationPhoto
{

    [self loadPhoto:locationPhoto];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
