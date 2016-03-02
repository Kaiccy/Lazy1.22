//
//  SuccessPayViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/14.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "SuccessPayViewController.h"
#import "MainViewController.h"
#import "MyOrderViewController.h"

@interface SuccessPayViewController ()

@end

@implementation SuccessPayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.logoImg.frame = CGRectMake(self.view.frame.size.width / 2 - 40, self.view1.frame.origin.y + 25, 80, 80);
    [self.view addSubview:self.logoImg];
    self.view1.layer.cornerRadius = 20.0;
    self.view1.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBt:(id)sender
{
    MainViewController *mainView = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [self presentViewController:mainView animated:YES completion:nil];
}

@end
