//
//  MainTableViewController.m
//  Photos
//
//  Created by Melissa Boring on 4/30/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoViewController.h"
#import "Photo.h"
#import "PhotoTableViewCell.h"
#import "MapViewController.h"
#import "SettingsKeys.h"

static NSString *CellTableIdentifier = @"CellTableIdentifier";

@interface MainViewController () <UIImagePickerControllerDelegate ,UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) NSMutableArray *items;
@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation MainViewController

-(void)viewDidAppear:(BOOL)animated{
 
    [self.tableView reloadData];

}

- (void)viewDidLoad
{
    
     
    [super viewDidLoad];
    
    if (!self.items){
        
        self.items = [[NSMutableArray alloc] init];
        
    }
    
    [self loadingPhotos];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
        numberOfRowsInSection:(NSInteger)section
{
   
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      

    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellTableIdentifier];
    if (cell == nil) {
        cell = [[PhotoTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    
    Photo *photo = self.items[indexPath.row];
    
    cell.locationLabel.text = photo.photoLocationDescription;
    [cell.photoImageView setImage:photo.photo];
   
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [self.items removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
    [self savingPhotos];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
     
    NSString *stringToMove = [self.items objectAtIndex:sourceIndexPath.row];
    [self.items removeObjectAtIndex:sourceIndexPath.row];
    [self.items insertObject:stringToMove atIndex:destinationIndexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowMap" sender:cell];

    
}

//Eliminated error message:
//      Snapshotting a view that has not been rendered results in an empty snapshot.
//      Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.

-(BOOL)shouldAutorotate{
    return YES;
}

#pragma mark - UIImagePickerController


- (IBAction)buttonTapped:(UIBarButtonItem*)sender
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Photo Library"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            
                                                            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                            picker.delegate = (id)self;
                                                            picker.allowsEditing = YES;
                                                            self.imagePickerController = picker;
                                                            [self presentViewController:self.imagePickerController animated:YES completion:nil];
                                                            
                                                        }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                             BOOL isCameraAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
                                                             
                                                             //checks to see if camera is available
                                                             picker.sourceType = (isCameraAvailable) ? UIImagePickerControllerSourceTypeCamera :
                                                             UIImagePickerControllerSourceTypePhotoLibrary;
                                                             picker.delegate = (id)self;
                                                             picker.allowsEditing = YES;
                                                             self.imagePickerController = picker;
                                                             [self presentViewController:self.imagePickerController animated:YES completion:nil];
                                                             
                                                         }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:photoAction];
    [alert addAction:cameraAction];
    [alert addAction:cancelAction];
    
    [alert.view setNeedsLayout];
    [self presentViewController:alert animated:YES completion:nil];
}

//- (IBAction)buttonTapped:(UIBarButtonItem*)sender {
//    
//   
//    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:nil
//                                  delegate:(id)self
//                                  cancelButtonTitle:@"Cancel"
//                                  destructiveButtonTitle:nil
//                                  otherButtonTitles:@"Photo Library",@"Camera", nil];
//    [actionSheet showInView:self.view];
//    
//
//}
//
//-(void)actionSheet:(UIActionSheet *)actionSheet
//clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    NSString *msg = nil;
//    
//    switch (buttonIndex) {
//        case 0:
//        {
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            
//            picker.delegate = (id)self;
//            picker.allowsEditing = YES;
//            
//            self.imagePickerController = picker;
//            
//            [self presentViewController:self.imagePickerController animated:YES completion:nil];
//        }
//            break;
//            
//        case 1:
//        {
//            
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            
//                BOOL isCameraAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
//            
//                //checks to see if camera is available
//                picker.sourceType = (isCameraAvailable) ? UIImagePickerControllerSourceTypeCamera :
//                UIImagePickerControllerSourceTypePhotoLibrary;
//            
//                picker.delegate = (id)self;
//                picker.allowsEditing = YES;
//            
//                self.imagePickerController = picker;
//            
//                [self presentViewController:self.imagePickerController animated:YES completion:nil];
//        }
//            break;
//            
//        case 2:
//        {
//            msg = @"Breathe easssy";
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"Cancelling Request"
//                                  message:msg
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles: nil];
//            [alert show];
//        }
//            break;
//        default:
//            break;
//    }
//
//}

#pragma mark - PhotoViewControllerDelegate

- (void)photoViewControllerDidCancel:(PhotoViewController *)controller
{
     
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoViewControllerDidSave:(Photo *)photo
{
    [self.items addObject:photo];
    [self savingPhotos];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowMap"]) {
        MapViewController *mapViewController = segue.destinationViewController;
    
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Photo *photo = self.items[indexPath.row];
        mapViewController.mapPhoto = photo;
    }

}


#pragma mark  - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
        UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
        BOOL isAutoSavePhotoEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:AutoSavePhotoKey];
        if(isAutoSavePhotoEnabled){
            UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil);
        }
    
            [self dismissViewControllerAnimated:YES completion:^{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainTable" bundle:nil];
            
            PhotoViewController *photoViewController = (PhotoViewController *)
                [storyboard instantiateViewControllerWithIdentifier:@"AddPhoto"];
            
            photoViewController.delegate = self;
            photoViewController.image = editedImage;
            
            UINavigationController *addPhotoNavController = [[UINavigationController alloc] initWithRootViewController:photoViewController];
            addPhotoNavController.transitioningDelegate = self;
            [self presentViewController:addPhotoNavController animated:YES completion:nil];
        }];

    }


static void * SavingImageOrVideoContext = &SavingImageOrVideoContext;

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSParameterAssert(contextInfo == SavingImageOrVideoContext);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Saving/Loading Photos

- (void)loadingPhotos{
    {
        NSFileManager *defaultFileManager = [NSFileManager defaultManager];
        NSArray* possibleURLs = [defaultFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentsDirURL = [possibleURLs firstObject];
        
        NSURL *savePhotoURL = [documentsDirURL URLByAppendingPathComponent:@"Photos.bin"];
        if ([defaultFileManager fileExistsAtPath:[savePhotoURL path]]) {
            NSArray *savedPhotoEntries = [NSKeyedUnarchiver unarchiveObjectWithFile:[savePhotoURL path]];
            self.items = [NSMutableArray arrayWithArray:savedPhotoEntries];
        }
        else {
            self.items = [NSMutableArray array];
        }
    }
}


- (void)savingPhotos;
{
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    NSArray* possibleURLs = [defaultFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirURL = [possibleURLs firstObject];
    
    NSURL *savePhotoURL = [documentsDirURL URLByAppendingPathComponent:@"Photos.bin"];
    
    [NSKeyedArchiver archiveRootObject:self.items toFile:[savePhotoURL path]];
}
@end
