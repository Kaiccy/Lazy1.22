//
//  MyOrderTableViewCell.h
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *priceLb;
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLb;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLb;
@property (strong, nonatomic) IBOutlet UILabel *payStateLb;

@end
