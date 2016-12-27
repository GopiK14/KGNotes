//
//  UIImage+resize.h


#import <UIKit/UIKit.h>

@interface UIImage (UIImage_resize)
+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)ScaletoFill:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)AlbumImageScaletoFill:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)ScaletoFillWithZeroOrigin:(UIImage *)image toSize:(CGSize)size;
+(UIImage*)ScaletoSpecificWidth: (UIImage*)sourceImage scaledToWidth:(float)i_width;
+(float)ScaletoSpecificWidth:(float)actualWidth ActualHeight:(float)actualHeight scaledToWidth:(float) i_width;
+(float)ScaletoSpecificHeight:(float)actualWidth ActualHeight:(float)actualHeight scaledToHeight:(float)i_height;

+(UIImage *)imageByScalingProportionallyToSize:(UIImage*)sourceImage TargetSize:(CGSize)targetSize;


+ (UIImage *)scaleImageProportionally:(UIImage *)image;

/*Add common item crap*/
+ (UIImage *)imageWithImage:(UIImage *)image
          scaledToFitToSize:(CGSize)newSize;
@end
