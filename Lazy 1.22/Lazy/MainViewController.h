//
//  MainViewController.h
//  Lazy
//
//  Created by yinqijie on 15/9/22.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "ASIHTTPRequest.h"

@interface MainViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,ASIHTTPRequestDelegate>

- (IBAction)kindBt:(id)sender;
@property (strong, nonatomic) UIScrollView *myScrollview;
@property (strong, nonatomic) NSTimer *mytimer;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) UIPageControl *myPagecontrol;

//section标题名称
@property (strong, nonatomic) NSMutableArray *goodsTitleArry1;
@property (strong, nonatomic) NSMutableArray *goodsTitleArry2;
@property (strong, nonatomic) NSMutableArray *goodsTitleArry3;

@property (strong, nonatomic) IBOutlet UIButton *myOrderBt;
@property (strong, nonatomic) IBOutlet UIButton *shoppingCarBt;
@property (strong, nonatomic) IBOutlet UIButton *addressBt;
@property (strong, nonatomic) IBOutlet UIButton *myAccountBt;
@property (strong, nonatomic) IBOutlet UIButton *aboutBt;
@property (strong, nonatomic) IBOutlet UIButton *loginBt;


@property (strong, nonatomic) IBOutlet UIView *orderView;
- (IBAction)myOrderBt:(id)sender;
- (IBAction)shoppingCarBt:(id)sender;
- (IBAction)addressBt:(id)sender;
- (IBAction)myAccountBt:(id)sender;
- (IBAction)aboutBt:(id)sender;
- (IBAction)loginBt:(id)sender;
- (IBAction)linkBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UIImageView *img4;
@property (strong, nonatomic) IBOutlet UIImageView *img5;
@property (strong, nonatomic) IBOutlet UIImageView *img6;
@property (strong, nonatomic) IBOutlet UIImageView *img7;
@property (strong, nonatomic) IBOutlet UIView *orderView8;
@property (strong, nonatomic) IBOutlet UILabel *userCenterLb;


//图片切换的数组
@property (strong, nonatomic) NSMutableArray *imgArry1;
@property (strong, nonatomic) NSMutableArray *imgArry2;
@property (strong, nonatomic) NSMutableArray *imgArry3;
//三个列表的图片
@property (strong, nonatomic) UIImageView *img8;
@property (strong, nonatomic) UIImageView *img9;
@property (strong, nonatomic) UIImageView *img10;
//搜索按钮
- (IBAction)searchBt:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titlelb;
@property (strong, nonatomic) IBOutlet UIButton *linkbt;
@property (strong, nonatomic) IBOutlet UIView *borderView1;
@property (strong, nonatomic) IBOutlet UIView *borderView2;
@property (strong, nonatomic) IBOutlet UIView *borderView3;
@property (strong, nonatomic) IBOutlet UIView *borderView4;
@property (strong, nonatomic) IBOutlet UIView *borderView5;
@property (strong, nonatomic) IBOutlet UIView *borderView6;
@property (strong, nonatomic) IBOutlet UIView *borderView7;


//名称
@property (strong, nonatomic) NSMutableArray *titleGoodsNameArry;
//价格
@property (strong, nonatomic) NSMutableArray *titleGoodspriceArry;

//海报的产品介绍
@property (strong, nonatomic) NSMutableArray *goodsIntroduceArry;
//海报的产品id
@property (strong, nonatomic) NSMutableArray *titleGoodsIdArry;

//海报图片的id
@property (strong, nonatomic) NSMutableArray *titleGoodsImgIdArry;
//图片的名字
@property (strong, nonatomic) NSMutableArray *titleImgNameArry;
//图片的路径
@property (strong, nonatomic) NSMutableArray *titleImgPathArry;

//商品规格
@property (strong, nonatomic) NSMutableArray *titleGoodsStandArry;
//市场价
@property (strong, nonatomic) NSMutableArray *titleMarketPriceArry;
//风火轮
@property (strong, nonatomic) UIActivityIndicatorView *activity;

@end
