//
//  FinallyPaymentViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface FinallyPaymentViewController : UIViewController<ASIHTTPRequestDelegate>

- (IBAction)backBt:(id)sender;
- (IBAction)sureBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sureBt;
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLb;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLb;
@property (strong, nonatomic) IBOutlet UILabel *orderPriceLb;
@property (strong, nonatomic) IBOutlet UILabel *payWayLb;
@property (strong, nonatomic) IBOutlet UILabel *payStateLb;
@property (strong, nonatomic) IBOutlet UILabel *nameLb;
@property (strong, nonatomic) IBOutlet UILabel *teiphoneLb;
@property (strong, nonatomic) IBOutlet UILabel *addressLb;
- (IBAction)quitOrderBt:(id)sender;
- (IBAction)gotoGoodsCountBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *quitOrderBt;
@property (strong, nonatomic) IBOutlet UIButton *buyagainBt;
- (IBAction)buyagainBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


//增加订单的订单号
@property (strong, nonatomic) NSMutableArray *orderNumArry;
@property (strong, nonatomic) IBOutlet UIButton *deleteOrderBt;
- (IBAction)deleteOrderBt:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *totalLb;
@property (weak, nonatomic) IBOutlet UILabel *importLb;
@property (weak, nonatomic) IBOutlet UILabel *signLb;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;

@property (strong, nonatomic) IBOutlet UIButton *sureGetBt;
- (IBAction)sureGetBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sendingBt;
- (IBAction)sendingBt:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *demoLb;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UIView *view6;
@property (strong, nonatomic) IBOutlet UIView *view7;

@property (strong, nonatomic) IBOutlet UILabel *totalCountLb;
@property (strong, nonatomic) IBOutlet UIView *totalView;
@property (copy, nonatomic) NSString *proidAppendStr;
@property (copy, nonatomic) NSString *proidStr;

@end
