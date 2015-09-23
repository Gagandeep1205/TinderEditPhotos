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
    
    [self performSelectorInBackground:@selector(saveFilesInDocDirectory) withObject:nil];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startPaning:)];
    [self.collectionView addGestureRecognizer:longPress];
    longPress.cancelsTouchesInView = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) viewWillDisappear:(BOOL)animated{

    for (int i = 0; i<_arrCollectionView.count; i++) {
        NSString *path = [_myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",i]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
        UIImage * img = [UIImage imageWithData:data];
        [self saveImageAtPath:path ImageData:UIImagePNGRepresentation(img)];
    }
}

- (void) saveFilesInDocDirectory{

    {
    
    NSError *error;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/tinderImages"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    }
    
    _paths = [[NSArray alloc] init];
    _paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _myDirectory = [[_paths objectAtIndex:0] stringByAppendingPathComponent:@"tinderImages"];

     NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_myDirectory error:NULL];
    
    _arrCollectionView = [[NSMutableArray alloc] initWithArray:directoryContent];
    NSLog(@"%@",_arrCollectionView);
    
//    NSError *error;
//    [[NSFileManager defaultManager]removeItemAtPath:_myDirectory error:&error];

    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
   [_collectionView reloadData];
}

#pragma mark - collection view delegates and data sources

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 6;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    cell.indexpath = indexPath;
    cell.delegate = self;
    cell.btnClose.layer.cornerRadius = cell.btnClose.frame.size.height/2;
    cell.btnClose.clipsToBounds = YES;
    
    if (indexPath.row >= _arrCollectionView.count) {
        
        cell.imgView.image = [UIImage imageNamed:@"placeholder"];

    }
    else{
    
        NSString *filePath = [_myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[_arrCollectionView objectAtIndex:indexPath.row]]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        cell.imgView.image = [UIImage imageWithData:data];

    }
    
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
         NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder"]);
        return data2;
    }
    return nil;
}


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *file = [NSData dataWithData:UIImagePNGRepresentation(image)];
    
    NSString *path;
    path = [_myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)_selectedCellIndex.row]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    [self saveImageAtPath:path ImageData:file];
    
    CollectionCell *cell = (CollectionCell*)[self.collectionView cellForItemAtIndexPath:_selectedCellIndex];
    cell.imgView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - cell custom delegates

- (void) closeButtonPressed:(NSIndexPath *)indexPath{
    
    _selectedCellIndex = indexPath;
    CollectionCell * cell = (CollectionCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    NSData *data1 = UIImagePNGRepresentation(cell.imgView.image);
    NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder"]);
    if (![data1 isEqual:data2]) {
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
        CollectionCell *cell = (CollectionCell*)[self.collectionView cellForItemAtIndexPath:_selectedCellIndex];
        CollectionCell *profileCell = (CollectionCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        if (buttonIndex == 0) {
            NSString *path;
            path = [_myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)_selectedCellIndex.row]];
            cell.imgView.image = [UIImage imageNamed:@"placeholder"];
            NSError *error;
            [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
        }
        
        if(buttonIndex == 1){
            
//            NSString *profilePath = [_myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[_arrCollectionView objectAtIndex:0]]];
//            NSData *profileTemp = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:profilePath]];
//            NSError *error;
//            [[NSFileManager defaultManager]removeItemAtPath:profilePath error:&error];
//            
//            
//            NSString *path = [_myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)_selectedCellIndex.row]];
//            NSData *temp = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
//            [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
//            
//            [self saveImageAtPath:path ImageData:UIImagePNGRepresentation(profileCell.imgView.image)];
//            [self saveImageAtPath:profilePath ImageData:UIImagePNGRepresentation(cell.imgView.image)];
            
//            NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_myDirectory error:NULL];
//            _arrCollectionView = [[NSMutableArray alloc] initWithArray:directoryContent];
//            NSLog(@"%@",_arrCollectionView);

            UIImage *imgTemp = profileCell.imgView.image;
            NSString *strTemp = [_arrCollectionView objectAtIndex:0];
            
            profileCell.imgView.image = cell.imgView.image;
            cell.imgView.image = imgTemp;
            
            [_arrCollectionView replaceObjectAtIndex:0 withObject:[_arrCollectionView objectAtIndex:_selectedCellIndex.row]];
            [_arrCollectionView replaceObjectAtIndex:_selectedCellIndex.row withObject:strTemp];
        }
    }
}


#pragma mark - button actions

- (IBAction)actionBtnDone:(id)sender {
    
    
    NSString *filePath = [_myDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[_arrCollectionView objectAtIndex:0]]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    UIImage *img = [UIImage imageWithData:data];
    
    [self.delegate newData:img];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - gesture recogniser methods

- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer {
    
    }

#pragma mark long press gesture recogniser 

- (void)startPaning : (UILongPressGestureRecognizer *)longPress {
    
    
    CGPoint locationPoint = [longPress locationInView:self.collectionView];
    _indexPathMovingCell = [self.collectionView indexPathForItemAtPoint:locationPoint];
    CollectionCell *cellBegin = (CollectionCell*)[self.collectionView cellForItemAtIndexPath:_indexPathMovingCell];
    
    NSData *data1 = UIImagePNGRepresentation(cellBegin.imgView.image);
    NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder"]);
    if (![data1 isEqual:data2]) {
        
        
        if (longPress.state == UIGestureRecognizerStateBegan) {
            
            UIGraphicsBeginImageContext(cellBegin.bounds.size);
            [cellBegin.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [cellBegin setHidden:YES];
            
            self.movingCell = [[UIImageView alloc] initWithImage:cellImage];
            [self popCell:0.1 :self.movingCell];
            [self.movingCell setCenter:locationPoint];
            [self.collectionView addSubview:self.movingCell];
            
        }
        
        if (longPress.state == UIGestureRecognizerStateChanged) {
            [self.movingCell setCenter:locationPoint];
            NSIndexPath *indexPathInBetween = [self.collectionView indexPathForItemAtPoint:locationPoint];
            
        }
        
        if (longPress.state == UIGestureRecognizerStateEnded) {
            [self.movingCell removeFromSuperview];
            _indexPathWhereCellStopped = [self.collectionView indexPathForItemAtPoint:locationPoint];
            CollectionCell *cellEnd = (CollectionCell*)[self.collectionView cellForItemAtIndexPath:_indexPathWhereCellStopped];
            
            UIImage *imgTemp = cellBegin.imgView.image;
            NSString *strTemp = [_arrCollectionView objectAtIndex:_indexPathMovingCell.row];
            
            cellBegin.imgView.image = cellEnd.imgView.image;
            cellEnd.imgView.image = imgTemp;
            
            [_arrCollectionView replaceObjectAtIndex:_indexPathMovingCell.row withObject:[_arrCollectionView objectAtIndex:_indexPathWhereCellStopped.row]];
            [_arrCollectionView replaceObjectAtIndex:_indexPathWhereCellStopped.row withObject:strTemp];
            
            [cellBegin setHidden:NO];
        }
    }
}

#pragma mark - animations

- (void) popCell:(float)secs : (UIImageView*)image{
    
    [UIView animateWithDuration:0.05 animations:^{
        image.transform = CGAffineTransformMakeScale(1.15, 1.15);
    }];
}




@end
