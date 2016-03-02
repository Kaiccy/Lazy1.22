//
//  VegetablesTableViewCell.h
//  Lazy
//
//  Created by yinqijie on 15/10/9.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VegetablesTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *goodsImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLb;
@property (strong, nonatomic) IBOutlet UILabel *priceLb;
@property (copy, nonatomic) NSString *goodsId;
@property (strong, nonatomic) IBOutlet UILabel *standLb;
@property (copy, nonatomic) NSString *dtlId;
@end
