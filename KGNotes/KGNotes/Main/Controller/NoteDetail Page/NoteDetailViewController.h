//
//  NoteDetailViewController.h
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "KGViewController.h"
#import "Note+CoreDataClass.h"

@interface NoteDetailViewController : KGViewController

@property (nonatomic,strong) NSMutableArray *nodeImages;

@property (nonatomic,strong) Note *note;
@property (nonatomic,assign) NSRange cursorPosition;

#pragma mark - Auto Save and Save methods

-(void)saveNoteDetail:(NSAttributedString*)noteDetail;
-(void)saveNoteWithLocationDetail:(NSAttributedString*)noteDetail andLatitute:(NSNumber*)lat andLongitute:(NSNumber*)lon;
-(void)selectImageFromDevice;
-(void)deleteImageByPath:(NSString *)filename;
@end
