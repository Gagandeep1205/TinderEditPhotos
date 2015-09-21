//
//  CollectionCell.m
//  TinderEditPhotos
//
//  Created by Gagandeep Kaur  on 19/09/15.
//  Copyright (c) 2015 Gagandeep Kaur . All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell


- (IBAction)actionBtnClose:(id)sender {
    
    [self.delegate closeButtonPressed:_indexpath];
}
@end
