//
//  LocationSearchCell.h


#import <UIKit/UIKit.h>

@interface LocationSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationLogo;
@property (weak, nonatomic) IBOutlet UILabel *locationDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationBottomLabel;


@end
