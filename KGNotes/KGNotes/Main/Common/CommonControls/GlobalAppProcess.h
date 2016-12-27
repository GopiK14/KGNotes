//
//  GlobalAppProcess.h
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalAppProcess : NSObject
+ (GlobalAppProcess *)sharedInstance;

#pragma mark - Custom Alert view

+ (void)showCustomAlertWithTitle:(NSString *)alertTxt andTitle:(NSString *)title andCancelButton:(NSString *)cancelButton andOtherButton:(NSString *)otherButton;
@end
