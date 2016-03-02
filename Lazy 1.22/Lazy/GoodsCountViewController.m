//
//  GoodsCountViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/21.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "GoodsCountViewController.h"
#import "GoodsCountTableViewCell.h"
#import "AppDelegate.h"
#import "GoodsDetailViewController.h"

@interface GoodsCountViewController ()

@end

@implementation GoodsCountViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //签代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //去掉多余的分割线
    [self layout];
}

- (void)layout
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    return del.listNameArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    static NSString *cellID = @"cellID";
    UINib *nib = [UINib nibWithNibName:@"GoodsCountTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellID];
    GoodsCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.goodsCount.text = del.listCountArray[indexPath.row];
    cell.goodsImg.image = del.listImgArray[indexPath.row];
    cell.goodsName.text = del.listNameArray[indexPath.row];
    NSString *price = del.listPriceArray[indexPath.row];
    cell.goodsPrice.text = [NSString stringWithFormat:@"%.2f",price.floatValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //通知中心 输入所要发送的信息 ，同时将label的值通过button方法调用传递，
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:del.goodsId,@"textOne", nil];
    
    //创建通知  (发送多个通知)
    del.goodsId = del.listIdArry[indexPath.row];
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    GoodsDetailViewController *view = [[GoodsDetailViewController alloc]init];
    
    [self presentViewController:view animated:YES completion:nil];
}


- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
