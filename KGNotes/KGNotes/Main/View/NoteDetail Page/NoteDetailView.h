//
//  NoteDetailView.h
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "KGView.h"
@class NoteDetailViewController;

@interface NoteDetailView : KGView<UITextViewDelegate>
@property (nonatomic,strong,setter=setController:) NoteDetailViewController *viewController;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

#pragma mark KeyBoard Notifaction Handler
- (void)keyboardWasShown:(NSNotification*)notification;
- (void)keyboardWillBeHidden:(NSNotification*)notification;
@end
