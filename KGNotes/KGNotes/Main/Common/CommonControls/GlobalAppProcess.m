//
//  GlobalAppProcess.m
//  KGNotes
//
//  Created by Macpro on 12/27/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "GlobalAppProcess.h"

@implementation GlobalAppProcess

#pragma mark - Shared instance Init method

+ (GlobalAppProcess *)sharedInstance
{
    static dispatch_once_t onceToken;
    static GlobalAppProcess *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalAppProcess alloc] init];
    });
    return instance;
}
#pragma mark - Custom Alert view

+ (void)showCustomAlertWithTitle:(NSString *)alertTxt andTitle:(NSString *)title andCancelButton:(NSString *)cancelButton andOtherButton:(NSString *)otherButton{

}

@end
