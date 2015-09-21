//
//  CustomLayout.h
//  TinderEditPhotos
//
//  Created by Gagandeep Kaur  on 21/09/15.
//  Copyright (c) 2015 Gagandeep Kaur . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCollectionLayout <NSObject>

@required

@end

@interface CustomLayout : UICollectionViewLayout

@property (nonatomic, weak) id<CustomCollectionLayout> customDataSource;
@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic, strong) NSDictionary *layoutInfo;

@end
