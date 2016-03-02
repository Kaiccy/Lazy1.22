//
//  GoodsDetailViewController.h
//  Lazy
//
//  Created by yinqijie on 15/9/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface GoodsDetailViewController : UIViewController<ASIHTTPRequestDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIButton *minusBt;
@property (strong, nonatomic) UIButton *addbt;
@property (strong, nonatomic) UILabel *goodsNumberLb;
@property (strong, nonatomic) UIImageView *goodsImg;
@property (strong, nonatomic) UILabel *goodsTitleLb;
@property (strong, nonatomic) UILabel *goodsIntroduceLb;
@property (strong, nonatomic) UILabel *goodsPriceLb;
@property (strong, nonatomic) UILabel *goodsStandardLb;
@property (strong, nonatomic) UILabel *goodsMarketPriceLb;
@property (strong, nonatomic) UITextField *importTextField;
@property (strong, nonatomic) UIButton *addShoppingCarBt;
@property (strong, nonatomic) UIButton *rightnowBuy;
@property (strong, nonatomic) UIButton *backBt;
@property (strong, nonatomic) UIButton *shoppingCarBt;
@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UIActivityIndicatorView *activity;

//详情商品图片名称
@property (copy, nonatomic) NSString *nameStr;
//传到商品清单的图片名称
@property (copy, nonatomic) NSString *listImgNameStr;
//传到订单页面的图片
@property (strong, nonatomic) UIImage *listImg;
//dtlId
@property int dtlid;
//商品ID数组
@property (strong, nonatomic) NSMutableArray *idArry;
//判断是否加入过购物车
@property (assign, nonatomic)BOOL isAdd;

@property (strong, nonatomic) UIView *view1;
@property (copy, nonatomic) NSString *endtimeStr;

@end
