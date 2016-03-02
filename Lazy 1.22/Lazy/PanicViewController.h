//
//  ViewController.h
//  CountDownTimerForTableView
//
//  Created by FrankLiu on 15/9/8.
//  Copyright (c) 2015年 FrankLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"

@interface PanicViewController : UIViewController<UITableViewDataSource,UIWebViewDelegate,UITableViewDelegate,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,NSURLConnectionDelegate,ASIHTTPRequestDelegate>

{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    MBProgressHUD *HUD;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
//海鲜图片
@property (strong, nonatomic) NSMutableArray *seafoodImgArry;
//图片名称
@property (strong, nonatomic) NSMutableArray *seadfoodImgNameArry;
//名称
@property (strong, nonatomic) NSMutableArray *nameArry;
//价格
@property (strong, nonatomic) NSMutableArray *priceArry;
//当前页图片路径
@property (strong, nonatomic) NSMutableArray *seafoodPathArry;
//当前页的图片id
@property (strong, nonatomic) NSMutableArray *seafoodImgIdArry;
//抢购状态
@property (strong, nonatomic) NSMutableArray *panicStateArry;
//抢购状态颜色
@property (strong, nonatomic) NSMutableArray *panicColorArry;
//商品id
@property (strong, nonatomic) NSMutableArray *seafoodIdArry;
//商品规格
@property (strong, nonatomic) NSMutableArray *seafoodStandArry;
//商品市场价
@property (strong, nonatomic) NSMutableArray *seafoodMarketPriceArry;
//风火轮
@property (strong, nonatomic) UIActivityIndicatorView *activity;
@property double totalTime;
@property (strong, nonatomic) NSMutableArray *showTimeArry;
@property (copy, nonatomic) NSString *endtime;
@property (copy, nonatomic) NSString *starttime;
@property (assign, nonatomic) double remainTime;
@property (assign, nonatomic) int j;
@property (strong, nonatomic) NSMutableArray *remainTimeArry;

@end

