//
//  MapLocationView.h
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "KGView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@class MapLocationViewController;

@interface MapLocationView : KGView<MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
@property (nonatomic,strong,setter=setController:) MapLocationViewController *viewController;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *searchDestinationText;

@property (strong, nonatomic) CLLocationManager *locationManager;@end
