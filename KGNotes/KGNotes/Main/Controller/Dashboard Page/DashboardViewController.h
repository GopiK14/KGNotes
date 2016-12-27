//
//  DashboardViewController.h
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "KGViewController.h"

@interface DashboardViewController : KGViewController
@property (nonatomic,strong) NSMutableArray *folders;
-(void)deleteFolder:(NSIndexPath*)indexPath;
-(void)showPopUpToAddNewFolder;

#pragma mark  - get Folder Details

-(NSInteger)getFolderCount;
-(NSString*)getFolderTitle:(NSInteger)row;
@end
