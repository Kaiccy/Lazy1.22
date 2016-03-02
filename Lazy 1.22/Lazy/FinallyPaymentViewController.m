//
//  FinallyPaymentViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "FinallyPaymentViewController.h"
#import "ChoosePayViewController.h"
#import "GoodsCountViewController.h"
#import "AppDelegate.h"

@interface FinallyPaymentViewController ()

@end

@implementation FinallyPaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //先隐藏不用的按钮
    self.sureGetBt.hidden = YES;
    self.sendingBt.hidden = YES;
    self.deleteOrderBt.hidden = YES;
    self.buyagainBt.hidden = YES;
    self.orderNumArry = [[NSMutableArray alloc]init];
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (del.dtlidArry.count != 0)
    {
        [self deleteGoods];
    }

}
- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.view1.layer.borderColor = [[UIColor alloc]initWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1].CGColor;
    self.view1.layer.borderWidth = 0.9;
    
    self.view2.layer.borderColor = [[UIColor alloc]initWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1].CGColor;
    self.view2.layer.borderWidth = 0.2;
    
    self.view3.layer.borderColor = [[UIColor alloc]initWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1].CGColor;
    self.view3.layer.borderWidth = 0.9;
    
    self.view4.layer.borderColor = [[UIColor alloc]initWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1].CGColor;
    self.view4.layer.borderWidth = 0.9;
    
    self.view5.layer.borderColor = [[UIColor alloc]initWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1].CGColor;
    self.view5.layer.borderWidth = 0.5;
    
    self.view6.layer.borderColor = [[UIColor alloc]initWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1].CGColor;
    self.view6.layer.borderWidth = 0.5;
    
    self.view7.layer.borderColor = [[UIColor alloc]initWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1].CGColor;
    self.view7.layer.borderWidth = 0.9;
    self.view7.frame = CGRectMake(0, self.view.frame.size.height - 60, self.view7.frame.size.width, 60);
    [self.view addSubview:self.view7];
    
    self.scrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60 - 60);
    
    self.view4.frame = CGRectMake(0, self.totalCountLb.frame.origin.y + 35, self.view.frame.size.width, 15);
    [self.totalView addSubview:self.view4];
    self.timeLb.frame = CGRectMake(8, self.view4.frame.origin.y + self.view4.frame.size.height + 5, 75, 21);
    self.orderTimeLb.frame = CGRectMake(91, self.view4.frame.origin.y + self.view4.frame.size.height + 5, 221, 21);
    [self.totalView addSubview:self.timeLb];
    [self.totalView addSubview:self.orderTimeLb];
    self.view8.frame = CGRectMake(0, self.orderTimeLb.frame.origin.y + self.orderTimeLb.frame.size.height + 5, self.view.frame.size.width, 1);
    [self.totalView addSubview:self.view8];
    self.totalLb.frame = CGRectMake(8, self.view8.frame.origin.y + self.view8.frame.size.height + 5, 75, 21);
    [self.totalView addSubview:self.totalLb];
    self.signLb.frame = CGRectMake(91, self.view8.frame.origin.y + self.view8.frame.size.height + 5, 24, 21);
    [self.totalView addSubview:self.signLb];
    self.orderPriceLb.frame = CGRectMake(102, self.view8.frame.origin.y + self.view8.frame.size.height + 5, 221, 21);
    [self.totalView addSubview:self.orderPriceLb];
    self.view9.frame = CGRectMake(0, self.orderPriceLb.frame.origin.y + self.orderPriceLb.frame.size.height + 5, self.view.frame.size.width, 1);
    [self.totalView addSubview:self.view9];
    self.importLb.frame = CGRectMake(8, self.view9.frame.origin.y + self.view8.frame.size.height + 5, 75, 21);
    self.demoLb.frame = CGRectMake(91, self.view9.frame.origin.y + self.view9.frame.size.height + 5, self.view.frame.size.width - 100, 21);
    [self.totalView addSubview:self.demoLb];
    
    self.totalView.frame = CGRectMake(0, 15, self.view.frame.size.width, self.demoLb.frame.origin.y + self.demoLb.frame.size.height + 30);
    [self.scrollView addSubview:self.totalView];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.totalView.frame.size.height + self.totalView.frame.origin.y + 10);
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.totalView];

}

//调用删除购物车结算了的商品
- (void) deleteGoods
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.proidAppendStr = @"";
    for (int i = 0; i < del.dtlidArry.count; i ++)
    {
        self.proidStr = del.dtlidArry[i];
        self.proidAppendStr = [self.proidAppendStr stringByAppendingString:[NSString stringWithFormat:@",%@",self.proidStr]];
    }
    //截取字符串
    NSString *string = [self.proidAppendStr substringFromIndex:1];
    //删除购物车接口
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C03&loginName=%@&dtlId=%@",del.User,string]];//多个dtlid用逗号隔开
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess1:)];
    [requestUrl setDidFailSelector:@selector(requestError1:)];
    [requestUrl startSynchronous];
}

- (void)requestSuccess1:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"删除成功");
        
    }

}

- (void)requestError1:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//去支付
- (IBAction)sureBt:(id)sender
{
    ChoosePayViewController *view = [[ChoosePayViewController alloc]initWithNibName:@"ChoosePayViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
    view.totalPriceLb.text = self.orderPriceLb.text;
    view.ordernumStr = self.orderNumberLb.text;
}

//取消订单
- (IBAction)quitOrderBt:(id)sender
{
    NSString *str = @"您已取消订单!";
    NSString *str1 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=D02&subpCode=%@&demo=%@",self.orderNumberLb.text,str1]];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess2:)];
    [requestUrl setDidFailSelector:@selector(requestError2:)];
    [requestUrl startSynchronous];

}

- (void)requestSuccess2:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"取消订单成功!");
    }
    else
    {
        NSLog(@"取消订单失败!");
    }
    self.sureBt.enabled = NO;
    self.quitOrderBt.enabled = NO;

}

- (void)requestError2:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//商品清单
- (IBAction)gotoGoodsCountBt:(id)sender
{
    GoodsCountViewController *view = [[GoodsCountViewController alloc]initWithNibName:@"GoodsCountViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
    
}
//删除订单
- (IBAction)deleteOrderBt:(id)sender
{
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=D08&subpCode=%@&demo=删除",self.orderNumberLb.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess3:)];
    [requestUrl setDidFailSelector:@selector(requestError3:)];
    [requestUrl startSynchronous];
}

- (void)requestSuccess3:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"删除订单成功!");
    }
    else
    {
        NSLog(@"删除订单失败!");
    }
    
    [self.deleteOrderBt setEnabled:NO];
}

- (void)requestError3:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//确认收货
- (IBAction)sureGetBt:(id)sender
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=D07&subpCode=%@",self.orderNumberLb.text]];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess4:)];
    [requestUrl setDidFailSelector:@selector(requestError4:)];
    [requestUrl startSynchronous];

}

- (void)requestSuccess4:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"确认收货成功!");
    }
    else
    {
        NSLog(@"确认收货失败!");
    }
}

- (void)requestError4:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//配送中
- (IBAction)sendingBt:(id)sender
{
    
}
- (IBAction)buyagainBt:(id)sender
{
    
}
@end
