//
//  DashboardView.m
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "DashboardView.h"
#import "FolderListCell.h"

@implementation DashboardView

-(void)setController:(DashboardViewController *)viewController{
    _viewController = viewController;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = 44;
}
-(void)hideInfoText{
    if ([self.viewController getFolderCount] >0) {
        self.infoLabel.hidden = YES;
    }
}
- (IBAction)addNewFolder:(id)sender {
    [self.viewController showPopUpToAddNewFolder];
}

#pragma mark - Tableview Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.viewController getFolderCount];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *folderCell = @"FolderCell";
    FolderListCell *cell = [tableView dequeueReusableCellWithIdentifier:folderCell forIndexPath:indexPath];
    cell.folderNameLabel.text = [self.viewController getFolderTitle:indexPath.row];
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
        // Delete fodler from database
        [self.viewController deleteFolder:indexPath];

    }
}

@end
