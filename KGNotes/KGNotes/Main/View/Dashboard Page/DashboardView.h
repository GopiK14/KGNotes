//
//  DashboardView.h
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "KGView.h"
#import "DashboardViewController.h"

@interface DashboardView : KGView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong,setter=setController:) DashboardViewController *viewController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
-(void)hideInfoText;
@end
