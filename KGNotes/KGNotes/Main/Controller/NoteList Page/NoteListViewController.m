//
//  NoteListViewController.m
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "NoteListViewController.h"
#import "NoteListView.h"
#import "NoteDetailViewController.h"
#import "FolderList+CoreDataClass.h"
#import "Note+CoreDataClass.h"

@interface NoteListViewController ()
@property (strong, nonatomic) IBOutlet NoteListView *noteListView;

@end

@implementation NoteListViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.noteListView setController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"NoteDetailSegue"])
    {
        NoteDetailViewController *nlView = [segue destinationViewController];
        [nlView setNote:[self.folder.notes.allObjects objectAtIndex:self.noteListView.tableView.indexPathForSelectedRow.row]];

    }
}

-(void)showPopUpToAddNewNote{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Note"
                                                    message:@"Enter a New Note Name"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add", nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UIAlertview Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Make sure the button they clicked wasn't Cancel
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSLog(@"Note name -%@", textField.text);
        [self saveNote:textField.text];
    }
}


#pragma mark - Save/Delete Note
-(void)saveNote:(NSString*)noteName{
    
    Note *singleNote =[NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[self managedObjectContext]];
    singleNote.noteTitle = noteName;
    singleNote.folder = self.folder;

    NSError *err = nil;
    if (![[self managedObjectContext] save:&err]) {
        NSLog(@"Can't Save a Note! %@ %@", err, [err localizedDescription]);
    }
    [self.folder addNotesObject:singleNote];
  
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:(self.folder.notes.count - 1 )inSection:0];
    [self.noteListView.tableView insertRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.noteListView.tableView reloadData];
    [self.noteListView hideInfoText];
}

-(void)deleteNote:(NSIndexPath*)indexPath{
    [[self managedObjectContext] deleteObject:[self.folder.notes.allObjects objectAtIndex:indexPath.row]];
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    
    // Remove device from table view
    [self.noteListView.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.noteListView hideInfoText];
}

#pragma mark  - get Folder Details

-(NSInteger)getNoteCount{
    return self.folder.notes.count;
}
-(NSString*)getNoteTitle:(NSInteger)row{
    Note *singleNode = [self.folder.notes.allObjects objectAtIndex:row];
    NSLog(@"titles - %@",singleNode.noteTitle);
    return singleNode.noteTitle;
}
@end
