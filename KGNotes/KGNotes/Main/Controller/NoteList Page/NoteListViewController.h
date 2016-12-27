//
//  NoteListViewController.h
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "KGViewController.h"
#import "FolderList+CoreDataClass.h"

@interface NoteListViewController : KGViewController
@property (nonatomic,strong) FolderList *folder;


#pragma mark - Save/Delete Note
-(void)saveNote:(NSString*)noteName;
-(void)deleteNote:(NSIndexPath*)indexPath;
-(void)showPopUpToAddNewNote;

#pragma mark  - get Folder Details

-(NSInteger)getNoteCount;
-(NSString*)getNoteTitle:(NSInteger)row;
@end
