//
//  NoteDetailViewController.m
//  KGNotes
//
//  Created by Macpro on 12/23/16.
//  Copyright © 2016 Macpro. All rights reserved.
//

#import "NoteDetailViewController.h"

#import "AppConstants.h"
#import "KGTextAttachment.h"
#import "UIImage+resize.h"

#import "NoteDetailView.h"

#import "MapLocationViewController.h"
#import "SingleNote+CoreDataClass.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


@interface NoteDetailViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableAttributedString *attributedString;
    UIImage *selectedImage;
}

@property (strong, nonatomic) IBOutlet NoteDetailView *noteDetailView;
@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation NoteDetailViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.noteDetailView setController:self];
    if (self.note.noteDetail.detail) {
        self.noteDetailView.detailTextView.attributedText = (id)self.note.noteDetail.detail;
    }else{
        attributedString = [[NSMutableAttributedString alloc]initWithString:@""];
        
        self.noteDetailView.detailTextView.attributedText = attributedString;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self registerForKeyboardNotifications];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self unRegisterForKeyboardNotifications];
}

#pragma mark - Add Image to view

-(void)addImageToTextView:(UIImage*)image andPath:(NSString*)path andName:(NSString*)imageName{
    image = [UIImage imageByScalingProportionallyToSize:selectedImage TargetSize:CGSizeMake((self.view.frame.size.width - 20), 250)];
    attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.noteDetailView.detailTextView.attributedText];
    KGTextAttachment *textAttachment = [[KGTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.path = imageName;
    CGFloat oldWidth = textAttachment.image.size.width;
    
    CGFloat scaleFactor = oldWidth / self.noteDetailView.detailTextView.frame.size.width;
    
    textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString insertAttributedString:attrStringWithImage atIndex:self.cursorPosition.location];
    self.noteDetailView.detailTextView.attributedText = attributedString;
    [self saveNoteDetail:attributedString];
}

#pragma mark - Auto Save and Save methods

-(void)saveNoteDetail:(NSAttributedString*)noteDetail{
    SingleNote *singleNote =[NSEntityDescription insertNewObjectForEntityForName:@"SingleNote" inManagedObjectContext:[self managedObjectContext]];
    singleNote.title =self.note.noteTitle;
    singleNote.note = self.note;
    singleNote.detail = noteDetail;
    self.note.noteDetail = singleNote;
    
    
    NSError *err = nil;
    if (![[self managedObjectContext] save:&err]) {
        NSLog(@"Can't Save a Note! %@ %@", err, [err localizedDescription]);
    }
}

-(void)saveNoteWithLocationDetail:(NSAttributedString*)nodeDetail andLatitute:(NSNumber*)lat andLongitute:(NSNumber*)lon{
    SingleNote *singleNode =[NSEntityDescription insertNewObjectForEntityForName:@"SingleNote" inManagedObjectContext:[self managedObjectContext]];
    singleNode.title =self.note.noteTitle;
    singleNode.note = self.note;
    singleNode.detail = nodeDetail;
    self.note.noteDetail = singleNode;
    NSError *err = nil;
    if (![[self managedObjectContext] save:&err]) {
        NSLog(@"Can't Save a Note! %@ %@", err, [err localizedDescription]);
    }
}

#pragma mark - Camera Control

-(void)selectImageFromDevice
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Select from Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch(buttonIndex) {
        case 0: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self checkCameraAccessState];
            }else{
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                                      message:@"Your device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
            }
        }
            break;
        case 1: {
            [self checkPhotoLibraryAccessState];
        }
        default:
            break;
    }
}

-(void)openLibrary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    picker.allowsEditing = YES;
    self.imagePickerController = picker;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}
