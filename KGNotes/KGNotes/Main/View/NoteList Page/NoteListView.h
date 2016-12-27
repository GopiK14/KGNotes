//
//  NoteListView.h
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "KGView.h"
@class NoteListViewController;

@interface NoteListView : KGView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong,setter=setController:) NoteListViewController *viewController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
-(void)hideInfoText;
@end
