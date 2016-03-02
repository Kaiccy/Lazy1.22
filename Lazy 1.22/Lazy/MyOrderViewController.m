//
//  MyOrderViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "FinallyPaymentViewController.h"
#import "AppDelegate.h"
#import "ChoosePayViewController.h"

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //初始化数组
    [self initArray];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(self.view.frame.size.width/2 - 50/2, self.view.frame.size.height/2 - 25, 50, 50);
    self.activity.hidesWhenStopped = YES;
    [self.view addSubview:self.activity];
    [self.activity startAnimating];
    self.tableView.hidden = YES;
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //查询订单
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=D04&loginName=%@",del.User]];

    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess1:)];
    [requestUrl setDidFailSelector:@selector(requestError1:)];
    [requestUrl startAsynchronous];
    
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    //去掉多余的分割线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
}

- (void)initArray
{
    self.priceArry = [[NSMutableArray alloc]init];
    self.orderNumArry = [[NSMutableArray alloc]init];
    self.stateArry = [[NSMutableArray alloc]init];
    self.orderTimeArry = [[NSMutableArray alloc]init];
    self.orderStateArry = [[NSMutableArray alloc]init];
    self.orderState2Arry = [[NSMutableArray alloc]init];
    self.colorArry = [[NSMutableArray alloc]init];
    
    self.nameArry = [[NSMutableArray alloc] init];
    self.addIdArry = [[NSMutableArray alloc] init];
    self.addTelArry = [[NSMutableArray alloc] init];
    self.provinceArry = [[NSMutableArray alloc] init];
    self.cityArry = [[NSMutableArray alloc] init];
    self.areaArry = [[NSMutableArray alloc] init];
    self.villageArry = [[NSMutableArray alloc] init];
    self.hourseArry = [[NSMutableArray alloc] init];
    self.flagArry = [[NSMutableArray alloc] init];
    
    self.imgNameArry = [[NSMutableArray alloc] init];
}

- (void)requestSuccess1:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"查询订单成功!");
    }
    else
    {
        NSLog(@"查询订单失败!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        NSDictionary *prodSubpDic = [returnlistArry[i] objectForKey:@"prodSubp"];
        //商品订单号
        [self.orderNumArry addObject:[prodSubpDic objectForKey:@"subpCode"]];
        //商品支付状态
        [self.stateArry addObject:[prodSubpDic objectForKey:@"stateName"]];
        if ([[prodSubpDic objectForKey:@"stateName"] isEqualToString:@"待支付"])
        {
            [self.orderState2Arry addObject:@"去支付"];
            [self.colorArry addObject:[UIColor colorWithRed:162.0 / 255.0 green:73.0 / 255.0 blue:200.0 / 255.0 alpha:1.0]];
        }
        else if ([[prodSubpDic objectForKey:@"stateName"] isEqualToString:@"已付款"])
        {
            [self.orderState2Arry addObject:@"确认收货"];
            [self.colorArry addObject:[UIColor colorWithRed:162.0 / 255.0 green:73.0 / 255.0 blue:200.0 / 255.0 alpha:1.0]];
        }
        else if ([[prodSubpDic objectForKey:@"stateName"] isEqualToString:@"已成交"])
        {
            [self.orderState2Arry addObject:@""];
            [self.colorArry addObject:[UIColor whiteColor]];
        }
        else
        {
            [self.orderState2Arry addObject:@""];
            [self.colorArry addObject:[UIColor whiteColor]];
        }
        
        //商品价格
        [self.priceArry addObject:[NSString stringWithFormat:@"%@",[prodSubpDic objectForKey:@"amountYuan"]]];
        //下单时间
        NSDictionary *createDic = [prodSubpDic objectForKey:@"createDate"];
        NSString *endtime = [NSString stringWithFormat:@"%@",[createDic objectForKey:@"time"]];
        endtime = [endtime substringToIndex:10];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:endtime.intValue + 480];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *str = [outputFormatter stringFromDate:confromTimesp];
        [self.orderTimeArry addObject:str];
        
    }
    [self.activity stopAnimating];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)requestError1:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
    if ([[error localizedDescription] isEqualToString:@"A connection failure occurred"])
    {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 2 - 30, 200, 60)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:17];
        lb.numberOfLines = 2;
        lb.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
        lb.text = @"加载失败,请检查您的网络环境!";
        [self.activity stopAnimating];
        [self.view addSubview:lb];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.priceArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    UINib *nib = [UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellID];
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.priceLb.text = self.priceArry[indexPath.row];
    cell.orderNumberLb.text = self.orderNumArry[indexPath.row];
    cell.orderTimeLb.text = self.orderTimeArry[indexPath.row];
    cell.payStateLb.text = self.stateArry[indexPath.row];
    
    //添加购买按钮
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80, 50, 60, 20)];
    [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn setTitle:self.orderState2Arry[indexPath.row] forState:UIControlStateNormal];
    self.btn.backgroundColor = self.colorArry[indexPath.row];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cell addSubview:self.btn];
    self.i = (int)indexPath.row;
    return cell;
}

