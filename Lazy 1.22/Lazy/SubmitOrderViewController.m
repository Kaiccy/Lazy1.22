//
//  SubmitOrderViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/14.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "SubmitOrderViewController.h"
#import "GoodsCountViewController.h"
#import "FinallyPaymentViewController.h"
#import "AddressViewController.h"
#import "AppDelegate.h"

@interface SubmitOrderViewController ()

@end

@implementation SubmitOrderViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    self.remarksTextField.delegate = self;
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.lb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 280, 70)];
    self.lb1.backgroundColor = [UIColor whiteColor];
    self.lb1.textAlignment = NSTextAlignmentCenter;
    self.lb1.text = @"请添加收货地址";
    self.lb1.hidden = YES;
    [self.view addSubview:self.lb1];
    
    //查询收获地址接口
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C08&loginName=%@",del.User]];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess1:)];
    [requestUrl setDidFailSelector:@selector(requestError1:)];
    [requestUrl startSynchronous];
    
    //配送日期
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    self.sendDateLb.text = locationString;
    
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    
    self.submitBt.layer.cornerRadius = 12.0;
    self.submitBt.layer.masksToBounds = YES;
    
    self.view1.layer.borderColor = [[UIColor alloc]initWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1].CGColor;
    self.view1.layer.borderWidth = 0.9;
    
    self.view2.layer.borderColor = [[UIColor alloc]initWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1].CGColor;
    self.view2.layer.borderWidth = 0.9;

}

- (void)requestSuccess1:(ASIHTTPRequest *)request
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"地址获取成功!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        NSDictionary *expirDic = [returnlistArry[i] objectForKey:@"expireDate"];
        NSLog(@"expirDic = %@",expirDic);
        if ([expirDic valueForKey:@"<null>"])
        {
            
            [del.addressIdArry addObject:[NSString stringWithFormat:@"%@",[returnlistArry[i] objectForKey:@"addrId"]]];
            [del.personNameArray addObject:[returnlistArry[i] objectForKey:@"addrUserName"]];
            [del.personTelArray addObject:[returnlistArry[i] objectForKey:@"addrPhone"]];
            [del.provinceArray addObject:[returnlistArry[i] objectForKey:@"proinceUrl"]];
            [del.cityArry addObject:[returnlistArry[i] objectForKey:@"cityUrl"]];
            [del.areaArry addObject:[returnlistArry[i] objectForKey:@"areaUrl"]];
            [del.courtArray addObject:[returnlistArry[i] objectForKey:@"villageUrl"]];
            [del.courtNumberArray addObject:[returnlistArry[i] objectForKey:@"houseUrl"]];
            [del.addflagArry addObject:[NSString stringWithFormat:@"%@",[returnlistArry[i] objectForKey:@"firstFlag"]]];
        }
        
    }
    
    //判断收货地址是否为空  如果为空就显示一张标签
    if (del.personNameArray.count != 0)
    {
       
                int j = 0;
                for (int i = 0; i < del.personNameArray.count; i ++)
                {
                    if ([del.addflagArry[i] isEqualToString:@"2"])
                    {
                        j = i;
                    }
                }
        self.getNameLb.text = [NSString stringWithFormat:@"%@ %@",del.personNameArray[j],del.personTelArray[j]];
        self.getAddressLb.text = [NSString stringWithFormat:@"%@ %@ %@",del.provinceArray[j],del.cityArry[j],del.areaArry[j]];
        self.hourseNumLb.text = [NSString stringWithFormat:@"%@ %@",del.courtArray[j],del.courtNumberArray[j]];;
        del.addidStr = del.addressIdArry[j];
    }
    else
    {
        self.lb1.hidden = NO;
    }

}

- (void)requestError1:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//成为第一响应者 弹出键盘
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
//当点击键盘上return按钮的时候调用
{
    //代理记录了当前正在工作的UITextField的实例，因此你点击哪个UITextField对象，形参就是哪个UITextField对象
    [textField resignFirstResponder];//键盘回收代码
    return YES;
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

- (IBAction)submitBt:(id)sender
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    if (del.personNameArray.count == 0)
    {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请选择收货地址！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert1 show];
    }
    else if (self.remarksTextField.text.length > 20)
    {
        UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"字数不超过20" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert2 show];
    }
    else
    {
        //增加订单接口
        self.proidAppendStr = @"";
        for (int i = 0; i < del.orderGoodsid.count; i ++)
        {
            self.proidStr = del.orderGoodsid[i];
            self.proCountStr = del.listCountArray[i];
            NSString *str = [self.proidStr stringByAppendingString:[NSString stringWithFormat:@"-%@",self.proCountStr]];
            self.proidAppendStr = [self.proidAppendStr stringByAppendingString:[NSString stringWithFormat:@";%@",str]];
        }
        //截取字符串
        NSString *string = [self.proidAppendStr substringFromIndex:1];
        NSLog(@"self.proidStr=  %@",self.proidStr);
        NSLog(@"self.proCountStr=  %@",self.proCountStr);
        NSLog(@"proidAppendStr=  %@",string);
        
        
        NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=D01&loginName=%@&amount=%.2f&prodStr=%@&addrId=%d&demo=%@",del.User,self.priceLb.text.floatValue,string,del.addidStr.intValue,self.remarksTextField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess2:)];
        [requestUrl setDidFailSelector:@selector(requestError2:)];
        [requestUrl startSynchronous];
    }
}

- (void)requestSuccess2:(ASIHTTPRequest *)request
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    FinallyPaymentViewController *view = [[FinallyPaymentViewController alloc]initWithNibName:@"FinallyPaymentViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
    
    //商品数量
    int sum = 0;
    for (int i = 0; i < del.listCountArray.count; i ++)
    {
        NSString *countStr = [NSString stringWithFormat:@"%@",del.listCountArray[i]];
        int count = countStr.intValue;
        sum = sum + count;
    }
    
    view.totalCountLb.text = [NSString stringWithFormat:@"共%d件",sum];

    //把提交订单的内容传到声称确认订单
    view.orderPriceLb.text = self.priceLb.text;
    view.nameLb.text = self.getNameLb.text;
    view.teiphoneLb.text = self.getAddressLb.text;
    view.addressLb.text = self.hourseNumLb.text;
    view.demoLb.text = @"请及时付款，否则订单在15分钟后关闭!";
    view.payStateLb.text = @"待支付";
    view.payWayLb.text = @"未付款";
    
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    view.orderNumberLb.text = [NSString stringWithFormat:@"%@",returnlistArry[0]];
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"增加订单成功!");
    }
    else
    {
        NSLog(@"增加订单失败!");
    }
    
    //获得提交订单的时间
    NSDate * newDate = [NSDate date];
    
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    view.orderTimeLb.text = newDateOne;
}

- (void)requestError2:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (IBAction)addressBt:(id)sender
{
    AddressViewController *view = [[AddressViewController alloc]initWithNibName:@"AddressViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
}

- (IBAction)qingdanBt:(id)sender
{
    GoodsCountViewController *view = [[GoodsCountViewController alloc]initWithNibName:@"GoodsCountViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
}
@end
