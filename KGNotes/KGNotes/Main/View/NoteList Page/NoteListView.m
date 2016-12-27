//
//  NoteListView.m
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "NoteListView.h"
#import "NoteListViewController.h"
#import "NoteListCell.h"

@implementation NoteListView

-(void)setController:(NoteListViewController *)viewController{
    _viewController = viewController;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self hideInfoText];
}

-(void)hideInfoText{
    if ([self.viewController getNoteCount] >0) {
        self.infoLabel.hidden = YES;
    }
}

#pragma mark - Tableview Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewController getNoteCount];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *noteListCell = @"NoteCell";
    NoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:noteListCell forIndexPath:indexPath];
    cell.noteLabel.text = [self.viewController getNoteTitle:indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete note from database
       [self.viewController deleteNote:indexPath];
    }
}

#pragma mark - Add a New Note
- (IBAction)addNewNoteBtnClicked:(id)sender {
    [self.viewController showPopUpToAddNewNote];
}



@end
