//
//  AppDelegate.h
//  Lazy
//
//  Created by yinqijie on 15/9/22.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "FMDB.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,BMKGeneralDelegate>
{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

//FMDB数据库对象
@property (strong,nonatomic) FMDatabase *db;
@property (copy,nonatomic) NSString *path;
//登录唯一账号
@property (copy,nonatomic) NSString *User;
@property (copy,nonatomic) NSString *name;
//用于存储图像图片
@property (strong, nonatomic) UIImage *HeadImage;
//用于存储搭档缺省头像图像，在比较是否是默认头像时可直接比较。
@property (strong, nonatomic) UIImage *DefaultAvatar;
//用于传递绑定密码
@property (copy, nonatomic) NSString *pwdStr;
//传递登录名
@property (copy, nonatomic) NSString *loginNameStr;
//用户ID
@property (copy, nonatomic) NSString *userId;
//性别
@property int sexType;
//用户昵称
@property (copy, nonatomic) NSString *userNickName;

//首页下面三个进入的页面section标题中间数组
@property (strong, nonatomic) NSMutableArray *tempArry;
//列表indexpath.row
@property NSInteger index;
//宝贝详情页传到提交订单页面
@property (strong, nonatomic)UIImage *goodsImage;
@property (copy, nonatomic)NSString *goodsNameStr;
@property (copy, nonatomic)NSString *goodsPriceStr;

//添加地址传到收获地址里
@property (strong, nonatomic)NSMutableArray *personNameArray;
@property (strong, nonatomic)NSMutableArray *personTelArray;
@property (strong, nonatomic)NSMutableArray *provinceArray;
@property (strong, nonatomic)NSMutableArray *cityArry;
@property (strong, nonatomic)NSMutableArray *areaArry;
@property (strong, nonatomic)NSMutableArray *courtArray;
@property (strong, nonatomic)NSMutableArray *courtNumberArray;

//商品清单
@property (strong, nonatomic)NSMutableArray *listImgArray;
@property (strong, nonatomic)NSMutableArray *listNameArray;
@property (strong, nonatomic)NSMutableArray *listPriceArray;
@property (strong, nonatomic)NSMutableArray *listCountArray;
@property (strong, nonatomic)NSMutableArray *listIdArry;

//商品Id
@property (copy, nonatomic) NSString *goodsId;

//收获地址Id
@property (strong, nonatomic) NSMutableArray *addressIdArry;
//增加订单接口的地址id
@property (copy, nonatomic) NSString *addidStr;
//增加地址接口的产品id  产品数量
@property (strong, nonatomic) NSMutableArray *orderGoodsid;
@property (strong, nonatomic) NSMutableArray *orderGoodsCount;
//地址的flag值
@property (strong, nonatomic)NSMutableArray *addflagArry;
//购物车传给选择支付界面的dtlid
@property (strong, nonatomic)NSMutableArray *dtlidArry;

@end

