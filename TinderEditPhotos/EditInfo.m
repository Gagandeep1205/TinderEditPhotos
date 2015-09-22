//
//  EditInfo.m
//  TinderEditPhotos
//
//  Created by Gagandeep Kaur  on 19/09/15.
//  Copyright (c) 2015 Gagandeep Kaur . All rights reserved.
//

#import "EditInfo.h"

@interface EditInfo ()<buttonPressDelegate>

@end

@implementation EditInfo

- (void)viewDidLoad {
    [super viewDidLoad];

        _arrCollectionView = [[NSMutableArray alloc] initWithObjects:@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg",nil];
    
    [self performSelectorInBackground:@selector(saveFilesInDocDirectory:) withObject:_arrCollectionView];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.collectionView addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) saveFilesInDocDirectory : (NSMutableArray *)arr{

    {
    
    NSError *error;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/myImages"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    }
    
    NSString *path;
    _paths = [[NSArray alloc] init];
    _paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _myDirectory = [[_paths objectAtIndex:0] stringByAppendingPathComponent:@"myImages"];
  

    for(NSInteger i = 0; i<arr.count; i++){
        
        path = [_myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)i]];
        UIImage *img = [UIImage imageNamed:[arr objectAtIndex:i]];
        NSData *data = [NSData dataWithData:UIImagePNGRepresentation(img)];

        [self saveImageAtPath:path ImageData:data];
    }
    [_collectionView reloadData];
}

#pragma mark - collection view delegates and data sources

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_myDirectory error:nil];

    NSLog(@"%@",array);
    return array.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    cell.indexpath = indexPath;
    cell.delegate = self;
    cell.btnClose.layer.cornerRadius = cell.btnClose.frame.size.height/2;
    cell.btnClose.clipsToBounds = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        NSString *path = [_myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        UIImage* image = [[UIImage alloc] initWithData:[self retrieveImageFromPath:path]];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell.tag == indexPath.row) {
                    cell.imgView.image = image;
                    NSLog(@"%@",image);
                    [cell setNeedsLayout];
                }
            });
        }
    });
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    CollectionCell * cell = (CollectionCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    _selectedCellIndex = indexPath;
    NSData *data1 = UIImagePNGRepresentation(cell.imgView.image);
    NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder"]);
    if ([data1 isEqual:data2]) {
        UIActionSheet *actionSheetAddImage = [[UIActionSheet alloc]
                                      initWithTitle:nil delegate:self
                                      cancelButtonTitle:@"cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Choose Image",@"Take Image", nil];
        actionSheetAddImage.tag = 0;
        [actionSheetAddImage showInView:self.view];
    }
}


#pragma mark - Document directory functions
                             
-(void)saveImageAtPath:(NSString *)path ImageData:(NSData *)data
{
    NSData *file = data;
    [[NSFileManager defaultManager] createFileAtPath:path
                                            contents:file
                                          attributes:nil];
    [_collectionView reloadData];
}
                             
-(NSData *)retrieveImageFromPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSData *file1 = [[NSData alloc] initWithContentsOfFile:path];
        if (file1)
        {
            return file1;
        }
    }
    else
    {
        NSLog(@"File does not exist");
    }
    return nil;
}


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *file;
    file = [NSData dataWithData:UIImagePNGRepresentation(image)];
    NSString *path;
    path = [[_paths objectAtIndex:0] stringByAppendingPathComponent:@"myImages"];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"123"]];

    [[NSFileManager defaultManager] createFileAtPath:path
                                            contents:file
                                          attributes:nil];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    [_arrCollectionView replaceObjectAtIndex:_selectedCellIndex.row withObject:[directoryContent objectAtIndex:directoryContent.count]];
    [_collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - cell custom delegates

- (void) closeButtonPressed:(NSIndexPath *)indexPath{
    
    _selectedCellIndex = indexPath;
    if (indexPath.row == 0) {
        UIActionSheet *actionSheetProfilePic = [[UIActionSheet alloc]
                                                initWithTitle:nil delegate:self
                                                cancelButtonTitle:@"cancel"
                                                destructiveButtonTitle:@"Delete"
                                                otherButtonTitles:nil];
        actionSheetProfilePic.tag = 1;
        [actionSheetProfilePic showInView:self.view];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil delegate:self
                                      cancelButtonTitle:@"cancel"
                                      destructiveButtonTitle:@"Delete"
                                      otherButtonTitles:@"Make Profile Pic", nil];
        actionSheet.tag = 2;
        [actionSheet showInView:self.view];
    }
}

#pragma mark - action sheet delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 0) {
        
        if (buttonIndex ==0) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
        
        else if (buttonIndex ==1){
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
    else{
        
        if (buttonIndex == 0) {
            
            [_arrCollectionView replaceObjectAtIndex:_selectedCellIndex.row withObject:@"placeholder"];
        }
        
        if(buttonIndex == 1){
            
            UIImage * temp = [_arrCollectionView objectAtIndex:0];
            [_arrCollectionView insertObject:[_arrCollectionView objectAtIndex:_selectedCellIndex.row] atIndex:0];
            [_arrCollectionView removeObjectAtIndex:1];
            [_arrCollectionView replaceObjectAtIndex:_selectedCellIndex.row withObject:temp];
        }
        [_collectionView reloadData];
    }
}


#pragma mark - button actions

- (IBAction)actionBtnDone:(id)sender {
    UIImage * img= [UIImage imageNamed:[_arrCollectionView objectAtIndex:0]];
    [self.delegate newData:img];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - gesture recogniser methods

- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer {
    
    CGPoint locationPoint = [panRecognizer locationInView:self.collectionView];
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        
        _indexPathMovingCell = [self.collectionView indexPathForItemAtPoint:locationPoint];
        CollectionCell *cell = (CollectionCell*)[self.collectionView cellForItemAtIndexPath:_indexPathMovingCell];
        
        UIGraphicsBeginImageContext(cell.bounds.size);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.movingCell = [[UIImageView alloc] initWithImage:cellImage];
        [self.movingCell setCenter:locationPoint];
        [self.collectionView addSubview:self.movingCell];
        
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.movingCell setCenter:locationPoint];
        
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.movingCell removeFromSuperview];
        CollectionCell *cell = (CollectionCell*)[self.collectionView cellForItemAtIndexPath:_indexPathMovingCell];
        NSData *data1 = UIImagePNGRepresentation(cell.imgView.image);
        NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder"]);
        if (![data1 isEqual:data2]) {
            
            _indexPathWhereCellStopped = [self.collectionView indexPathForItemAtPoint:locationPoint];
            
            UIImage * temp = [_arrCollectionView objectAtIndex:_indexPathWhereCellStopped.row];
            [_arrCollectionView replaceObjectAtIndex:_indexPathWhereCellStopped.row withObject:[_arrCollectionView objectAtIndex:_indexPathMovingCell.row]];
            [_arrCollectionView replaceObjectAtIndex:_indexPathMovingCell.row withObject:temp];
        }
    }
    [_collectionView reloadData];
}



@end
