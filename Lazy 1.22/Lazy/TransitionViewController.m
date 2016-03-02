//
//  TransitionViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/13.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "TransitionViewController.h"
#import "MainViewController.h"

@interface TransitionViewController ()

@end

@implementation TransitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //给self.view添加一个手势监测；
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTapAction)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.scrollView addGestureRecognizer:singleRecognizer];

}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
    [self.view addSubview:self.scrollView];
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    //去除水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.scrollView.userInteractionEnabled = YES;
    UIImage *img1 = [UIImage imageNamed:@"欢迎页面1.jpg"];
    UIImage *img2 = [UIImage imageNamed:@"欢迎页面2.jpg"];
    UIImage *img3 = [UIImage imageNamed:@"欢迎页面3.jpg"];
    
    UIImageView *imgview1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    imgview1.image = img1;
    [self.scrollView addSubview:imgview1];
    
    UIImageView *imgview2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgview2.image = img2;
    [self.scrollView addSubview:imgview2];
    
    UIImageView *imgview3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgview3.image = img3;
    [self.scrollView addSubview:imgview3];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30)];
    self.pageControl.backgroundColor = [[UIColor alloc]initWithRed:0.6 green:0.4 blue:0.3 alpha:0.5];
    self.pageControl.hidden = YES;
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(scrollViewScrollAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
}

//单击
- (void)SingleTapAction
{
    if (self.pageControl.currentPage == 2)
    {
        MainViewController *manView = [[MainViewController alloc] init];
        [self presentViewController:manView animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewScrollAction:(UIPageControl *)pa
{
    
    NSInteger number = pa.currentPage;
    [self.scrollView scrollRectToVisible:CGRectMake(320 * number,0,320,self.view.frame.size.height) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (self.scrollView.frame.size.width*0.5+self.scrollView.contentOffset.x)/self.scrollView.frame.size.width;
}

@end
