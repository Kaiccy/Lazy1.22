//
//  SearchViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/13.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequest.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,ASIHTTPRequestDelegate>

{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property (strong, nonatomic) IBOutlet UISearchBar *search;
- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLb;

@property (strong, nonatomic) NSMutableArray *emptyArry;
//商品名称
@property (strong, nonatomic) NSMutableArray *allGoodsArry;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
//加入购物车按钮
@property (strong, nonatomic) UIButton *btn;
//商品id
@property (strong, nonatomic) NSMutableArray *goodsIdArry;
//商品图片名称
@property (strong, nonatomic) NSMutableArray *goodsImgNameArry;
//商品图片
@property (strong, nonatomic) NSMutableArray *goodsImgArry;
//商品价格
@property (strong, nonatomic) NSMutableArray *goodsPriceArry;
//商品规格
@property (strong, nonatomic) NSMutableArray *goodsStandArry;
//查询购物车商品的id
@property (strong, nonatomic) NSMutableArray *idArry;
//判断是否加入过购物车
@property (assign, nonatomic) BOOL isAdd;
//产品明细id
@property (strong, nonatomic) NSMutableArray *dtlIdArry;

@property (strong, nonatomic) NSMutableArray *remainTimeArry;
@property (strong, nonatomic) NSMutableArray *tempArry;
@end
