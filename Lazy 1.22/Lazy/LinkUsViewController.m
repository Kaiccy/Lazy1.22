//
//  LinkUsViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/13.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "LinkUsViewController.h"

@interface LinkUsViewController ()

@end

@implementation LinkUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];

}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    
    self.logoImg.frame = CGRectMake(self.view.frame.size.width / 2 - 40, 120, 80, 80);
    self.img1.frame = CGRectMake(28, self.logoImg.frame.size.height + self.logoImg.frame.origin.y + 20 , 25, 25);
    self.img2.frame = CGRectMake(28, self.img1.frame.size.height + self.img1.frame.origin.y + 20, 25, 25);
    self.img3.frame = CGRectMake(28, self.img2.frame.size.height + self.img2.frame.origin.y + 20, 25, 25);
    self.companynameLb.frame = CGRectMake(79, self.logoImg.frame.size.height + self.logoImg.frame.origin.y + 10, 210, 49);
    self.telLb.frame = CGRectMake(79, self.img1.frame.size.height + self.img1.frame.origin.y + 10, 210, 49);
    self.emailLb.frame = CGRectMake(79, self.img2.frame.size.height + self.img2.frame.origin.y + 10, 210, 49);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
