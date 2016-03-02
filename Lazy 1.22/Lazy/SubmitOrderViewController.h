//
//  SubmitOrderViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/14.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface SubmitOrderViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *getAddressLb;
@property (strong, nonatomic) IBOutlet UILabel *getNameLb;
@property (strong, nonatomic) IBOutlet UILabel *hourseNumLb;
@property (strong, nonatomic) IBOutlet UITextField *remarksTextField;
@property (strong, nonatomic) IBOutlet UILabel *sendDateLb;
@property (strong, nonatomic) IBOutlet UILabel *priceLb;
@property (strong, nonatomic) IBOutlet UIButton *submitBt;
- (IBAction)submitBt:(id)sender;
- (IBAction)addressBt:(id)sender;
- (IBAction)qingdanBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *goodsImg1;
@property (strong, nonatomic) IBOutlet UIImageView *goodsImg2;
@property (strong, nonatomic) IBOutlet UIImageView *goodsImg3;
@property (strong, nonatomic) IBOutlet UIImageView *moreImg;
@property (strong, nonatomic) IBOutlet UILabel *totalCountLb;
@property (strong, nonatomic) UILabel *lb1; //收获地址
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;

@property (copy, nonatomic) NSString *proidStr;
@property (copy, nonatomic) NSString *proCountStr;
@property (copy, nonatomic) NSString *proidAppendStr;
@property (copy, nonatomic) NSString *proCountAppendStr;
@end
