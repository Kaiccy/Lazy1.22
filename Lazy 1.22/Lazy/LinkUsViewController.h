//
//  LinkUsViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/13.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkUsViewController : UIViewController

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *telLb;
@property (strong, nonatomic) IBOutlet UILabel *emailLb;
@property (strong, nonatomic) IBOutlet UILabel *companynameLb;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UIImageView *logoImg;

@end