- (void)btnAction:(UIButton *)bt
{
    MyOrderTableViewCell *cell = (MyOrderTableViewCell *)[bt superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"indexPath is = %li",(long)indexPath.row);
    if ([self.orderState2Arry[indexPath.row] isEqualToString:@"去支付"])
    {
        ChoosePayViewController *view = [[ChoosePayViewController alloc]initWithNibName:@"ChoosePayViewController" bundle:nil];
        [self presentViewController:view animated:YES completion:nil];
        view.totalPriceLb.text = self.priceArry[indexPath.row];
        view.ordernumStr = self.orderNumArry[indexPath.row];
    }
    else if ([self.orderState2Arry[indexPath.row] isEqualToString:@"确认收货"])
    {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=D07&subpCode=%@",self.orderNumArry[indexPath.row]]];
        
        NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"再次确认" message:@"确认收货吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
       

    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [del.listImgArray removeAllObjects];
    [del.listCountArray removeAllObjects];
    [del.listNameArray removeAllObjects];
    [del.listPriceArray removeAllObjects];
    [del.listIdArry removeAllObjects];
    
    FinallyPaymentViewController *view = [[FinallyPaymentViewController alloc]initWithNibName:@"FinallyPaymentViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
    //订单明细
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=D05&subpCode=%@",self.orderNumArry[indexPath.row]]];
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"订单明细获取成功!");
    }
    else
    {
        NSLog(@"订单明细获取失败!");
    }
    NSLog(@"returnlistArry = %@",returnlistArry);

    //商品明细
    
    NSArray *prodSubpDtlDtosArry = [returnlistArry[0] objectForKey:@"prodSubpDtlDtos"];
    NSLog(@"prodSubpDtlDtosArry = %@",prodSubpDtlDtosArry);
    for (int i = 0; i < prodSubpDtlDtosArry.count; i ++)
    {
        NSDictionary *prodDtlDic = [prodSubpDtlDtosArry[i] objectForKey:@"prodDtl"];
        NSDictionary *prodSubpDtlDic = [prodSubpDtlDtosArry[i] objectForKey:@"prodSubpDtl"];
        [del.listIdArry addObject:[NSString stringWithFormat:@"%@",[prodSubpDtlDic objectForKey:@"prodId"]]];
        [del.listCountArray addObject:[NSString stringWithFormat:@"%@",[prodSubpDtlDic objectForKey:@"prodNumber"]]];
        
        NSString *countStr = [NSString stringWithFormat:@"%@",[prodSubpDtlDic objectForKey:@"prodNumber"]];
        NSString *singlePriceStr = [NSString stringWithFormat:@"%@",[prodDtlDic objectForKey:@"amountYuan"]];
        NSString *totalPriceStr = [NSString stringWithFormat:@"%.2f",countStr.intValue * singlePriceStr.floatValue];
        [del.listPriceArray addObject:totalPriceStr];
        NSDictionary *productDic = [prodSubpDtlDtosArry[i] objectForKey:@"product"];
        [del.listNameArray addObject:[productDic objectForKey:@"prodName"]];
        NSArray *imgListArry = [productDic objectForKey:@"imgList"];
        [self.imgNameArry addObject:[imgListArry[1] objectForKey:@"imgName"]];
    }
    //请求图片
    for (int i = 0; i < self.imgNameArry.count; i++)
    {
        if ([self.imgNameArry[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.imgNameArry[i]]]]];
            [del.listImgArray addObject:img];
        }
        else
        {
            [del.listImgArray addObject:[UIImage imageNamed:@"moren.png"]];
        }
        
    }
    //商品数量
    int sum = 0;
    for (int i = 0; i < del.listCountArray.count; i ++)
    {
        NSString *countStr = [NSString stringWithFormat:@"%@",del.listCountArray[i]];
        int count = countStr.intValue;
        sum = sum + count;
    }
    view.totalCountLb.text = [NSString stringWithFormat:@"共%d件",sum];
    
    //传到订单详情页面
    NSDictionary *prodSubpDic = [returnlistArry[0] objectForKey:@"prodSubp"];
    view.orderPriceLb.text = self.priceArry[indexPath.row];
    ;
    view.demoLb.text = [prodSubpDic objectForKey:@"demo"];
    NSString *stateStr = [NSString stringWithFormat:@"%@",[prodSubpDic objectForKey:@"state"]];
    if (stateStr.intValue == 1)
    {
        view.payStateLb.text = @"待支付";
        //只显示取消订单 去支付按钮
        view.quitOrderBt.hidden = NO;
        view.sureBt.hidden = NO;
        view.deleteOrderBt.hidden = YES;
        view.sendingBt.hidden = YES;
        view.sureGetBt.hidden = YES;
        view.buyagainBt.hidden = YES;
    }
    else if(stateStr.intValue == 2)
    {
        view.payStateLb.text = @"已付款";
        //只显示配送中 确认收货按钮
        view.sendingBt.hidden = NO;
        view.deleteOrderBt.hidden = YES;
        view.sureGetBt.hidden = NO;
        view.quitOrderBt.hidden = YES;
        view.buyagainBt.hidden = YES;
        view.sureBt.hidden = YES;
    }
    else if (stateStr.intValue == 3)
    {
        view.payStateLb.text = @"配送中";
        //只显示配送中 确认收货按钮
        view.sendingBt.hidden = NO;
        view.deleteOrderBt.hidden = YES;
        view.sureGetBt.hidden = NO;
        view.quitOrderBt.hidden = YES;
        view.buyagainBt.hidden = YES;
        view.sureBt.hidden = YES;

    }
    else if (stateStr.intValue == 4)
    {
        view.payStateLb.text = @"已成交";
        //只显示删除订单和确认收货安妮
        view.deleteOrderBt.hidden = NO;
        view.sureGetBt.hidden = YES;
        view.quitOrderBt.hidden = YES;
        view.buyagainBt.hidden = YES;
        view.sendingBt.hidden = YES;
        view.sureBt.hidden = YES;
    }
    else if (stateStr.intValue == 5)
    {
        view.payStateLb.text = @"已取消";
        //只显示再次购买按钮
        view.buyagainBt.hidden = NO;
        view.deleteOrderBt.hidden = YES;
        view.sendingBt.hidden = YES;
        view.sureGetBt.hidden = YES;
        view.quitOrderBt.hidden = YES;
        view.sureBt.hidden = YES;

        
    }
    else if (stateStr.intValue == 6)
    {
        //只显示删除按钮
        view.payStateLb.text = @"已关闭";
        view.buyagainBt.hidden = YES;
        view.deleteOrderBt.hidden = NO;
        view.sendingBt.hidden = YES;
        view.sureGetBt.hidden = YES;
        view.quitOrderBt.hidden = YES;
        view.sureBt.hidden = YES;
    }
    else if (stateStr.intValue == 7)
    {
        view.payStateLb.text = @"待退款";
    }
    else
    {
        view.payStateLb.text = @"待退货";
    }
    NSString *payWayStr = [prodSubpDic objectForKey:@"payType"];
    if (payWayStr.intValue == 0)
    {
        view.payWayLb.text = @"未付款";
    }
    else if (payWayStr.intValue == 1)
    {
        view.payWayLb.text = @"支付宝";
    }
    else if (payWayStr.intValue == 2)
    {
        view.payWayLb.text = @"微信";
    }
    else if (payWayStr.intValue == 3)
    {
        view.payWayLb.text = @"货到付款";
    }
    view.orderNumberLb.text = [prodSubpDic objectForKey:@"subpCode"];
    NSString *addidStr = [NSString stringWithFormat:@"%@",[prodSubpDic objectForKey:@"addrId"]];
    
    //查询收获地址接口
    NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C08&loginName=%@",del.User]];
    //jason解析
    NSURLRequest *requestUrl2 = [NSURLRequest requestWithURL:url2];
    NSData *data2 = [NSURLConnection sendSynchronousRequest:requestUrl2 returningResponse:nil error:nil];
    NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:nil];
   // NSLog(@"%@",dic2);
    NSString *returncode2 = [dic2 objectForKey:@"returnCode"];
    NSArray *returnlistArry2 = [dic2 objectForKey:@"returnList"];
    
    if([returncode2 isEqualToString:@"ok"])
    {
        NSLog(@"地址获取成功!");
    }
    
    for (int i = 0; i < returnlistArry2.count; i++)
    {
        NSDictionary *expirDic = [returnlistArry2[i] objectForKey:@"expireDate"];
        if ([expirDic valueForKey:@"<null>"])
        {
            
            [self.addIdArry addObject:[NSString stringWithFormat:@"%@",[returnlistArry2[i] objectForKey:@"addrId"]]];
            [self.nameArry addObject:[returnlistArry2[i] objectForKey:@"addrUserName"]];
            [self.addTelArry addObject:[returnlistArry2[i] objectForKey:@"addrPhone"]];
            [self.provinceArry addObject:[returnlistArry2[i] objectForKey:@"proinceUrl"]];
            [self.cityArry addObject:[returnlistArry2[i] objectForKey:@"cityUrl"]];
            [self.areaArry addObject:[returnlistArry2[i] objectForKey:@"areaUrl"]];
            [self.villageArry addObject:[returnlistArry2[i] objectForKey:@"villageUrl"]];
            [self.hourseArry addObject:[returnlistArry2[i] objectForKey:@"houseUrl"]];
        }
        
    }

    int j = 0;//记住下标
    for (int i = 0; i < self.nameArry.count; i ++)
    {
        if ([addidStr isEqualToString:self.addIdArry[i]])
        {
            j = i;
            
        }
    }
    view.nameLb.text = [NSString stringWithFormat:@"%@ %@",self.nameArry[j],self.addTelArry[j]];
    view.teiphoneLb.text = [NSString stringWithFormat:@"%@ %@ %@",self.provinceArry[j],self.cityArry[j],self.areaArry[j]];
    view.addressLb.text = [NSString stringWithFormat:@"%@ %@",self.villageArry[j],self.hourseArry[j]];
    view.orderTimeLb.text = self.orderTimeArry[indexPath.row];
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=D08&subpCode=%@&demo=删除",self.orderNumArry[indexPath.row]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
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
        
        [self.priceArry removeObjectAtIndex:indexPath.row];
        [self.orderNumArry removeObjectAtIndex:indexPath.row];
        [self.orderTimeArry removeObjectAtIndex:indexPath.row];
        [self.stateArry removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
