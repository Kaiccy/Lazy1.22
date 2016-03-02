//
//  ViewController.m
//  CountDownTimerForTableView
//
//  Created by FrankLiu on 15/9/8.
//  Copyright (c) 2015年 FrankLiu. All rights reserved.
//

#import "PanicViewController.h"
#import "CommonMacro.h"
#import "TimeCell.h"
#import "TimeModel.h"
#import "BaseTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "AppDelegate.h"
#import "SearchViewController.h"

@interface PanicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView    *m_tableView;
@property (nonatomic, strong) NSMutableArray *m_dataArray;
@property (nonatomic, strong) NSTimer        *m_timer;

@end

@implementation PanicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [_m_tableView reloadData];
    [super viewWillAppear:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    //布局
    [self layout];
    
    //初始化数组
    [self initArray];
    
    //刷新
    if (_refreshHeaderView == nil)
    {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _m_tableView.bounds.size.height, self.view.frame.size.width, _m_tableView.bounds.size.height)];
        view.delegate = self;
        [_m_tableView addSubview:view];
        _refreshHeaderView = view;
        
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];

    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(self.view.frame.size.width/2 - 50/2, self.view.frame.size.height/2 - 25, 50, 50);
    self.activity.hidesWhenStopped = YES;
    [self.view addSubview:self.activity];
    _m_tableView.hidden = YES;
    [self.activity startAnimating];
    
    //抢购商品信息接口
    NSURL *url=[NSURL URLWithString:@"http://junjuekeji.com/appServlet?requestCode=B01&displayType=2&prodType=1&panicFlag=1"];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess:)];
    [requestUrl setDidFailSelector:@selector(requestError:)];
    [requestUrl startAsynchronous];

    [self createTimer];
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    //去掉多余的线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_m_tableView setTableFooterView:v];
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:250.0 / 255.0 blue:248.0 / 255.0 alpha:1.0];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 60)];
    view.backgroundColor = [UIColor colorWithRed:162.0 / 255.0 green:73.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
    [self.view addSubview:view];
    //返回按钮
    UIButton *backBt = [[UIButton alloc]initWithFrame:CGRectMake(8, 28, 25, 25)];
    [backBt setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(backBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBt];
    //搜索按钮
    UIButton *searchBt = [[UIButton alloc]initWithFrame:CGRectMake(Width - 25 - 8, 28, 25, 25)];
    [searchBt setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [searchBt addTarget:self action:@selector(searchBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBt];
    //title
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 11, Width, 49)];
    titleLb.text = @"海鲜抢购专区";
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:titleLb];
}

- (void)initArray
{
    self.seafoodImgArry = [[NSMutableArray alloc]init];
    self.seadfoodImgNameArry = [[NSMutableArray alloc]init];
    self.nameArry = [[NSMutableArray alloc]init];
    self.priceArry = [[NSMutableArray alloc]init];
    self.seafoodPathArry = [[NSMutableArray alloc]init];
    self.seafoodImgIdArry = [[NSMutableArray alloc]init];
    self.seafoodIdArry = [[NSMutableArray alloc]init];
    self.seafoodStandArry = [[NSMutableArray alloc]init];
    self.seafoodMarketPriceArry = [[NSMutableArray alloc]init];
    self.showTimeArry = [[NSMutableArray alloc]init];
    self.m_dataArray = [[NSMutableArray alloc]init];
    self.panicStateArry = [[NSMutableArray alloc]init];
    self.panicColorArry = [[NSMutableArray alloc]init];
    self.remainTimeArry = [[NSMutableArray alloc]init];
}

