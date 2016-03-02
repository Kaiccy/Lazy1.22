//
//  AboutViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLb.text = [NSString stringWithFormat:@"当前版本: %@",version];
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.logoImg.frame = CGRectMake(self.view.frame.size.width / 2 - 40, self.introduceText.frame.size.height + self.introduceText.frame.origin.y - 10, 80, 80);
    self.logoLb.frame = CGRectMake(self.view.frame.size.width / 2 - 42, self.logoImg.frame.size.height + self.logoImg.frame.origin.y + 5, 84, 20);
    self.versionLb.frame = CGRectMake(self.view.frame.size.width / 2 - 50, self.logoLb.frame.size.height + self.logoLb.frame.origin.y, 100, 20);

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
