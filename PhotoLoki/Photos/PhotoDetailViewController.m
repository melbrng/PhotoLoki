//
//  PhotoDetailViewController.m
//  PhotoLoc
//
//  Created by Melissa Boring on 2/22/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import <MapKit/MapKit.h>
#import "PhotoViewController.h"

@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *photoDescriptionLabel;
@property (weak, nonatomic) IBOutlet MKMapView *photoMapView;
@property (weak, nonatomic) IBOutlet UILabel *photoDateTime;
@property (strong, nonatomic) NSMutableArray *items;

- (IBAction)imageButtonTapped:(id)sender;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadPhotoDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Photo Detail

-(void)reloadPhotoDetail
{
    
    [self.imageButton setBackgroundImage:self.mapPhoto.photo forState:UIControlStateNormal];
    
    self.photoDescriptionLabel.text = self.mapPhoto.photoLocationDescription;
    self.photoDateTime.text = self.mapPhoto.photoDateTime;
    double latitude = self.mapPhoto.photoLocation.coordinate.latitude;
    double longitude = self.mapPhoto.photoLocation.coordinate.longitude;
    
    CLLocationCoordinate2D coordinate = {.latitude =  latitude,.longitude = longitude};
    
    MKCoordinateRegion region;
    region.center.latitude = coordinate.latitude;
    region.center.longitude = coordinate.longitude;
    region.span.latitudeDelta = 0.001;
    region.span.longitudeDelta = 0.001;
    
    [self.photoMapView setRegion:region animated:YES];
    
    MKPlacemark *previousMarker = [self.photoMapView.annotations lastObject];
    [self.photoMapView removeAnnotation:previousMarker];
    
    MKPlacemark *marker = [[MKPlacemark alloc]initWithCoordinate:coordinate addressDictionary:nil];
    [self.photoMapView addAnnotation:marker];
    
    [self.photoMapView setRegion:region];
}

- (IBAction)imageButtonTapped:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if ([segue.identifier isEqualToString:@"EditPhoto"])
        {

            PhotoViewController *photoViewController = segue.destinationViewController;
            photoViewController.delegate = self;
            photoViewController.photo = self.mapPhoto;
            photoViewController.mode = @"edit";
            
        }
    
}

#pragma mark - PhotoViewControllerDelegate

- (void)photoViewControllerDidCancel:(PhotoViewController *)controller
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoViewControllerDidSave:(Photo *)photo
{
    [self reloadPhotoDetail];
    [self.items addObject:photo];
    [self savingPhotos];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Saving/Loading Photos

- (void)loadingPhotos
{
    {
        NSFileManager *defaultFileManager = [NSFileManager defaultManager];
        NSArray* possibleURLs = [defaultFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentsDirURL = [possibleURLs firstObject];
        
        NSURL *savePhotoURL = [documentsDirURL URLByAppendingPathComponent:@"Photos.bin"];
        if ([defaultFileManager fileExistsAtPath:[savePhotoURL path]]) {
            NSArray *savedPhotoEntries = [NSKeyedUnarchiver unarchiveObjectWithFile:[savePhotoURL path]];
            self.items = [NSMutableArray arrayWithArray:savedPhotoEntries];
        }
        else {
            self.items = [NSMutableArray array];
        }
    }
}

- (void)savingPhotos;
{
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    NSArray* possibleURLs = [defaultFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirURL = [possibleURLs firstObject];
    
    NSURL *savePhotoURL = [documentsDirURL URLByAppendingPathComponent:@"Photos.bin"];
    
    [NSKeyedArchiver archiveRootObject:self.items toFile:[savePhotoURL path]];
}

@end
