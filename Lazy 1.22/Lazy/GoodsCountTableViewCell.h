//
//  GoodsCountTableViewCell.h
//  Lazy
//
//  Created by yinqijie on 15/10/21.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCountTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *goodsImg;
@property (strong, nonatomic) IBOutlet UILabel *goodsName;
@property (strong, nonatomic) IBOutlet UILabel *goodsPrice;
@property (strong, nonatomic) IBOutlet UILabel *goodsCount;

@end