- (void)requestSuccess:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"海鲜商品信息获取成功!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        [self.nameArry addObject:[returnlistArry[i] objectForKey:@"prodName"]];
        //商品ID
        [self.seafoodIdArry addObject:[NSString stringWithFormat:@"%@",[returnlistArry[i] objectForKey:@"prodId"]]];
        
        //商品相关图片（字典）当前显示的图片
        NSArray *imglistArry = [returnlistArry[i] objectForKey:@"imgList"];
        if (imglistArry.count != 0)
        {
            [self.seafoodImgIdArry addObject:[imglistArry[1] objectForKey:@"imgId"]];
            [self.seadfoodImgNameArry addObject:[imglistArry[1] objectForKey:@"imgName"]];
            [self.seafoodPathArry addObject:[imglistArry[1] objectForKey:@"imgPath"]];
        }
        else
        {
            [self.seadfoodImgNameArry addObject:@""];
        }
        
        NSArray *prodDtlListArry = [returnlistArry[i] objectForKey:@"prodDtlList"];
        //商品价格
        [self.priceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"amount"]]];
        //商品市场价格
        [self.seafoodMarketPriceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"originalAmountYuan"]]];
        //商品规格
        [self.seafoodStandArry addObject:[prodDtlListArry[0] objectForKey:@"prodStandard"]];
        
        //抢购启始时间
        NSDictionary *startTimeDic = [returnlistArry[i] objectForKey:@"panicBeginDate"];
        self.starttime = [NSString stringWithFormat: @"%@",[startTimeDic objectForKey:@"time"]];
        self.starttime = [self.starttime substringToIndex:10];
        //抢购结束时间
        //时间戳转时间的方法:
        NSDictionary *endTimeDic = [returnlistArry[i] objectForKey:@"panicEndDate"];
        self.endtime = [NSString stringWithFormat: @"%@",[endTimeDic objectForKey:@"time"]];
        self.endtime = [self.endtime substringToIndex:10];
        NSLog(@"endtime = %@",self.endtime);
        
        NSDate *confromTimesp1 = [NSDate dateWithTimeIntervalSince1970:self.starttime.intValue + 480];
        NSLog(@"confromTimesp1 = %@",confromTimesp1);
        
        NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:self.endtime.intValue + 480];
        NSLog(@"confromTimesp2 = %@",confromTimesp2);
        
        //开始时间获取
        NSDate *date = [NSDate date] ;
        //把当前时间转化成时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        NSLog(@"timeSp:%@",timeSp);
        
        //总时间设置
        self.totalTime = self.endtime.intValue + 480 - timeSp.intValue;
        //时间间隔
        double time = [[NSDate date] timeIntervalSinceDate:date];
       
        self.remainTime = self.totalTime - time;
        
        [self.remainTimeArry addObject:[NSNumber numberWithDouble:self.remainTime]];
        if (self.remainTime < 0.0)
        {
            [self.showTimeArry addObject:@"0:0:0"];
            [self.panicStateArry addObject:@"抢购结束"];
            [self.panicColorArry addObject:[UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0]];
        }
        else
        {
            [self showTime:self.remainTime];
            
        }
        
    }
    
    //请求图片
    for (int i = 0; i < self.seadfoodImgNameArry.count; i++)
    {
        if ([self.seadfoodImgNameArry[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.seadfoodImgNameArry[i]]]]];
            [self.seafoodImgArry addObject:img];
            self.j = i;
        }
        else
        {
            [self.seafoodImgArry addObject:[UIImage imageNamed:@"moren.png"]];
            
        }
        
    }
    
    for (int i = 0; i < self.nameArry.count; i++)
    {
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
        NSString *priceStr1 = self.priceArry[i];
        NSString *price1 = [NSString stringWithFormat:@"¥ %.2f",priceStr1.floatValue / 100];
        [infoDict setValue:self.nameArry[i] forKey:@"goodsTitle"];
        [infoDict setValue:price1 forKey:@"goodsPrice"];
        [infoDict setValue:self.seafoodIdArry[i] forKey:@"goodsId"];
        [infoDict setValue:self.showTimeArry[i] forKey:@"count"];
        //封装数据模型
        TimeModel *goodsModel = [[TimeModel alloc]initWithDict:infoDict];
        
        //将数据模型放入数组中
        [_m_dataArray addObject:goodsModel];
    }

    [self.activity stopAnimating];
    _m_tableView.hidden = NO;
    [_m_tableView reloadData];
    
}

- (void)showTime:(double)time
{
    NSString *str = [NSString stringWithFormat:@"%lf",time];
    [self.showTimeArry addObject:str];
    [self.panicStateArry addObject:@"立即抢购"];
    [self.panicColorArry addObject:[UIColor colorWithRed:162.0 / 255.0 green:73.0 / 255.0 blue:200.0 / 255.0 alpha:1.0]];
}

- (void)requestError:(ASIHTTPRequest *)request
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_m_tableView];
    
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

- (void)createTimer
{
    
   self.m_timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_m_timer forMode:NSRunLoopCommonModes];
}

- (void)timerEvent
{
    
    for (int count = 0; count < _m_dataArray.count; count++)
    {
        
        TimeModel *model = _m_dataArray[count];
        [model countDown];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:nil];
}

#pragma mark - TableView

- (void)initTableView
{
    
    self.m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60,Width, Height)];
    [self.view addSubview:_m_tableView];
    
    _m_tableView.delegate       = self;
    _m_tableView.dataSource     = self;

    [_m_tableView registerClass:[TimeCell class] forCellReuseIdentifier:TIME_CELL];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.nameArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    BaseTableViewCell * cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:TIME_CELL];
    
    TimeModel * model = _m_dataArray[indexPath.row];
    
    [cell loadData:model indexPath:indexPath];
    
    //图片
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120 / 2 - 30, 60, 60)];
    [cell addSubview:imgView];
    imgView.image = self.seafoodImgArry[indexPath.row];
    
    //立即抢购
    UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(Width - 150, 85, 60, 20)];
    [cell addSubview:lb2];
    
    lb2.textColor = [UIColor whiteColor];
    lb2.backgroundColor = [UIColor colorWithRed:162.0 / 255.0 green:73.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
    lb2.textAlignment = NSTextAlignmentCenter;
    lb2.text = self.panicStateArry[indexPath.row];
    lb2.backgroundColor = self.panicColorArry[indexPath.row];
    lb2.font = [UIFont systemFontOfSize:11.0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.index = indexPath.row;
    
    del.goodsId = self.seafoodIdArry[indexPath.row];
    //通知中心 输入所要发送的信息 ，同时将label的值通过button方法调用传递，
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:del.goodsId,@"textOne", nil];
    //创建通知  (发送多个通知)
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"seaId = %@",del.goodsId);
    GoodsDetailViewController *detailView = [[GoodsDetailViewController alloc]init];
    [self presentViewController:detailView animated:YES completion:nil];
    
    //如果限时抢购产品时间结束  就不能购买和加入购物车
    NSString *str = self.remainTimeArry[indexPath.row];
    if (str.doubleValue < 0.0)
    {
        detailView.addShoppingCarBt.enabled = NO;
        detailView.rightnowBuy.enabled = NO;
        detailView.addShoppingCarBt.backgroundColor = [UIColor grayColor];
        detailView.rightnowBuy.backgroundColor = [UIColor grayColor];
        detailView.addbt.enabled = NO;
        detailView.minusBt.enabled = NO;
    }
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BaseTableViewCell *tmpCell = (BaseTableViewCell *)cell;
    tmpCell.isDisplayed = YES;
    
    [tmpCell loadData:_m_dataArray[indexPath.row] indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    BaseTableViewCell *tmpCell = (BaseTableViewCell *)cell;
    
    tmpCell.isDisplayed = NO;
}

- (void)backBtAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//搜索
- (void)searchBtAction:(id)sender
{
    SearchViewController *view = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
}

@end
