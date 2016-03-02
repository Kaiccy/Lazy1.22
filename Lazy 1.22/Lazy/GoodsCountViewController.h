//
//  GoodsCountViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/21.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
