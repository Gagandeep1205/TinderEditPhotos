//
//  ViewController.h
//  TinderEditPhotos
//
//  Created by Gagandeep Kaur  on 19/09/15.
//  Copyright (c) 2015 Gagandeep Kaur . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInfo.h"

@interface ViewController : UIViewController<changeProfilePic>

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UILabel *labelImage;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelAboutUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property UIImage *profilePic;

- (IBAction)actionBtnEdit:(id)sender;

@end