- (void)showcamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    picker.allowsEditing = YES;
    self.imagePickerController = picker;
    
    [self presentViewController:self.imagePickerController animated:YES completion:^{
    }];
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    // Picking Image from Camera/ Library
    dispatch_async(dispatch_get_main_queue(), ^{
        
        selectedImage = info[UIImagePickerControllerEditedImage];
        
        // Firstly get the picked image's file URL.
        NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        // Then get the file name.
        NSString *imageName = [imageFileURL lastPathComponent];
        NSLog(@"image name is %@", imageName);
        
        if (!selectedImage)
        {
            return;
        }
        [self createImagePathFromSelectedImage:selectedImage andImageName:imageName];
        
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:NULL];
    });
}

#pragma mark check Camera Access avail or not

-(void)checkCameraAccessState
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [self showcamera];
    } else if(authStatus == AVAuthorizationStatusDenied){
        // denied
        [self cameraDenied:@"camera"];
    } else if(authStatus == AVAuthorizationStatusRestricted){
        // restricted, normally won't happen
        [self cameraDenied:@"camera"];
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                [self showcamera];
            }
        }];
    }
}

#pragma mark check Photo Library Access avail or not
-(void)checkPhotoLibraryAccessState
{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusAuthorized) {
            // Access has been granted.
            [self openLibrary];
        }
        
        else if (status == PHAuthorizationStatusDenied) {
            // Access has been denied.
            [self cameraDenied:@"library"];
        }
        
        else if (status == PHAuthorizationStatusNotDetermined) {
            // Access has not been determined.
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    // Access has been granted.
                    [self openLibrary];
                }
            }];
        }
        
        else if (status == PHAuthorizationStatusRestricted) {
            // Restricted access - normally won't happen.
            [self cameraDenied:@"library"];
        }
    }else{
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        
        if(status == ALAuthorizationStatusNotDetermined) {
            // do your logic
            [self openLibrary];
        } else if(status == ALAuthorizationStatusRestricted){
            // denied
            [self cameraDenied:@"library"];
        } else if(status == ALAuthorizationStatusDenied){
            // restricted, normally won't happen
            [self cameraDenied:@"library"];
        } else if(status == ALAuthorizationStatusAuthorized){
            // not determined?!
            [self openLibrary];
        } else {
            // impossible, unknown authorization status
        }
    }
}

#pragma mark alert control if camera or library access denied

- (void)cameraDenied:(NSString*)isCamera
{
    if ([isCamera  isEqual: @"camera"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Request Authorization" message:@"It looks like your privacy settings are preventing us from accessing your camera, you can Turn on the Camera in the Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:  nil];
        [alertView show];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Request Authorization" message:@"It looks like your privacy settings are preventing us from accessing your Photos library,  you can Turn on the Photo library in the Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:  nil];
        [alertView show];
    }
}


#pragma mark - Process Edited / Added Image to DB

-(void)createImagePathFromSelectedImage:(UIImage*)image andImageName:(NSString*)imageName{
    imageName = [self getImageNameWithFolder:imageName];
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:localFilePath atomically:YES];
    NSLog(@"localFilePath.%@",localFilePath);
    
    [self addImageToTextView:[UIImage imageWithContentsOfFile:localFilePath] andPath:localFilePath andName:imageName];
}


-(void)deleteImageByPath:(NSString *)filename{
    NSLog(@"filename %@",filename);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
    NSLog(@"filePath %@",filePath);
    if ([fileManager fileExistsAtPath:filePath]){
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
    }
}
- (NSString*)getImageNameWithFolder:(NSString*)imagename{
    return [NSString stringWithFormat:@"%@_%d_%@",self.note.noteTitle,(arc4random() % 100),imagename];
}

#pragma mark - Open Map View
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"NoteLocationView"]) {
        MapLocationViewController *mapViewC = [segue destinationViewController];
        [mapViewC.note setNote:self.note];
    }
}
#pragma mark - Handle Keyboard Actions
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self.view
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.view
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self.view
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.view
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Default Touch handles

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //open edit mode on click od screen
    [self.noteDetailView.detailTextView becomeFirstResponder];
}

@end
