//
//  MapLocationView.m
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "MapLocationView.h"
#import "MapLocationViewController.h"
#import "Location+CoreDataClass.h"
#import "LocationSearchViewController.h"

@implementation MapLocationView
{
    CLLocationCoordinate2D searchCoordinate;
    MKPointAnnotation *commonAnnotation;
    NSNumber *currentLatitude;
    NSNumber *currentLongitude;
    MKPlacemark *currentPlacemark;
    NSString *tempSearchText;
    BOOL firstLoad;
}

-(void)setController:(MapLocationViewController *)viewController{
    _viewController = viewController;
    firstLoad = YES;
    self.mapView.delegate = self;
    self.searchDestinationText.delegate = self;

    if (self.viewController.note.location) {
        self.mapView.showsUserLocation = NO;
    }
    /** calls function to check map and location aceesss permission & set a user current location on map. **/
    [self updateuserlocation];
   
    
}

-(void)updateuserlocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if ([self.viewController checkLocationServiceEnable]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }else{
            if (self.viewController.note.location) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.viewController getLatitute], [self.viewController getLongitute]);
                [self.viewController changeRegionToCoordinate:coord withSize:400];
            }else{
                self.mapView.showsUserLocation = YES;
            }
        }
    }
    
}


#pragma mark Map - location manager delegates

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark MapView Delegates

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500);
    //    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    //
    //    // Add an annotation
    //    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //    point.coordinate = userLocation.coordinate;
    //    point.title =  userLocation.title;
    //    point.subtitle = userLocation.subtitle;
    //
    //    [self.mapView addAnnotation:point];
    //    NSLog(@"userLocation lat %f, lon %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"%f %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    
    [self getAddressForAnnotation:location];
    if(firstLoad){
        firstLoad = NO;
       // if ([self.viewController getLatitute]) {
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.viewController getLatitute], [self.viewController getLongitute]);
            NSLog(@"lat %f",[self.viewController getLatitute]);
            
            [self.viewController changeRegionToCoordinate:coord withSize:400];
        //}
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
   // annotationView.draggable = YES;
    
    return annotationView;
}

#pragma mark - Custom function location search
/**
 *  This function updates users current location
 *
 *  @param location CLocation object
 */
- (void)getAddressForAnnotation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            CLPlacemark *placemark = [placemarks lastObject];
            MKPlacemark *mapplacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude) addressDictionary:placemark.addressDictionary];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:mapplacemark];
            
            currentLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
            currentLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
            currentPlacemark = mapItem.placemark;
            
            
            [self setAnnotationToMapView];
            
        } else {
            //  NSLog(@"%@", error.debugDescription);
        }
    } ];
}

-(void)setAnnotationToMapView
{
    /*remove old annotations*/
    [self.mapView removeAnnotations:self.mapView.annotations];

    commonAnnotation = [[MKPointAnnotation alloc] init];
    searchCoordinate.latitude = [currentLatitude floatValue];
    searchCoordinate.longitude =  [currentLongitude floatValue];
    commonAnnotation.coordinate = searchCoordinate;
    commonAnnotation.title = currentPlacemark.title;
    [self.mapView addAnnotation:commonAnnotation];

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)     {
        CLLocationCoordinate2D newPosition = annotationView.annotation.coordinate;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newPosition.latitude longitude:newPosition.longitude];
        [self getAddressForAnnotation:location];
        commonAnnotation.title = currentPlacemark.title;
        [self.viewController c:newPosition.latitude andLongitude:newPosition.longitude];
    }
}

-(void)receivedSearchLocation:(NSNotification*)notification
{
    
    if ([notification.name isEqualToString:@"loadSearchLocation"]) {
        NSDictionary* userInfo = notification.userInfo;
        if (![[userInfo valueForKey:@"location"]  isEqual: @"NoSearch"]) {
            self.searchDestinationText.text = [userInfo valueForKey:@"location"];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[userInfo valueForKey:@"lat"] floatValue], [[userInfo valueForKey:@"lon"] floatValue]);
            [self changeRegionToCoordinate:coord withSize:500];
            MKMapItem *item = [userInfo valueForKey:@"mapItem"];
            [self getAddressForAnnotationFromMapItem:item];
        } else {
            self.searchDestinationText.text = tempSearchText;
        }
        [self.viewController updateLocationToNote:[[userInfo valueForKey:@"lon"] doubleValue] andLongitude:[[userInfo valueForKey:@"lon"] doubleValue]];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadSearchLocation" object:nil];
}


- (void)getAddressForAnnotationFromMapItem:(MKMapItem *)selectedMapItem
{
    NSString *str = [NSString stringWithFormat:@"%@",selectedMapItem.placemark.name];
    currentLatitude = [NSNumber numberWithDouble:selectedMapItem.placemark.coordinate.latitude];
    currentLongitude = [NSNumber numberWithDouble:selectedMapItem.placemark.coordinate.longitude];
    self.searchDestinationText.text = str;
    [self setAnnotationToMapView];
    [self.viewController updateLocationToNote:selectedMapItem.placemark.coordinate.latitude andLongitude:selectedMapItem.placemark.coordinate.longitude];

}

#pragma mark - map view custom methods
- (void)changeRegionToCoordinate:(CLLocationCoordinate2D)coordinate withSize:(NSUInteger)size
{
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(coordinate, size, size);
    [self.mapView setRegion:newRegion animated:YES];
}


- (void)openSearchScreen
{
    
    tempSearchText = self.searchDestinationText.text;
    LocationSearchViewController *location =  [[LocationSearchViewController alloc] initWithNibName:@"LocationSearchViewController" bundle:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedSearchLocation:) name:@"loadSearchLocation" object:nil];
    [self.viewController.navigationController presentViewController:location animated:YES completion:nil];
}


#pragma mark - Text field Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.searchDestinationText) {
        [self openSearchScreen];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.searchDestinationText) {
        return NO;
    }
    return YES;
}

@end
