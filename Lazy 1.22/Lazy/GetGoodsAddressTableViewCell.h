//
//  GetGoodsAddressTableViewCell.h
//  Lazy
//
//  Created by yinqijie on 15/10/10.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetGoodsAddressTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *addressLb;
@property (strong, nonatomic) IBOutlet UILabel *personNameLb;
@property (strong, nonatomic) IBOutlet UILabel *telLb;
@property (copy, nonatomic) NSString *expirStr;
@property (strong, nonatomic) IBOutlet UILabel *stateLb;

@end
