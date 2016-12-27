//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>

@interface LocationSearchViewController : UIViewController <UITableViewDataSource,UITableViewDataSource>

@property (nonatomic) NSString *searchText;
@property (nonatomic) MKCoordinateRegion region;
@property (nonatomic)CLLocationCoordinate2D searchCoordinate;
@property (weak, nonatomic) IBOutlet UIView *locationNotFoundView;


@property BOOL isRequestPickupScreen;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchbarTopConstraint;




@end
