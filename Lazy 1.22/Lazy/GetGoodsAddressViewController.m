//
//  GetGoodsAddressViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/10.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "GetGoodsAddressViewController.h"
#import "GetGoodsAddressTableViewCell.h"
#import "AddressViewController.h"
#import "AddressManageViewController.h"
#import "AppDelegate.h"
#import "SubmitOrderViewController.h"

@interface GetGoodsAddressViewController ()

@end

@implementation GetGoodsAddressViewController

- (void)viewWillAppear:(BOOL)animated
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
    
    //查询收获地址接口
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C08&loginName=%@", del.User]];
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
    self.nameArry = [[NSMutableArray alloc] init];
    self.addIdArry = [[NSMutableArray alloc] init];
    self.addTelArry = [[NSMutableArray alloc] init];
    self.provinceArry = [[NSMutableArray alloc] init];
    self.cityArry = [[NSMutableArray alloc] init];
    self.areaArry = [[NSMutableArray alloc] init];
    self.villageArry = [[NSMutableArray alloc] init];
    self.hourseArry = [[NSMutableArray alloc] init];
    self.flagArry = [[NSMutableArray alloc] init];
}

- (void)requestSuccess1:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"%@",dic);
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
            
            [self.addIdArry addObject:[NSString stringWithFormat:@"%@",[returnlistArry[i] objectForKey:@"addrId"]]];
            [self.nameArry addObject:[returnlistArry[i] objectForKey:@"addrUserName"]];
            [self.addTelArry addObject:[returnlistArry[i] objectForKey:@"addrPhone"]];
            [self.provinceArry addObject:[returnlistArry[i] objectForKey:@"proinceUrl"]];
            [self.cityArry addObject:[returnlistArry[i] objectForKey:@"cityUrl"]];
            [self.areaArry addObject:[returnlistArry[i] objectForKey:@"areaUrl"]];
            [self.villageArry addObject:[returnlistArry[i] objectForKey:@"villageUrl"]];
            [self.hourseArry addObject:[returnlistArry[i] objectForKey:@"houseUrl"]];
            [self.flagArry addObject:[NSString stringWithFormat:@"%@",[returnlistArry[i] objectForKey:@"firstFlag"]]];
        }
        
    }

    self.stateArry = [[NSMutableArray alloc]init];
    
    if (self.nameArry.count > 0)
    {
        for(int i = 0;i < self.nameArry.count; i ++)
        {
            [self.stateArry addObject:@"默认"];
            if ([self.flagArry[i] isEqualToString:@"2"])
            {
                self.j = i;
            }
        }
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

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
        //删除地址接口
        NSString *addidStr = self.addIdArry[indexPath.row];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C07&addrId=%d",addidStr.intValue]];
       
        NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        NSString *returncode = [dic objectForKey:@"returnCode"];
        if([returncode isEqualToString:@"ok"])
        {
            NSLog(@"删除地址成功!");
        }
        
        [self.nameArry removeObjectAtIndex:indexPath.row];
        [self.addTelArry removeObjectAtIndex:indexPath.row];
        [self.provinceArry removeObjectAtIndex:indexPath.row];
        [self.cityArry removeObjectAtIndex:indexPath.row];
        [self.areaArry removeObjectAtIndex:indexPath.row];
        [self.villageArry removeObjectAtIndex:indexPath.row];
        [self.hourseArry removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    UINib *nib = [UINib nibWithNibName:@"GetGoodsAddressTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellID];
    GetGoodsAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.personNameLb.text = self.nameArry[indexPath.row];
    cell.telLb.text = self.addTelArry[indexPath.row];
    self.provinceStr = self.provinceArry[indexPath.row];
    self.cityStr = self.cityArry[indexPath.row];
    self.areaStr = self.areaArry[indexPath.row];
    self.villageStr = self.villageArry[indexPath.row];
    self.villageNumStr = self.hourseArry[indexPath.row];
    cell.addressLb.text = [NSString stringWithFormat:@"%@%@%@%@%@",self.provinceStr,self.cityStr,self.areaStr,self.villageStr,self.villageNumStr];
    cell.stateLb.text = self.stateArry[indexPath.row];
    
    cell.tintColor = [UIColor colorWithRed:162.0 / 255.0 green:73.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
    
    // 重用机制，如果选中的行正好要重用
    if (_index == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.stateLb.hidden = NO;
        [self.flagArry replaceObjectAtIndex:_index withObject:@"2"];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.stateLb.hidden = YES;
        [self.flagArry replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }

    NSLog(@"flagArry = %@",self.flagArry);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressManageViewController *view = [[AddressManageViewController alloc]initWithNibName:@"AddressManageViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.index = indexPath.row;
    self.index = indexPath.row;
    view.personNameTextField.text = self.nameArry[indexPath.row];
    view.telTextField.text = self.addTelArry[indexPath.row];
    NSString *proStr = self.provinceArry[indexPath.row];
    NSString *cityStr = self.cityArry[indexPath.row];
    NSString *areaStr = self.areaArry[indexPath.row];
    view.provinceTextField.text = [NSString stringWithFormat:@"%@%@%@",proStr,cityStr,areaStr];
    view.cityTextFied.text = self.villageArry[indexPath.row];
    view.areaTextField.text = self.hourseArry[indexPath.row];
    view.addidStr = self.addIdArry[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //把地址id传给增加订单接口
    del.addidStr = self.addIdArry[indexPath.row];
    
    //取消前一个选中的，就是单选啦
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
    GetGoodsAddressTableViewCell *lastCell = (GetGoodsAddressTableViewCell *)[tableView cellForRowAtIndexPath:lastIndex];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    lastCell.stateLb.hidden = YES;
    [self.flagArry replaceObjectAtIndex:lastIndex.row withObject:@"1"];
    //修改收货地址接口
    NSURL *url1=[NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C06&addrUserName=%@&addrId=%@&addrPhone=%@&proinceUrl=%@&cityUrl=%@&areaUrl=%@&villageUrl=%@&houseUrl=%@&firstFlag=1",self.nameArry[indexPath.row],self.addIdArry[indexPath.row],self.addTelArry[indexPath.row],self.provinceArry[indexPath.row],self.cityArry[indexPath.row],self.areaArry[indexPath.row],self.villageArry[indexPath.row],self.hourseArry[indexPath.row]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIHTTPRequest *requestUrl1 = [ASIHTTPRequest requestWithURL:url1];
    [requestUrl1 setDelegate:self];
    [requestUrl1 setRequestMethod:@"GET"];
    [requestUrl1 setTimeOutSeconds:60];
    [requestUrl1 setDidFinishSelector:@selector(requestSuccess3:)];
    [requestUrl1 setDidFailSelector:@selector(requestError3:)];
    [requestUrl1 startSynchronous];
    
    // 选中操作
    GetGoodsAddressTableViewCell *cell = (GetGoodsAddressTableViewCell *)[tableView  cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.stateLb.hidden = NO;
    [self.flagArry replaceObjectAtIndex:indexPath.row withObject:@"2"];
    //修改收货地址接口
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C06&addrUserName=%@&addrId=%@&addrPhone=%@&proinceUrl=%@&cityUrl=%@&areaUrl=%@&villageUrl=%@&houseUrl=%@&firstFlag=2",self.nameArry[indexPath.row],self.addIdArry[indexPath.row],self.addTelArry[indexPath.row],self.provinceArry[indexPath.row],self.cityArry[indexPath.row],self.areaArry[indexPath.row],self.villageArry[indexPath.row],self.hourseArry[indexPath.row]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess2:)];
    [requestUrl setDidFailSelector:@selector(requestError2:)];
    [requestUrl startSynchronous];

    // 保存选中的
    _index = (int)indexPath.row;

    NSLog(@"flagArry = %@",self.flagArry);

    [_tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
}

- (void)requestSuccess2:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"收货地址更新成功!");
    }
    else
    {
        NSLog(@"收货地址更新失败!");
    }
}

- (void)requestError2:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)requestSuccess3:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"收货地址更新成功!");
    }
    else
    {
        NSLog(@"收货地址更新失败!");
    }
}

- (void)requestError3:(ASIHTTPRequest *)request
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

- (IBAction)addAddresBt:(id)sender
{
    AddressViewController *view = [[AddressViewController alloc]initWithNibName:@"AddressViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
}
@end
