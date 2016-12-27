//
//  AppConstants.h
//

#ifndef KGNotes_AppConstants_h
#define KGNotes_AppConstants_h

#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define IS_IPHONE6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define IS_IPHONE6n ([[UIScreen mainScreen] bounds].size.height == 736)

#define APPDELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESSER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


/* App Permission */

#define MSG_LOCATION_PERMISSION   @{@"title":@"Request Authorization", @"content": @"KGNOTES needs access to your location. Please turn on Location Service in the Settings app."}
#define MSG_CAMERA_PERMISSION     @{@"title":@"Request Authorization", @"content": @"It looks like your privacy settings are preventing us from accessing your camera, you can Turn on the Camera in the Settings app."}
#define MSG_PHOTO_PERMISSION      @{@"title":@"Request Authorization", @"content": @"It looks like your privacy settings are preventing us from accessing your Photos library,  you can Turn on the Photo library in the Settings app."}
#endif
