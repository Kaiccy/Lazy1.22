//
//  MyOrderViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface MyOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property int i;

@property (strong, nonatomic) NSMutableArray *priceArry;
@property (strong, nonatomic) NSMutableArray *stateArry;
@property (strong, nonatomic) NSMutableArray *orderNumArry;
@property (strong, nonatomic) NSMutableArray *orderTimeArry;
@property (strong, nonatomic) NSMutableArray *orderStateArry;
@property (strong, nonatomic) NSMutableArray *orderState2Arry;
@property (strong, nonatomic) NSMutableArray *colorArry;


@property (strong, nonatomic) NSMutableArray *nameArry;
@property (strong, nonatomic) NSMutableArray *addIdArry;
@property (strong, nonatomic) NSMutableArray *addTelArry;
@property (strong, nonatomic) NSMutableArray *provinceArry;
@property (strong, nonatomic) NSMutableArray *cityArry;
@property (strong, nonatomic) NSMutableArray *areaArry;
@property (strong, nonatomic) NSMutableArray *villageArry;
@property (strong, nonatomic) NSMutableArray *flagArry;
@property (strong, nonatomic) NSMutableArray *hourseArry;

@property (strong, nonatomic) NSMutableArray *imgNameArry;
//风火轮
@property (strong, nonatomic) UIActivityIndicatorView *activity;
//按钮
@property (strong, nonatomic) UIButton *btn;
@end
