//
//  ChoosePayViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/14.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "ChoosePayViewController.h"
#import "SuccessPayViewController.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "PartnerConfig.h"
#import "DataSigner.h"

@interface ChoosePayViewController ()

@end

@implementation ChoosePayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [[UIScreen mainScreen]bounds];
    
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

- (IBAction)alipayBt:(id)sender
{
    /**
     *  1. 生成订单信息
     */
    Order *order = [[Order alloc] init];
    order.partner = PartnerID; //支付宝分配给商户的ID
    order.seller = SellerID; //收款支付宝账号（用于收💰）
    order.tradeNO = self.ordernumStr; //订单ID(由商家自行制定)
    NSLog(@"%@", order.tradeNO);
    order.productName = self.ordernumStr; //商品标题
    order.productDescription = @"懒猪社区商品"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f", self.totalPriceLb.text.floatValue]; //商品价格
    //???: 回调 URL 没有进行调试
    order.notifyURL =  @"http://junjuekeji.com/appServlet/doAliPayNotify"; //回调URL（通知服务器端交易结果）(重要)
    
    //???: 接口名称要如何修改?
    order.service = @"mobile.securitypay.pay"; //接口名称, 固定值, 不可空
    order.paymentType = @"1"; //支付类型 默认值为1(商品购买), 不可空
    order.inputCharset = @"utf-8"; //参数编码字符集: 商户网站使用的编码格式, 固定为utf-8, 不可空
    order.itBPay = @"30m"; //未付款交易的超时时间 取值范围:1m-15d, 可空
    
    // 应用注册scheme,在当前项目的Info.plist定义URL types
    NSString *appScheme = @"Lazy";
    // 将订单信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"订单信息orderSpec = %@", orderSpec);
    
    /**
     *  2. 签名加密
     *  获取私钥并将商户信息签名, 外部商户可以根据情况存放私钥和签名, 只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
     */
    id <DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    /**
     *  3. 将签名成功字符串格式化为订单字符串,请严格按照该格式
     */
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

    
    
}

- (IBAction)weichatpayBt:(id)sender
{
    //判断是否安装微信
    if ([WXApi isWXAppInstalled])
    {
        //从服务器获取支付参数，服务端自定义处理逻辑和格式
        //订单标题
        NSString *ORDER_NAME = self.ordernumStr;
        //订单金额，单位（元）
        NSString *ORDER_PRICE = self.totalPriceLb.text;
        
        //根据服务器端编码确定是否转码
        NSStringEncoding enc;
        //if UTF8编码
        //enc = NSUTF8StringEncoding;
        //if GBK编码
        enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *urlString = [NSString stringWithFormat:@"%@?plat=ios&order_no=%@&product_name=%@&order_price=%@",
                               SP_URL,
                               [[NSString stringWithFormat:@"%ld",time(0)] stringByAddingPercentEscapesUsingEncoding:enc],
                               [ORDER_NAME stringByAddingPercentEscapesUsingEncoding:enc],
                               ORDER_PRICE];
        
        //解析服务端返回json数据
        NSError *error;
        //加载一个NSURL对象
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        //将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if ( response != nil) {
            NSMutableDictionary *dict = NULL;
            //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
            dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            
            NSLog(@"url:%@",urlString);
            if(dict != nil){
                NSMutableString *retcode = [dict objectForKey:@"retcode"];
                if (retcode.intValue == 0){
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.openID              = [dict objectForKey:@"appid"];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                    //日志输出
                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                }else{
                    [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
                }
            }else{
                [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
            }
        }else{
            [self alert:@"提示信息" msg:@"服务器返回错误"];
        }

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有微信客户端" message:@"请安装微信客户端后再支付" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}


- (IBAction)getGoodsPayBt:(id)sender
{
    
    NSString *str = @"货到付款";
    NSString *str1 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=D03&subpCode=%@&payType=3&payAccount=%@",self.ordernumStr,str1]];
    
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
        NSLog(@"货到付款支付订单成功!");
        
        SuccessPayViewController *view = [[SuccessPayViewController alloc]initWithNibName:@"SuccessPayViewController" bundle:nil];
        [self presentViewController:view animated:YES completion:nil];
    }
    else
    {
        NSLog(@"货到付款订单失败!");
    }
}

- (void)requestError1:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];//移除通知
}

@end
