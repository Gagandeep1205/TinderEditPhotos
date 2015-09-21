//
//  CollectionCell.h
//  TinderEditPhotos
//
//  Created by Gagandeep Kaur  on 19/09/15.
//  Copyright (c) 2015 Gagandeep Kaur . All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol buttonPressDelegate <NSObject>

@required

- (void) closeButtonPressed : (NSIndexPath *)indexPath;

@end

@interface CollectionCell : UICollectionViewCell<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property NSIndexPath *indexpath;
@property (nonatomic, weak) id<buttonPressDelegate> delegate;

- (IBAction)actionBtnClose:(id)sender;
@end
