//
//  PhotoCollectionViewController.m
//  PhotoLoc
//
//  Created by Melissa Boring on 2/21/15.
//  Copyright (c) 2015 Melissa Boring. All rights reserved.
//


#import "PhotoViewController.h"
#import "Photo.h"
#import "PhotoTableViewCell.h"
#import "MapViewController.h"
#import "SettingsKeys.h"
#import "PhotoCollectionViewController.h"
#import "PhotoDetailViewController.h"
#import "Photo.h"

@interface PhotoCollectionViewController () <UIImagePickerControllerDelegate ,UIViewControllerTransitioningDelegate>

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIImage *editedImage;
@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;

- (IBAction)backVC:(id)sender;
- (IBAction)showMappedLocations:(id)sender;

@end

@implementation PhotoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static void * SavingImageOrVideoContext = &SavingImageOrVideoContext;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self loadingPhotos];

}


-(void)viewDidAppear:(BOOL)animated
{
    
    [self.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    Photo *photo = self.items[indexPath.row];
    
    
    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:100];
    photoImageView.image = photo.photo;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    
    return cell;
}

-(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray  *)itemPaths
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    
    for (NSIndexPath *itemPath  in itemPaths)
    {
        [indexSet addIndex:itemPath.row];
        
    }
    
    [self.items removeObjectsAtIndexes:indexSet]; // data source
    
}

#pragma mark - <UICollectionViewDelegate>


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//show popup menu upon selecting a cell
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

//set popup to only include CUT
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(cut:))
    {
        return YES;
    }
    return NO;
}

//upon selecting CUT delete items from the data source then the collection view
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    
    
    if (action == @selector(cut:))
    {
            [self.photoCollectionView performBatchUpdates:^{

                    NSArray* itemPaths = [[NSArray alloc]initWithObjects:indexPath, nil];
                
                    // Delete the items from the data source.
                    [self deleteItemsFromDataSourceAtIndexPaths:itemPaths];
        
                    // Now delete the items from the collection view.
                    [self.collectionView deleteItemsAtIndexPaths:itemPaths];
                
            } completion:nil];
    }
	
    [self savingPhotos];
    [self.collectionView reloadData];
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

#pragma mark  - UIImagePickerControllerDelegate

//image picker photo chosen that initiates photo view controller
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.editedImage = info[UIImagePickerControllerEditedImage];
    
    BOOL isAutoSavePhotoEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:AutoSavePhotoKey];
    
    if(isAutoSavePhotoEnabled){
        UIImageWriteToSavedPhotosAlbum(self.editedImage, nil, nil, nil);
    }

    [self dismissViewControllerAnimated:YES completion:^{
        
        [self performSegueWithIdentifier:@"AddPhoto" sender:nil];
        
    }];
    
}



-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSParameterAssert(contextInfo == SavingImageOrVideoContext);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPhotoDetail"])
        {
        
            PhotoDetailViewController *photoDetailViewController = segue.destinationViewController;
            NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            photoDetailViewController.mapPhoto = [self.items objectAtIndex:indexPath.row];

        }
    else if ([segue.identifier isEqualToString:@"AddPhoto"])
        {
        
            PhotoViewController *photoViewController = segue.destinationViewController;
            photoViewController.delegate = self;
            photoViewController.image = self.editedImage;
            photoViewController.mode =@"add";
        
        }

}


#pragma mark - Saving/Loading Photos

- (void)loadingPhotos
{
    {
        NSFileManager *defaultFileManager = [NSFileManager defaultManager];
        NSArray* possibleURLs = [defaultFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentsDirURL = [possibleURLs firstObject];
        
        NSURL *savePhotoURL = [documentsDirURL URLByAppendingPathComponent:@"Photos.bin"];
        if ([defaultFileManager fileExistsAtPath:[savePhotoURL path]])
        {
            NSArray *savedPhotoEntries = [NSKeyedUnarchiver unarchiveObjectWithFile:[savePhotoURL path]];
            self.items = [NSMutableArray arrayWithArray:savedPhotoEntries];
        }
        else
        {
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



- (IBAction)backVC:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)showMappedLocations:(id)sender
{
    [self performSegueWithIdentifier:@"ShowMap" sender:nil];
}
@end
