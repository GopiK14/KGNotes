//
//  DashboardViewController.m
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardView.h"
#import "NoteListViewController.h"
#import "FolderList+CoreDataClass.h"

@interface DashboardViewController ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet DashboardView *dashBoardView;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    [self.dashBoardView setController:self];
    
    [self getFolderList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"NoteListSegue"])
    {
        NoteListViewController *nlView = [segue destinationViewController];
        [nlView setFolder:[self.folders objectAtIndex:self.dashBoardView.tableView.indexPathForSelectedRow.row]];
    }
}

#pragma mark - Folder List

-(void)getFolderList{
    // get All folder
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FolderList"];
    self.folders = [[[self managedObjectContext] executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.dashBoardView.tableView reloadData];
    [self.dashBoardView hideInfoText];
}

-(void)showPopUpToAddNewFolder{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Folder"
                                                    message:@"Enter a New Folder Name"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add", nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)addFolder:(NSString*)folderName{
    FolderList *singleFolder =[NSEntityDescription insertNewObjectForEntityForName:@"FolderList" inManagedObjectContext:[self managedObjectContext]];
    
    singleFolder.folderTitle = folderName;
    
    NSError *err = nil;
    if (![[self managedObjectContext] save:&err]) {
        NSLog(@"Can't Save Folder %@ %@", err, [err localizedDescription]);
    }
    [self.folders addObject:singleFolder];
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:(self.folders.count - 1 )inSection:0];
    [self.dashBoardView.tableView insertRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.dashBoardView hideInfoText];
}

-(void)deleteFolder:(NSIndexPath*)indexPath{
    
        // Delete object from datab
        [[self managedObjectContext] deleteObject:[self.folders objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove folder from table view
        [self.folders removeObjectAtIndex:indexPath.row];
        [self.dashBoardView.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.dashBoardView hideInfoText];
}
#pragma mark - UIAlertview Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Make sure the button they clicked wasn't Cancel
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        NSLog(@"%@", textField.text);
        [self addFolder:textField.text];
        
    }
}

#pragma mark  - get Folder Details

-(NSInteger)getFolderCount{
    return self.folders.count;
}
-(NSString*)getFolderTitle:(NSInteger)row{
    FolderList *folder = [self.folders objectAtIndex:row];

    return folder.folderTitle;
}
@end


