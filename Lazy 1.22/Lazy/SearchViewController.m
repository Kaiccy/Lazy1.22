//
//  SearchViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/13.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "SearchViewController.h"
#import "GoodsDetailViewController.h"
#import "SearchTableViewCell.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableview reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //数组初始化
    [self initArray];
    
    //所有商品信息接口
    NSURL *url=[NSURL URLWithString:@"http://junjuekeji.com/appServlet?requestCode=B01&displayType=0&prodType=0&panicFlag=0"];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess:)];
    [requestUrl setDidFailSelector:@selector(requestError:)];
    [requestUrl startAsynchronous];

    self.isAdd = YES;
    
    //刷新
    if (_refreshHeaderView == nil)
    {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableview.bounds.size.height, self.view.frame.size.width, self.tableview.bounds.size.height)];
        view.delegate = self;
        [self.tableview addSubview:view];
        _refreshHeaderView = view;
        
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    
    self.search.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
}

- (void)layout
{
    //屏幕适配
    self.view.frame = [[UIScreen mainScreen]bounds];
    
    self.titleLb.frame = CGRectMake(0, 0, self.view.frame.size.width, 75);
    //去掉多余的分割线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableview setTableFooterView:v];
}

- (void)initArray
{
    self.goodsIdArry = [[NSMutableArray alloc] init];
    self.goodsImgArry = [[NSMutableArray alloc] init];
    self.goodsImgNameArry = [[NSMutableArray alloc] init];
    self.goodsPriceArry = [[NSMutableArray alloc] init];
    self.goodsStandArry = [[NSMutableArray alloc] init];
    self.idArry = [[NSMutableArray alloc] init];
    self.dtlIdArry = [[NSMutableArray alloc] init];
    
    self.allGoodsArry = [[NSMutableArray alloc] init];
    self.emptyArry = [[NSMutableArray alloc] init];
    self.remainTimeArry = [[NSMutableArray alloc] init];
    self.tempArry = [[NSMutableArray alloc] init];
}

//请求成功
- (void)requestSuccess:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"所有信息获取成功!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        [self.allGoodsArry addObject:[returnlistArry[i] objectForKey:@"prodName"]];
        //商品ID
        [self.goodsIdArry addObject:[NSString stringWithFormat:@"%@",[returnlistArry[i] objectForKey:@"prodId"]]];
        
        //商品相关图片（字典）当前显示的图片
        NSArray *imglistArry = [returnlistArry[i] objectForKey:@"imgList"];
        if (imglistArry.count != 0)
        {
            [self.goodsImgNameArry addObject:[imglistArry[1] objectForKey:@"imgName"]];
        }
        else
        {
            [self.goodsImgNameArry addObject:@""];
        }
        
        NSArray *prodDtlListArry = [returnlistArry[i] objectForKey:@"prodDtlList"];
        //商品价格
        [self.goodsPriceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"amount"]]];
        NSString *dtlidStr = [prodDtlListArry[0] objectForKey:@"dtlId"];
        //商品明细
        [self.dtlIdArry addObject:dtlidStr];
        //商品规格
        [self.goodsStandArry addObject:[prodDtlListArry[0] objectForKey:@"prodStandard"]];
        
        NSString *panicStr = [NSString stringWithFormat:@"%@",[returnlistArry[i] objectForKey:@"panicFlag"]];
        //抢购结束时间
        //时间戳转时间的方法:
        NSDictionary *endTimeDic = [returnlistArry[i] objectForKey:@"panicEndDate"];
        
        if (panicStr.intValue == 1)//如果是抢购商品
        {
            NSString *endtime = [NSString stringWithFormat: @"%@",[endTimeDic objectForKey:@"time"]];
            endtime = [endtime substringToIndex:10];
            NSDate *now = [NSDate date];
            //把当前时间转化成时间戳
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
            NSLog(@"timeSp:%@",timeSp);
            
            NSString *timeStr = endtime;
            
            //总时间设置
            int total = timeStr.intValue + 480 - timeSp.intValue;
            double time = [[NSDate date] timeIntervalSinceDate:now];
            double remainTime = total - time;
            if (remainTime < 0.0)
            {
                [self.remainTimeArry addObject:@"NO"];
            }
            else
            {
                [self.remainTimeArry addObject:@"YES"];
            }
        }
        else
        {
            [self.remainTimeArry addObject:@"YES"];
        }

    }
    
    //重置数组
    [self.emptyArry setArray:self.allGoodsArry];
    
    //请求图片
    for (int i = 0; i < self.goodsImgNameArry.count; i++)
    {
        if ([self.goodsImgNameArry[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.goodsImgNameArry[i]]]]];
            [self.goodsImgArry addObject:img];
            
        }
        else
        {
            [self.goodsImgArry addObject:[UIImage imageNamed:@"moren.png"]];
        }
    }
    
}

