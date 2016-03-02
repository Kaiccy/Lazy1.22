//
//  DetailFoodmaterialViewController.h
//  Lazy
//
//  Created by yinqijie on 15/9/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface DetailFoodmaterialViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,ASIHTTPRequestDelegate>

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)searchBt:(id)sender;
//图片
@property (strong, nonatomic) NSMutableArray *materailImgArry;
//图片名称
@property (strong, nonatomic) NSMutableArray *materailImgNameArry;
//名称
@property (strong, nonatomic) NSMutableArray *nameArry;
//价格
@property (strong, nonatomic) NSMutableArray *priceArry;

//当前页图片路径
@property (strong, nonatomic) NSMutableArray *materailPathArry;
//当前页的图片id
@property (strong, nonatomic) NSMutableArray *materailImgIdArry;

//商品id
@property (strong, nonatomic) NSMutableArray *materailIdArry;
//商品规格
@property (strong, nonatomic) NSMutableArray *materailStandArry;
//商品备注
@property (strong, nonatomic) NSMutableArray *materailRemarkArry;
//商品市场价
@property (strong, nonatomic) NSMutableArray *materailMarketPriceArry;
//结束时间
@property (strong, nonatomic) NSMutableArray *endtimeArry;
//风火轮
@property (strong, nonatomic) UIActivityIndicatorView *activity;
//判断哪个传过来的
@property (assign, nonatomic) int i;
//联网失败提醒
@property (strong, nonatomic) UILabel *lb;

@end
