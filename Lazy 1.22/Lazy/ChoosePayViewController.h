//
//  ChoosePayViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/14.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface ChoosePayViewController : UIViewController<ASIHTTPRequestDelegate>

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLb;
- (IBAction)alipayBt:(id)sender;
- (IBAction)weichatpayBt:(id)sender;
- (IBAction)getGoodsPayBt:(id)sender;
//订单号
@property (copy, nonatomic) NSString *ordernumStr;
@end
