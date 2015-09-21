//
//  EditInfo.h
//  TinderEditPhotos
//
//  Created by Gagandeep Kaur  on 19/09/15.
//  Copyright (c) 2015 Gagandeep Kaur . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCell.h"
#import "CustomLayout.h"

@protocol changeProfilePic <NSObject>

@required

- (void) newData : (UIImage *)image;

@end

@interface EditInfo : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (nonatomic, weak) id<changeProfilePic> delegate;
@property (weak, nonatomic) IBOutlet CustomLayout *customLayout;
@property UIImage *profileImage;
@property UIImageView *movingCell;
@property NSMutableArray *arrCollectionView;
@property NSIndexPath *selectedCellIndex;
@property NSIndexPath *indexPathMovingCell;
@property NSIndexPath *indexPathWhereCellStopped;

- (IBAction)actionBtnDone:(id)sender;

@end
