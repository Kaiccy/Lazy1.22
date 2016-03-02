//
//  VegetablesViewController.h
//  Lazy
//
//  Created by yinqijie on 15/9/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequest.h"

@interface VegetablesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,ASIHTTPRequestDelegate>

{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (IBAction)backBt:(id)sender;
- (IBAction)shoppingCarBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//不同section的图片
@property (strong, nonatomic) NSMutableArray *goodsImgArry1;
@property (strong, nonatomic) NSMutableArray *goodsImgArry2;
@property (strong, nonatomic) NSMutableArray *goodsImgArry3;
//不同section的商品名
@property (strong, nonatomic) NSMutableArray *goodsNameArry1;
@property (strong, nonatomic) NSMutableArray *goodsNameArry2;
@property (strong, nonatomic) NSMutableArray *goodsNameArry3;
//不同section的商品价格
@property (strong, nonatomic) NSMutableArray *goodsPriceArry1;
@property (strong, nonatomic) NSMutableArray *goodsPriceArry2;
@property (strong, nonatomic) NSMutableArray *goodsPriceArry3;
//图片名称
@property (strong, nonatomic) NSMutableArray *vegetablesImgNameArry1;
@property (strong, nonatomic) NSMutableArray *vegetablesImgNameArry2;
@property (strong, nonatomic) NSMutableArray *vegetablesImgNameArry3;
//商品id
@property (strong, nonatomic) NSMutableArray *vegetablesIdArry1;
@property (strong, nonatomic) NSMutableArray *vegetablesIdArry2;
@property (strong, nonatomic) NSMutableArray *vegetablesIdArry3;
//商品明细id
@property (strong, nonatomic) NSMutableArray *dtlIdArry1;
@property (strong, nonatomic) NSMutableArray *dtlIdArry2;
@property (strong, nonatomic) NSMutableArray *dtlIdArry3;
//图片路径
@property (strong, nonatomic) NSMutableArray *vegetablesImgPathArry1;
@property (strong, nonatomic) NSMutableArray *vegetablesImgPathArry2;
@property (strong, nonatomic) NSMutableArray *vegetablesImgPathArry3;
//图片id
@property (strong, nonatomic) NSMutableArray *vegetablesImgIdArry1;
@property (strong, nonatomic) NSMutableArray *vegetablesImgIdArry2;
@property (strong, nonatomic) NSMutableArray *vegetablesImgIdArry3;
//商品规格
@property (strong, nonatomic) NSMutableArray *vegetableStandArry1;
@property (strong, nonatomic) NSMutableArray *vegetableStandArry2;
@property (strong, nonatomic) NSMutableArray *vegetableStandArry3;
//判断购物车是否有该商品id
@property (strong, nonatomic) NSMutableArray *idArry;
//判断是否加入过购物车
@property (assign, nonatomic)BOOL isAdd;
@property (strong, nonatomic) UIButton *btn;
//风火轮
@property (strong, nonatomic) UIActivityIndicatorView *activity;
//联网失败提醒
@property (strong, nonatomic) UILabel *lb;
@property (strong, nonatomic) UILabel *isAddLb;
@end
