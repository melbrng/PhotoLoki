//
//  SearchViewController.m
//  Photos
//
//  Created by Melissa Boring on 5/19/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import "SearchPopViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchPopViewController ()

@property(strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)MKLocalSearch *localSearch;
@property(nonatomic,strong)CLPlacemark *placemark;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)SearchLocation *searchLocation;
@property(nonatomic,strong)IBOutlet UITableView *searchTable;

@property MKMapItem *mapItem;

- (IBAction)backToCollection:(id)sender;

@end

@implementation SearchPopViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Locations";
    self.searchBar.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 1000.0;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

}

#pragma mark Search Bar delegates
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{

    [self.locationManager startUpdatingLocation];
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}



#pragma mark Location Manager 

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;
{
    [self.locationManager stopUpdatingLocation];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchBar.text;
    request.region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000.0, 1000.0);
    
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!response) {
            NSLog(@"%@",error);
            return;
        }

        self.items = response.mapItems;
        [self.searchTable reloadData];
    }];
    

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Failed to Get Your Location"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    MKMapItem *item = self.items[indexPath.row];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.mapItem = self.items[indexPath.row];
    self.searchBar.text = self.mapItem.name;
    
    self.searchLocation = [[SearchLocation alloc]init];
    self.searchLocation.locationDescription = self.mapItem.name;
    
    CLLocation *currentLocation = self.mapItem.placemark.location;

    double locationLatitude = (double)currentLocation.coordinate.latitude;
    self.searchLocation.locationLatitude = locationLatitude;
    double locationLongitude = (double)currentLocation.coordinate.longitude;
    self.searchLocation.locationLongitude = locationLongitude;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];

    
    NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];
    self.searchLocation.locationDateTime = formattedDateString;
    
    self.searchPhoto.photoDateTime =formattedDateString;
    self.searchPhoto.photoLocation = currentLocation;
    self.searchPhoto.photoLocationDescription= self.mapItem.name;

    
}

#pragma mark - Call delegate

- (IBAction)backToCollection:(id)sender
{
        [self.delegate searchViewControllerDidLocatePhoto:self.searchPhoto];
        [self dismissViewControllerAnimated:YES completion:nil];

}
@end
