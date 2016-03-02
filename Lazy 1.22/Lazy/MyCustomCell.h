//
//  MyCustomCell.h
//  Lazy
//
//  Created by yinqijie on 15/12/11.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfoModel.h"

//添加代理，用于按钮加减的实现
@protocol MyCustomCellDelegate <NSObject>

-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag;

@end



@interface MyCustomCell : UITableViewCell

@property(strong,nonatomic)UIImageView *goodsImgV;//商品图片
@property(strong,nonatomic)UILabel *goodsTitleLab;//商品标题
@property(strong,nonatomic)UILabel *priceTitleLab;//市场价格
@property(strong,nonatomic)UILabel *priceLab;//具体价格
@property(strong,nonatomic)UILabel *goodsNumLab;//商品规格
@property(strong,nonatomic)UILabel *numCountLab;//购买商品的数量
@property(strong,nonatomic)UIButton *addBtn;//添加商品数量
@property(strong,nonatomic)UIButton *deleteBtn;//删除商品数量
@property(strong,nonatomic)UIButton *isSelectBtn;//是否选中按钮
@property(strong,nonatomic)UIButton *isSelectImg;//是否选中图片

@property(copy,nonatomic)NSString *goodsId;//商品id
@property(copy,nonatomic)NSString *carId;//carid
@property(copy,nonatomic)NSString *dtlId;//dtlid

@property(assign,nonatomic)BOOL selectState;//选中状态

@property(weak,nonatomic)id<MyCustomCellDelegate>delegate;


//赋值
-(void)addTheValue:(GoodsInfoModel *)goodsModel;


@end
