//
//  TransitionViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/13.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end
