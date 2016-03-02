//
//  GoodsInfoModel.h
//  ShoppingList_Demo
//
//  Created by 李金华 on 15/4/21.
//  Copyright (c) 2015年 LJH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsInfoModel : NSObject

@property(copy,nonatomic)NSString *imageName;//商品图片
@property(copy,nonatomic)NSString *goodsTitle;//商品标题
@property(copy,nonatomic)NSString *goodsStand;//商品规格
@property(copy,nonatomic)NSString *goodsPrice;//商品单价
@property(copy,nonatomic)NSString *goodsMarketPrice;//商品市场价
@property(assign,nonatomic)BOOL selectState;//是否选中状态
@property(assign,nonatomic)int goodsNum;//商品个数
@property(copy,nonatomic)NSString *goodsId;//商品id
@property(copy,nonatomic)NSString *carId;//carid
@property(copy,nonatomic)NSString *dtlId;//dtlid

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
