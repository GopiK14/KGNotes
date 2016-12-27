//
//  UIImage+resize.m


#import "UIImage+resize.h"

#define ASPECT_RATIO(x) (x.height/x.width)

#define DEFAULT_PHOTO_MAX_SIZE 100

@implementation UIImage (UIImage_resize)

+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
	float imgAr = ASPECT_RATIO(image.size);
	float rectAr = ASPECT_RATIO(size);
	float scaleFactor = rectAr > imgAr ? (size.width / image.size.width) : (size.height / image.size.height);
	CGSize scaledSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
    float xpos = (size.width-scaledSize.width)/2;
    UIGraphicsBeginImageContext(size); 
    [image drawInRect:CGRectMake(xpos, 0, scaledSize.width, scaledSize.height )]; 
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    return scaledImage; 
}

+(UIImage *)ScaletoFill:(UIImage *)image toSize:(CGSize)size
{
	float imgAr = ASPECT_RATIO(image.size);
	float rectAr = ASPECT_RATIO(size);
    //tried fixing this by changing the if condition
	float scaleFactor = rectAr < imgAr ? (size.width / image.size.width) : (size.height / image.size.height);
    CGSize scaledSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
    float ypos = (size.height-scaledSize.height)/2;
    float xpos = (size.width-scaledSize.width)/2;
    UIGraphicsBeginImageContext(size); 
    [image drawInRect:CGRectMake(xpos,ypos, scaledSize.width, scaledSize.height )];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    return scaledImage; 
}

+(UIImage *)AlbumImageScaletoFill:(UIImage *)image toSize:(CGSize)size
{
	float imgAr = ASPECT_RATIO(image.size);
	float rectAr = ASPECT_RATIO(size);
    
    //tried fixing this by changing the if condition
	float scaleFactor = rectAr < imgAr ? (size.width / image.size.width) : (size.height / image.size.height);
    CGSize scaledSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
    
    float ypos = 0;
    float xpos = (size.width-scaledSize.width)/2;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(xpos,ypos, scaledSize.width, scaledSize.height )];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(UIImage *)ScaletoFillWithZeroOrigin:(UIImage *)image toSize:(CGSize)size
{
	float imgAr = ASPECT_RATIO(image.size);
	float rectAr = ASPECT_RATIO(size);
    
    //tried fixing this by changing the if condition
	float scaleFactor = rectAr < imgAr ? (size.width / image.size.width) : (size.height / image.size.height);
    CGSize scaledSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
    
    float ypos = 0;
    float xpos = 0;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(xpos,ypos, scaledSize.width, scaledSize.height )];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(UIImage*)ScaletoSpecificWidth: (UIImage*)sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(float)ScaletoSpecificWidth:(float)actualWidth ActualHeight:(float)actualHeight scaledToWidth:(float)i_width
{
    float scaleFactor = i_width / actualWidth;
    float newHeight = actualHeight * scaleFactor;
    
    return newHeight;
}

+(float)ScaletoSpecificHeight:(float)actualWidth ActualHeight:(float)actualHeight scaledToHeight:(float)i_height
{
    float scaleFactor = i_height / actualHeight;
    float newWidth = actualWidth * scaleFactor;
    
    return newWidth;
}

+(UIImage *)imageByScalingProportionallyToSize:(UIImage*)sourceImage TargetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage ;
}


+ (UIImage *)scaleImageProportionally:(UIImage *)image
{
    if (MAX(image.size.height, image.size.width) <= DEFAULT_PHOTO_MAX_SIZE) {
        return image;
    }
    else {
        CGFloat targetWidth = 0;
        CGFloat targetHeight = 0;
        if (image.size.height > image.size.width) {
            CGFloat ratio = image.size.height / image.size.width;
            targetHeight = DEFAULT_PHOTO_MAX_SIZE;
            targetWidth = roundf(DEFAULT_PHOTO_MAX_SIZE/ ratio);
        }
        else {
            CGFloat ratio = image.size.width / image.size.height;
            targetWidth = DEFAULT_PHOTO_MAX_SIZE;
            targetHeight = roundf(DEFAULT_PHOTO_MAX_SIZE/ ratio);
        }
        
        CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
        UIImage *sourceImage = image;
        UIImage *newImage = nil;
        CGSize imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        targetWidth = targetSize.width;
        targetHeight = targetSize.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;
        CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
        if (!CGSizeEqualToSize(imageSize, targetSize)) {
            
            CGFloat widthFactor = targetWidth / width;
            CGFloat heightFactor = targetHeight / height;
            
            if (widthFactor < heightFactor)
                scaleFactor = widthFactor;
            else
                scaleFactor = heightFactor;
            
            scaledWidth = roundf(width * scaleFactor);
            scaledHeight = roundf(height * scaleFactor);
            
            // center the image
            if (widthFactor < heightFactor) {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            } else if (widthFactor > heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
        
        UIGraphicsBeginImageContext(targetSize);
        
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [sourceImage drawInRect:thumbnailRect];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (newImage == nil) NSLog(@"could not scale image");
        
        return newImage;
    }
}

+ (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)newSize
                     inRect:(CGRect)rect
{
    //Determine whether the screen is retina
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
    }
    else
    {
        UIGraphicsBeginImageContext(newSize);
    }
    
    //Draw image in provided rect
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //Pop this context
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image
          scaledToFitToSize:(CGSize)newSize
{
    //Only scale images down
    if (image.size.width < newSize.width && image.size.height < newSize.height) {
        return [image copy];
    }
    
    //Determine the scale factors
    CGFloat widthScale = newSize.width/image.size.width;
    CGFloat heightScale = newSize.height/image.size.height;
    
    CGFloat scaleFactor;
    
    //The smaller scale factor will scale more (0 < scaleFactor < 1) leaving the other dimension inside the newSize rect
    widthScale < heightScale ? (scaleFactor = widthScale) : (scaleFactor = heightScale);
    CGSize scaledSize = CGSizeMake(image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    //Scale the image
    return [UIImage imageWithImage:image scaledToSize:scaledSize inRect:CGRectMake(0.0, 0.0, scaledSize.width, scaledSize.height)];
}

+ (UIImage *)imageWithImage:(UIImage *)image
         scaledToFillToSize:(CGSize)newSize
{
    //Only scale images down
    if (image.size.width < newSize.width && image.size.height < newSize.height) {
        return [image copy];
    }
    
    //Determine the scale factors
    CGFloat widthScale = newSize.width/image.size.width;
    CGFloat heightScale = newSize.height/image.size.height;
    
    CGFloat scaleFactor;
    
    //The larger scale factor will scale less (0 < scaleFactor < 1) leaving the other dimension hanging outside the newSize rect
    widthScale > heightScale ? (scaleFactor = widthScale) : (scaleFactor = heightScale);
    CGSize scaledSize = CGSizeMake(image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    //Create origin point so that the center of the image falls into the drawing context rect (the origin will have negative component).
    CGPoint imageDrawOrigin = CGPointMake(0, 0);
    widthScale > heightScale ?  (imageDrawOrigin.y = (newSize.height - scaledSize.height) * 0.5) :
    (imageDrawOrigin.x = (newSize.width - scaledSize.width) * 0.5);
    
    //Create rect where the image will draw
    CGRect imageDrawRect = CGRectMake(imageDrawOrigin.x, imageDrawOrigin.y, scaledSize.width, scaledSize.height);
    
    //The imageDrawRect is larger than the newSize rect, where the imageDraw origin is located defines what part of
    //the image will fall into the newSize rect.
    return [UIImage imageWithImage:image scaledToSize:newSize inRect:imageDrawRect];
}

@end