//请求失败
- (void)requestError:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData
{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableview];
    
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark - 搜索内容列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    return self.allGoodsArry.count;
    return self.tempArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UINib *nib = [UINib nibWithNibName:@"SearchTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellID];
    SrarchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.goosnameLb.text = self.tempArry[indexPath.row];
    cell.goodsImgView.image = self.goodsImgArry[indexPath.row];
    NSString *priceStr = self.goodsPriceArry[indexPath.row];
    cell.goodsPriceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
    cell.standardLb.text = self.goodsStandArry[indexPath.row];
    
    //添加购买按钮
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 30, 25, 25)];
    [self.btn setImage:[UIImage imageNamed:@"shoppingcar2.png"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:self.btn];
    return cell;
}
- (void)btnAction:(UIButton *)bt
{
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    SrarchTableViewCell *cell = (SrarchTableViewCell *)[bt superview];
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NSLog(@"indexPath is = %li",(long)indexPath.row);
    
    [self getShoppingCarInfo];//获取购物车信息
    //遍历数组
    for (int i = 0; i < self.idArry.count; i ++)
    {
        NSString *idStr = self.idArry[i];
        NSString *selectIdStr = self.goodsIdArry[indexPath.row];
        if (selectIdStr.intValue == idStr.intValue)
        {
            
            self.isAdd = NO;
        }
    }
    
    if (self.isAdd == YES)
    {
        NSString *proid = self.goodsIdArry[indexPath.row];
        NSString *dtlid = self.dtlIdArry[indexPath.row];
        //增加购物车接口
        NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
        ASIFormDataRequest *requestUrl = [ASIFormDataRequest requestWithURL:url2];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess2:)];
        [requestUrl setDidFailSelector:@selector(requestError2:)];
        [requestUrl startSynchronous];

    }

}

//请求成功
- (void)requestSuccess2:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
}

//请求失败
- (void)requestError2:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.goodsId = self.goodsIdArry[indexPath.row];
    //通知中心 输入所要发送的信息 ，同时将label的值通过button方法调用传递，
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:del.goodsId,@"textOne", nil];
    //创建通知  (发送多个通知)
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"seaId = %@",del.goodsId);
    GoodsDetailViewController *view = [[GoodsDetailViewController alloc]init];
    [self presentViewController:view animated:YES completion:nil];
    
    //如果限时抢购产品时间结束  就不能购买和加入购物车
    if ([self.remainTimeArry[indexPath.row] isEqualToString:@"NO"])
    {
        view.addShoppingCarBt.enabled = NO;
        view.rightnowBuy.enabled = NO;
        view.addShoppingCarBt.backgroundColor = [UIColor grayColor];
        view.rightnowBuy.backgroundColor = [UIColor grayColor];
        view.addbt.enabled = NO;
        view.minusBt.enabled = NO;
    }

}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.allGoodsArry removeAllObjects];
    if (self.search.text.length != 0)
    {
        for (int i = 0; i < self.emptyArry.count; i ++)
        {
            if ([self.emptyArry[i] hasPrefix:self.search.text])
            {
                [self.allGoodsArry addObject:self.emptyArry[i]];
            }
        }
        [self.tempArry setArray:self.allGoodsArry];
        [self.tableview reloadData];
    }
    else
    {
        for (int j = 0; j < self.allGoodsArry.count; j ++)
        {
            [self.allGoodsArry addObject:self.emptyArry[j]];
        }
        [self.tempArry setArray:self.allGoodsArry];
        [self.tableview reloadData];
    }
}

- (void)getShoppingCarInfo
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //获取用户购物车接口
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C04&loginName=%@",del.User]];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess3:)];
    [requestUrl setDidFailSelector:@selector(requestError3:)];
    [requestUrl startAsynchronous];
    
}

//请求成功
- (void)requestSuccess3:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"%@",dic);
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        NSDictionary *carDic = [returnlistArry[i] objectForKey:@"cart"];
        //商品ID
        [self.idArry addObject:[NSString stringWithFormat:@"%@",[carDic objectForKey:@"prodId"]]];
    }

}

//请求失败
- (void)requestError3:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [self.search resignFirstResponder];
//}

- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
