//
//  NoteDetailView.m
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "NoteDetailView.h"
#import "NoteDetailViewController.h"
#import "KGTextAttachment.h"
@implementation NoteDetailView{
    NSMutableAttributedString *attributedString;
}

-(void)setController:(NoteDetailViewController *)viewController{
    _viewController = viewController;
    self.detailTextView.delegate = self;
}

#pragma mark - TextView Delegates
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self performSelector:@selector(placeCursorAtEnd:) withObject:textView afterDelay:0.01];
}

- (void)placeCursorAtEnd:(UITextView *)textview
{
    NSUInteger length = textview.text.length;
    
    textview.selectedRange = NSMakeRange(length, 0);
}

-(void)textViewDidChange:(UITextView *)textView{
    [self.viewController saveNoteDetail:textView.attributedText];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    [self.detailTextView.attributedText enumerateAttribute:NSAttachmentAttributeName
                                                   inRange:NSMakeRange(0,  self.detailTextView.attributedText.length)
                                                   options:0
                                                usingBlock:^(id value, NSRange imageRange, BOOL *stop){
                                                    if (NSEqualRanges(range, imageRange) && [text isEqualToString:@""]){
                                                        //Wants to delete attached image
                                                        NSLog(@"Wants to delete attached image %lu",(unsigned long)imageRange.location); // check and delete image if found
                                                        
                                                        if ([value isKindOfClass:[KGTextAttachment class]])
                                                        {
                                                            KGTextAttachment *attachment = (KGTextAttachment *)value;
                                                            if ([attachment image]){
                                                                NSLog(@"attachment local Path %@",[attachment path]);
                                                                [self.viewController deleteImageByPath:[attachment path]];
                                                            }
                                                        }
                                                    }else{
                                                        //Wants to delete text
                                                        NSLog(@"Wants to delete text %lu",(unsigned long)range.location);
                                                    }
                                                }];
    return YES;
}



- (IBAction)openCamera:(id)sender {
    self.viewController.cursorPosition = [self.detailTextView selectedRange];
    [self endEditing:YES];
    
    [self.viewController selectImageFromDevice];
}

#pragma mark KeyBoard Notifaction Handler
- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.detailTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.detailTextView.scrollIndicatorInsets = self.detailTextView.contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.detailTextView.contentInset = UIEdgeInsetsZero;
    self.detailTextView.scrollIndicatorInsets = UIEdgeInsetsZero;
}
@end
