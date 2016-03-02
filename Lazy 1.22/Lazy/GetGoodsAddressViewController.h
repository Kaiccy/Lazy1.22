//
//  GetGoodsAddressViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/10.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface GetGoodsAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>

@property (strong, nonatomic) IBOutlet UIButton *backBt;
- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)addAddresBt:(id)sender;

@property (strong, nonatomic) NSMutableArray *nameArry;
@property (strong, nonatomic) NSMutableArray *addIdArry;
@property (strong, nonatomic) NSMutableArray *addTelArry;
@property (strong, nonatomic) NSMutableArray *provinceArry;
@property (strong, nonatomic) NSMutableArray *cityArry;
@property (strong, nonatomic) NSMutableArray *areaArry;
@property (strong, nonatomic) NSMutableArray *villageArry;
@property (strong, nonatomic) NSMutableArray *flagArry;
@property (strong, nonatomic) NSMutableArray *hourseArry;

@property (strong, nonatomic) NSMutableArray *stateArry;
@property (assign, nonatomic) NSInteger index;
//风火轮
@property (strong, nonatomic) UIActivityIndicatorView *activity;
@property (copy, nonatomic) NSString *provinceStr;
@property (copy, nonatomic) NSString *cityStr;
@property (copy, nonatomic) NSString *areaStr;
@property (copy, nonatomic) NSString *villageStr;
@property (copy, nonatomic) NSString *villageNumStr;
//选中状态
@property(assign, nonatomic)BOOL selectState;
//选中默认按钮
@property (strong, nonatomic)UIButton *btn;
@property (assign, nonatomic)int j;
@end
