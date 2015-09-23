//
//  ViewController.m
//  TinderEditPhotos
//
//  Created by Gagandeep Kaur  on 19/09/15.
//  Copyright (c) 2015 Gagandeep Kaur . All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _profilePic = [UIImage imageNamed:@"1.jpg"];
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) configureUI{

    _imgUserProfile.image = [UIImage imageNamed:@"placeholder"];
    _btnEdit.layer.cornerRadius = 2;
    _btnEdit.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
    _btnEdit.layer.borderWidth = 1;
}

#pragma mark - button actions 

- (IBAction)actionBtnEdit:(id)sender {
    
    [self performSegueWithIdentifier:@"segueEdit" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqual:@"segueEdit"]) {

        EditInfo *VC = [segue destinationViewController];
//        VC.profileImage = [UIImage imageNamed:@"placeholder"];
        VC.delegate = self;
    }
}

#pragma mark - protocol methods

- (void) newData:(UIImage *)image{

    if ([image isEqual:NULL]) {
        self.imgUserProfile.image = [UIImage imageNamed:@"placeholder"];
    }
    _profilePic = [[UIImage alloc] init];
    _profilePic = image;
    self.imgUserProfile.image = image;

}





@end
