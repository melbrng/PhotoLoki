//
//  MapViewController.m
//  Photos
//
//  Created by Melissa Boring on 5/22/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import "MapViewController.h"
#import "MapAnnotation.h"
#import "PhotoDetailViewController.h"

@interface MapViewController ()
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) NSMutableArray *annotations;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)backButton:(id)sender;

@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [self loadingLocations];
    
    [self.mapView addAnnotations:self.annotations];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MapView

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnedAnnotationView = nil;
    
    // in case it's the user location, we already have an annotation, so just return nil
    if (![annotation isKindOfClass:[MKUserLocation class]])
    {
        // handle our three custom annotations
        //
        if ([annotation isKindOfClass:[MapAnnotation class]]) 
        {
            returnedAnnotationView = [MapAnnotation createViewAnnotationForMapView:self.mapView annotation:annotation];
            
            // add a detail disclosure button to the callout which will open a new view controller page or a popover
            //
            // note: when the detail disclosure button is tapped, we respond to it via:
            //       calloutAccessoryControlTapped delegate method
            //
            // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
            //
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            ((MKPinAnnotationView *)returnedAnnotationView).rightCalloutAccessoryView = rightButton;
        }

    }
    
    return returnedAnnotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

    MapAnnotation *annotation = [view annotation];

    PhotoDetailViewController *detailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"PhotoDetailViewController"];
    detailViewController.mapPhoto = annotation.mapPhoto;
    [self presentViewController:detailViewController animated:YES completion:nil];

}



#pragma mark - Loading Locations and Photos

-(void)loadingLocations
{
    
    [self loadingPhotos];
    
    self.annotations = [[NSMutableArray alloc]init];
    
    for (Photo *mapPhoto in self.items)
    {
        
        MapAnnotation *annotation = [[MapAnnotation alloc]initWithPhoto:mapPhoto];
        [self.annotations addObject:annotation];
        
    }
    
}

- (void)loadingPhotos{
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


- (IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
