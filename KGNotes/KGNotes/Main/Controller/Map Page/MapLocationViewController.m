//
//  MapLocationViewController.m
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "MapLocationViewController.h"
#import "Location+CoreDataClass.h"
#import "MapLocationView.h"

@interface MapLocationViewController ()
@property (strong, nonatomic) IBOutlet MapLocationView *mapLocationView;

@end

@implementation MapLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"note %f",self.note.location.latitude);
    [self.mapLocationView setController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - map view custom methods
- (void)changeRegionToCoordinate:(CLLocationCoordinate2D)coordinate withSize:(NSUInteger)size
{
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(coordinate, size, size);
    [self.mapLocationView.mapView setRegion:newRegion animated:YES];
}

-(BOOL)checkLocationServiceEnable
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        
    
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Request Authorization" message:@"KGNotes needs access to your location. Please turn on Location Service in the Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:  nil];
        [alertView show];
        
        return NO;
    }else {
        return YES;
    }
    
}

#pragma mark - Update Location details

-(void)updateLocationToNote:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude{
    Location *noteLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:[self managedObjectContext]];
    noteLocation.latitude = latitude;
    noteLocation.longitude = longitude;
    self.note.location = noteLocation;
    noteLocation.note = self.note;
}

#pragma mark - get Location details

-(double)getLongitute{
    return self.note.location.longitude;
}
-(double)getLatitute{
    return self.note.location.latitude;
}
@end
