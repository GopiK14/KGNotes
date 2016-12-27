//
//  MapLocationViewController.h
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "KGViewController.h"
#import "SingleNote+CoreDataClass.h"
#import <MapKit/MapKit.h>

@interface MapLocationViewController : KGViewController
@property (nonatomic,strong) SingleNote *note;

-(BOOL)checkLocationServiceEnable;
#pragma mark - Update Location details

-(void)updateLocationToNote:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;
#pragma mark - get Location details

-(double)getLongitute;
-(double)getLatitute;
#pragma mark - map view custom methods
- (void)changeRegionToCoordinate:(CLLocationCoordinate2D)coordinate withSize:(NSUInteger)size;
@end
