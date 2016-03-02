//
//  SuccessPayViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/14.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessPayViewController : UIViewController

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *payLb;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIImageView *logoImg;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIButton *sureBt;

@end
