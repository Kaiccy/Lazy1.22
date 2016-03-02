//
//  VegetablesViewController.m
//  Lazy
//
//  Created by yinqijie on 15/9/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "VegetablesViewController.h"
#import "AppDelegate.h"
#import "GoodsDetailViewController.h"
#import "VegetablesTableViewCell.h"
#import "SearchViewController.h"

@interface VegetablesViewController ()

@end

@implementation VegetablesViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //初始化数组
    [self initArry];
    
    //请求
    [self netAskFunction];
    
    self.isAdd = YES;
    //刷新
    if (_refreshHeaderView == nil)
    {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    
    //签代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(self.view.frame.size.width/2 - 50/2, self.view.frame.size.height/2 - 25, 50, 50);
    self.activity.hidesWhenStopped = YES;
    [self.view addSubview:self.activity];
    [self.activity startAnimating];
    self.tableView.hidden = YES;
    
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];

    //去掉多余的分割线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];

    //提示加载失败
    self.lb = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 2 - 30, 200, 60)];
    self.lb.textAlignment = NSTextAlignmentCenter;
    self.lb.font = [UIFont systemFontOfSize:17];
    self.lb.numberOfLines = 2;
    self.lb.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    self.lb.text = @"加载失败,请检查您的网络环境!";
    
    //提示是否已经加入购车
    self.isAddLb = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height - 100, 100, 30)];
    [self.view addSubview:self.isAddLb];
    self.isAddLb.textAlignment = NSTextAlignmentCenter;
    self.isAddLb.textColor = [UIColor whiteColor];
    self.isAddLb.backgroundColor = [UIColor grayColor];
    self.isAddLb.layer.cornerRadius = 15.0;
    self.isAddLb.layer.masksToBounds = YES;
    self.isAddLb.font = [UIFont systemFontOfSize:12.0];
    self.isAddLb.hidden = YES;
}

- (void)importAnimation
{
    self.isAddLb.hidden = NO;
    //渐进模糊动画
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = 1;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.isAddLb.layer addAnimation:animation forKey:@"animation"];

}
- (void)initArry
{
    self.goodsImgArry1 = [[NSMutableArray alloc]init];
    self.goodsImgArry2 = [[NSMutableArray alloc]init];
    self.goodsImgArry3 = [[NSMutableArray alloc]init];
    
    self.goodsNameArry1 = [[NSMutableArray alloc]init];
    self.goodsNameArry3 = [[NSMutableArray alloc]init];
    self.goodsNameArry2 = [[NSMutableArray alloc]init];
    
    self.goodsPriceArry1 = [[NSMutableArray alloc]init];
    self.goodsPriceArry2 = [[NSMutableArray alloc]init];
    self.goodsPriceArry3 = [[NSMutableArray alloc]init];
    
    self.vegetablesImgNameArry1 = [[NSMutableArray alloc]init];
    self.vegetablesImgNameArry2 = [[NSMutableArray alloc]init];
    self.vegetablesImgNameArry3 = [[NSMutableArray alloc]init];
    
    self.vegetablesImgPathArry1 = [[NSMutableArray alloc]init];
    self.vegetablesImgPathArry2 = [[NSMutableArray alloc]init];
    self.vegetablesImgPathArry3 = [[NSMutableArray alloc]init];
    
    self.vegetablesImgIdArry1 = [[NSMutableArray alloc]init];
    self.vegetablesImgIdArry2 = [[NSMutableArray alloc]init];
    self.vegetablesImgIdArry3 = [[NSMutableArray alloc]init];
    
    self.vegetablesIdArry1 = [[NSMutableArray alloc]init];
    self.vegetablesIdArry2 = [[NSMutableArray alloc]init];
    self.vegetablesIdArry3 = [[NSMutableArray alloc]init];
    
    self.vegetableStandArry1 = [[NSMutableArray alloc]init];
    self.vegetableStandArry2 = [[NSMutableArray alloc]init];
    self.vegetableStandArry3 = [[NSMutableArray alloc]init];
    
    self.dtlIdArry1 = [[NSMutableArray alloc]init];
    self.dtlIdArry2 = [[NSMutableArray alloc]init];
    self.dtlIdArry3 = [[NSMutableArray alloc]init];
    self.idArry = [[NSMutableArray alloc]init];

    
}

- (void)netAskFunction
{
    //果蔬商品信息接口
    NSURL *url=[NSURL URLWithString:@"http://junjuekeji.com/appServlet?requestCode=B01&displayType=2&prodType=5&panicFlag=2"];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess1:)];
    [requestUrl setDidFailSelector:@selector(requestError1:)];
    [requestUrl startAsynchronous];

    //酒类商品信息接口
    NSURL *url2=[NSURL URLWithString:@"http://junjuekeji.com/appServlet?requestCode=B01&displayType=2&prodType=2&panicFlag=2"];
    
    ASIHTTPRequest *requestUrl2 = [ASIHTTPRequest requestWithURL:url2];
    [requestUrl2 setDelegate:self];
    [requestUrl2 setRequestMethod:@"GET"];
    [requestUrl2 setTimeOutSeconds:60];
    [requestUrl2 setDidFinishSelector:@selector(requestSuccess2:)];
    [requestUrl2 setDidFailSelector:@selector(requestError2:)];
    [requestUrl2 startAsynchronous];

    //大米商品信息接口
    NSURL *url3=[NSURL URLWithString:@"http://junjuekeji.com/appServlet?requestCode=B01&displayType=2&prodType=4&panicFlag=2"];
    
    ASIHTTPRequest *requestUrl3 = [ASIHTTPRequest requestWithURL:url3];
    [requestUrl3 setDelegate:self];
    [requestUrl3 setRequestMethod:@"GET"];
    [requestUrl3 setTimeOutSeconds:60];
    [requestUrl3 setDidFinishSelector:@selector(requestSuccess3:)];
    [requestUrl3 setDidFailSelector:@selector(requestError3:)];
    [requestUrl3 startAsynchronous];

    
}

- (void)requestSuccess1:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"商品1信息获取成功!");
    }
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        [self.goodsNameArry1 addObject:[returnlistArry[i] objectForKey:@"prodName"]];
        //商品ID
        [self.vegetablesIdArry1 addObject:[returnlistArry[i] objectForKey:@"prodId"]];
        
        //商品相关图片（字典）当前显示的图片
        NSArray *imglistArry = [returnlistArry[i] objectForKey:@"imgList"];
        if (imglistArry.count != 0)
        {
            [self.vegetablesImgIdArry1 addObject:[imglistArry[1] objectForKey:@"imgId"]];
            [self.vegetablesImgNameArry1 addObject:[imglistArry[1] objectForKey:@"imgName"]];
            [self.vegetablesImgPathArry1 addObject:[imglistArry[1] objectForKey:@"imgPath"]];
        }
        else
        {
            [self.vegetablesImgNameArry1 addObject:@""];
        }
        NSArray *prodDtlListArry = [returnlistArry[i] objectForKey:@"prodDtlList"];
        //商品价格
        [self.goodsPriceArry1 addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"amount"]]];
        NSString *dtlidStr = [prodDtlListArry[0] objectForKey:@"dtlId"];
        //商品明细
        [self.dtlIdArry1 addObject:dtlidStr];
        //商品规格
        [self.vegetableStandArry1 addObject:[prodDtlListArry[0] objectForKey:@"prodStandard"]];
    }
    //请求图片
    for (int i = 0; i < self.vegetablesImgNameArry1.count; i++)
    {
        if ([self.vegetablesImgNameArry1[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.vegetablesImgNameArry1[i]]]]];
            [self.goodsImgArry1 addObject:img];
            
        }
        else
        {
            [self.goodsImgArry1 addObject:[UIImage imageNamed:@"moren.png"]];
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

        [self.activity stopAnimating];
        [self.view addSubview:self.lb];
    }

}

- (void)requestSuccess2:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString *returncode2 = [dic2 objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic2 objectForKey:@"returnList"];
    
    if([returncode2 isEqualToString:@"ok"])
    {
        NSLog(@"商品2信息获取成功!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        [self.goodsNameArry2 addObject:[returnlistArry[i] objectForKey:@"prodName"]];
        //商品ID
        [self.vegetablesIdArry2 addObject:[returnlistArry[i] objectForKey:@"prodId"]];
        
        //商品相关图片（字典）当前显示的图片
        NSArray *imglistArry = [returnlistArry[i] objectForKey:@"imgList"];
        if (imglistArry.count != 0)
        {
            [self.vegetablesImgIdArry2 addObject:[imglistArry[1] objectForKey:@"imgId"]];
            [self.vegetablesImgNameArry2 addObject:[imglistArry[1] objectForKey:@"imgName"]];
            [self.vegetablesImgPathArry2 addObject:[imglistArry[1] objectForKey:@"imgPath"]];
        }
        else
        {
            [self.vegetablesImgNameArry2 addObject:@""];
        }
        
        NSArray *prodDtlListArry = [returnlistArry[i] objectForKey:@"prodDtlList"];
        //商品价格
        [self.goodsPriceArry2 addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"amount"]]];
        NSString *dtlidStr = [prodDtlListArry[0] objectForKey:@"dtlId"];
        //商品明细
        [self.dtlIdArry2 addObject:dtlidStr];
        //商品规格
        [self.vegetableStandArry2 addObject:[prodDtlListArry[0] objectForKey:@"prodStandard"]];
    }
    
    //请求图片
    for (int i = 0; i < self.vegetablesImgNameArry2.count; i++)
    {
        if ([self.vegetablesImgNameArry2[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.vegetablesImgNameArry2[i]]]]];
            [self.goodsImgArry2 addObject:img];
            
        }
        else
        {
            [self.goodsImgArry2 addObject:[UIImage imageNamed:@"moren.png"]];
        }
    }
    [self.activity stopAnimating];
    self.tableView.hidden = NO;
    [self.tableView reloadData];

}

- (void)requestError2:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
    if ([[error localizedDescription] isEqualToString:@"A connection failure occurred"])
    {
        [self.activity stopAnimating];
        [self.view addSubview:self.lb];
    }

}

- (void)requestSuccess3:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic3 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSString *returncode3 = [dic3 objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic3 objectForKey:@"returnList"];
    
    if([returncode3 isEqualToString:@"ok"])
    {
        NSLog(@"商品3信息获取成功!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        [self.goodsNameArry3 addObject:[returnlistArry[i] objectForKey:@"prodName"]];
        //商品ID
        [self.vegetablesIdArry3 addObject:[returnlistArry[i] objectForKey:@"prodId"]];
        
        //商品相关图片（字典）当前显示的图片
        NSArray *imglistArry = [returnlistArry[i] objectForKey:@"imgList"];
        if (imglistArry.count != 0)
        {
            [self.vegetablesImgIdArry3 addObject:[imglistArry[1] objectForKey:@"imgId"]];
            [self.vegetablesImgNameArry3 addObject:[imglistArry[1] objectForKey:@"imgName"]];
            [self.vegetablesImgPathArry3 addObject:[imglistArry[1] objectForKey:@"imgPath"]];
        }
        else
        {
            [self.vegetablesImgNameArry3 addObject:@""];
        }
        
        NSArray *prodDtlListArry = [returnlistArry[i] objectForKey:@"prodDtlList"];
        //商品价格
        [self.goodsPriceArry3 addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"amount"]]];
        NSString *dtlidStr = [prodDtlListArry[0] objectForKey:@"dtlId"];
        //商品明细
        [self.dtlIdArry3 addObject:dtlidStr];
        //商品规格
        [self.vegetableStandArry3 addObject:[prodDtlListArry[0] objectForKey:@"prodStandard"]];
    }
    
    //请求图片
    for (int i = 0; i < self.vegetablesImgNameArry3.count; i++)
    {
        if ([self.vegetablesImgNameArry3[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.vegetablesImgNameArry3[i]]]]];
            [self.goodsImgArry3 addObject:img];
            
        }
        else
        {
            [self.goodsImgArry3 addObject:[UIImage imageNamed:@"moren.png"]];
            
        }
    }

    [self.activity stopAnimating];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)requestError3:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
    if ([[error localizedDescription] isEqualToString:@"A connection failure occurred"])
    {
        [self.activity stopAnimating];
        [self.view addSubview:self.lb];
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
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

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}



#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([del.tempArry[0] isEqualToString:@"酒类"])
    {
        if (section == 0)
        {
            return self.goodsNameArry3.count;
        }
        else if(section == 1)
        {
            return self.goodsNameArry1.count;
        }
        else
        {
            return self.goodsNameArry2.count;
        }

    }
    else if ([del.tempArry[0] isEqualToString:@"生蔬类"])
    {
        if (section == 0)
        {
            return self.goodsNameArry1.count;
        }
        else if(section == 1)
        {
            return self.goodsNameArry3.count;
        }
        else
        {
            return self.goodsNameArry2.count;
        }

    }
    else
    {
        if (section == 0)
        {
            return self.goodsNameArry2.count;
        }
        else if(section == 1)
        {
            return self.goodsNameArry3.count;
        }
        else
        {
            return self.goodsNameArry1.count;
        }

    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//设置标题头的名称
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    if (section == 0)
//    {
//        return del.tempArry[0];
//    }
//    else if(section == 1)
//    {
//        return del.tempArry[1];
//    }
//    else
//        return del.tempArry[2];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    static NSString *cellID = @"cellID";
    UINib *nib = [UINib nibWithNibName:@"VegetablesTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellID];
    VegetablesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    //添加购买按钮
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 30, 25, 25)];
    [self.btn setImage:[UIImage imageNamed:@"shoppingcar2.png"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:self.btn];
    if ([del.tempArry[0] isEqualToString:@"酒类"])
    {
        if(indexPath.section == 0)
        {
            cell.goodsImg.image = self.goodsImgArry3[indexPath.row];
            cell.nameLb.text = self.goodsNameArry3[indexPath.row];
            NSString *priceStr = self.goodsPriceArry3[indexPath.row];
            cell.priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
            cell.goodsId = self.vegetablesIdArry3[indexPath.row];
            cell.standLb.text = self.vegetableStandArry3[indexPath.row];
            cell.dtlId = self.dtlIdArry3[indexPath.row];
        }
        else if (indexPath.section == 1)
        {
            cell.goodsImg.image = self.goodsImgArry1[indexPath.row];
            cell.nameLb.text = self.goodsNameArry1[indexPath.row];
            NSString *priceStr = self.goodsPriceArry1[indexPath.row];
            cell.priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
            cell.goodsId = self.vegetablesIdArry1[indexPath.row];
            cell.standLb.text = self.vegetableStandArry1[indexPath.row];
            cell.dtlId = self.dtlIdArry1[indexPath.row];

        }
        else
        {
            cell.goodsImg.image = self.goodsImgArry2[indexPath.row];
            cell.nameLb.text = self.goodsNameArry2[indexPath.row];
            NSString *priceStr = self.goodsPriceArry2[indexPath.row];
            cell.priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
            cell.goodsId = self.vegetablesIdArry2[indexPath.row];
            cell.standLb.text = self.vegetableStandArry2[indexPath.row];
            cell.dtlId = self.dtlIdArry2[indexPath.row];

        }
        
    }
    else if ([del.tempArry[0] isEqualToString:@"生蔬类"])
    {
        if(indexPath.section == 0)
        {
            cell.goodsImg.image = self.goodsImgArry1[indexPath.row];
            cell.nameLb.text = self.goodsNameArry1[indexPath.row];
            NSString *priceStr = self.goodsPriceArry1[indexPath.row];
            cell.priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
            cell.goodsId = self.vegetablesIdArry1[indexPath.row];
            cell.standLb.text = self.vegetableStandArry1[indexPath.row];
            cell.dtlId = self.dtlIdArry1[indexPath.row];

        }
        else if (indexPath.section == 1)
        {
            cell.goodsImg.image = self.goodsImgArry3[indexPath.row];
            cell.nameLb.text = self.goodsNameArry3[indexPath.row];
            NSString *priceStr = self.goodsPriceArry3[indexPath.row];
            cell.priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
            cell.goodsId = self.vegetablesIdArry3[indexPath.row];
            cell.standLb.text = self.vegetableStandArry3[indexPath.row];
            cell.dtlId = self.dtlIdArry3[indexPath.row];

        }
        else
        {
            cell.goodsImg.image = self.goodsImgArry2[indexPath.row];
            cell.nameLb.text = self.goodsNameArry2[indexPath.row];
            NSString *priceStr = self.goodsPriceArry2[indexPath.row];
            cell.priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
            cell.goodsId = self.vegetablesIdArry2[indexPath.row];
            cell.standLb.text = self.vegetableStandArry2[indexPath.row];
            cell.dtlId = self.dtlIdArry2[indexPath.row];

        }
        
    }
    else
    {
        if(indexPath.section == 0)
        {
            cell.goodsImg.image = self.goodsImgArry2[indexPath.row];
            cell.nameLb.text = self.goodsNameArry2[indexPath.row];
            NSString *priceStr = self.goodsPriceArry2[indexPath.row];
            cell.priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
            cell.goodsId = self.vegetablesIdArry2[indexPath.row];
            cell.standLb.text = self.vegetableStandArry2[indexPath.row];
            cell.dtlId = self.dtlIdArry2[indexPath.row];

        }
        else if (indexPath.section == 1)
        {
            cell.goodsImg.image = self.goodsImgArry3[indexPath.row];
            cell.nameLb.text = self.goodsNameArry3[indexPath.row];
            NSString *priceStr = self.goodsPriceArry3[indexPath.row];
            cell.priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
            cell.goodsId = self.vegetablesIdArry3[indexPath.row];
            cell.standLb.text = self.vegetableStandArry3[indexPath.row];
            cell.dtlId = self.dtlIdArry3[indexPath.row];

        }
        else
        {
            cell.goodsImg.image = self.goodsImgArry1[indexPath.row];
            cell.nameLb.text = self.goodsNameArry1[indexPath.row];
            NSString *priceStr = self.goodsPriceArry1[indexPath.row];
            cell.priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
            cell.goodsId = self.vegetablesIdArry1[indexPath.row];
            cell.standLb.text = self.vegetableStandArry1[indexPath.row];
            cell.dtlId = self.dtlIdArry1[indexPath.row];
        
        }
        
    }
    
    return cell;
}
- (void)btnAction:(UIButton *)bt
{
 
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    VegetablesTableViewCell *cell = (VegetablesTableViewCell *)[bt superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"indexPath is = %li",(long)indexPath.row);
    NSLog(@"section is = %li",(long)indexPath.section);
    [self getShoppingCarInfo];//获取购物车信息
   
    if ([del.tempArry[0] isEqualToString:@"酒类"])
    {
        if(indexPath.section == 0)
        {
            //遍历数组
            for (int i = 0; i < self.idArry.count; i ++)
            {
                NSString *idStr = self.idArry[i];
                NSString *selectIdStr = self.vegetablesIdArry3[indexPath.row];
                if (selectIdStr.intValue == idStr.intValue)
                {
                    
                    self.isAdd = NO;
                    self.isAddLb.text = @"购物车存在该商品";
                    [self importAnimation];
                }
            }

            if (self.isAdd == YES)
            {
                NSString *proid = self.vegetablesIdArry3[indexPath.row];
                NSString *dtlid = self.dtlIdArry3[indexPath.row];
                //增加购物车接口
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
                //jason解析
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url2];
                NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                self.isAddLb.text = @"添加成功";
                [self importAnimation];
            }

        }
        else if (indexPath.section == 1)
        {
            //遍历数组
            for (int i = 0; i < self.idArry.count; i ++)
            {
                NSString *idStr = self.idArry[i];
                NSString *selectIdStr = self.vegetablesIdArry1[indexPath.row];
                if (selectIdStr.intValue == idStr.intValue)
                {
                    
                    self.isAdd = NO;
                    self.isAddLb.text = @"购物车存在该商品";
                    [self importAnimation];

                }
            }
            
            if (self.isAdd == YES)
            {
                NSString *proid = self.vegetablesIdArry1[indexPath.row];
                NSString *dtlid = self.dtlIdArry1[indexPath.row];
                //增加购物车接口
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
                //jason解析
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url2];
                NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                self.isAddLb.text = @"添加成功";
                [self importAnimation];

            }

            
        }
        else
        {
            //遍历数组
            for (int i = 0; i < self.idArry.count; i ++)
            {
                NSString *idStr = self.idArry[i];
                NSString *selectIdStr = self.vegetablesIdArry2[indexPath.row];
                if (selectIdStr.intValue == idStr.intValue)
                {
                    
                    self.isAdd = NO;
                    self.isAddLb.text = @"购物车存在该商品";
                    [self importAnimation];

                }
            }
            
            if (self.isAdd == YES)
            {
                NSString *proid = self.vegetablesIdArry2[indexPath.row];
                NSString *dtlid = self.dtlIdArry2[indexPath.row];
                //增加购物车接口
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
                //jason解析
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url2];
                NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                self.isAddLb.text = @"添加成功";
                [self importAnimation];

            }

        }
        
    }
    else if ([del.tempArry[0] isEqualToString:@"生蔬类"])
    {
        if(indexPath.section == 0)
        {
            //遍历数组
            for (int i = 0; i < self.idArry.count; i ++)
            {
                NSString *idStr = self.idArry[i];
                NSString *selectIdStr = self.vegetablesIdArry1[indexPath.row];
                if (selectIdStr.intValue == idStr.intValue)
                {
                    
                    self.isAdd = NO;
                    self.isAddLb.text = @"购物车存在该商品";
                    [self importAnimation];

                }
            }
            
            if (self.isAdd == YES)
            {
                NSString *proid = self.vegetablesIdArry1[indexPath.row];
                NSString *dtlid = self.dtlIdArry1[indexPath.row];
                //增加购物车接口
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
                //jason解析
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url2];
                NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                self.isAddLb.text = @"添加成功";
                [self importAnimation];

            }

            
        }
        else if (indexPath.section == 1)
        {
            //遍历数组
            for (int i = 0; i < self.idArry.count; i ++)
            {
                NSString *idStr = self.idArry[i];
                NSString *selectIdStr = self.vegetablesIdArry3[indexPath.row];
                if (selectIdStr.intValue == idStr.intValue)
                {
                    
                    self.isAdd = NO;
                    self.isAddLb.text = @"购物车存在该商品";
                    [self importAnimation];

                }
            }
            
            if (self.isAdd == YES)
            {
                NSString *proid = self.vegetablesIdArry3[indexPath.row];
                NSString *dtlid = self.dtlIdArry3[indexPath.row];
                //增加购物车接口
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
                //jason解析
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url2];
                NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                self.isAddLb.text = @"添加成功";
                [self importAnimation];

            }

        }
        else
        {
            //遍历数组
            for (int i = 0; i < self.idArry.count; i ++)
            {
                NSString *idStr = self.idArry[i];
                NSString *selectIdStr = self.vegetablesIdArry2[indexPath.row];
                if (selectIdStr.intValue == idStr.intValue)
                {
                    
                    self.isAdd = NO;
                    self.isAddLb.text = @"购物车存在该商品";
                    [self importAnimation];

                }
            }
            
            if (self.isAdd == YES)
            {
                NSString *proid = self.vegetablesIdArry2[indexPath.row];
                NSString *dtlid = self.dtlIdArry2[indexPath.row];
                //增加购物车接口
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
                //jason解析
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url2];
                NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                self.isAddLb.text = @"添加成功";
                [self importAnimation];

            }

        }
        
    }
    else
    {
        if(indexPath.section == 0)
        {
            //遍历数组
            for (int i = 0; i < self.idArry.count; i ++)
            {
                NSString *idStr = self.idArry[i];
                NSString *selectIdStr = self.vegetablesIdArry2[indexPath.row];
                if (selectIdStr.intValue == idStr.intValue)
                {
                    
                    self.isAdd = NO;
                    self.isAddLb.text = @"购物车存在该商品";
                    [self importAnimation];

                }
            }
            
            if (self.isAdd == YES)
            {
                NSString *proid = self.vegetablesIdArry2[indexPath.row];
                NSString *dtlid = self.dtlIdArry2[indexPath.row];
                //增加购物车接口
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
                //jason解析
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url2];
                NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                self.isAddLb.text = @"添加成功";
                [self importAnimation];

            }

        }
        else if (indexPath.section == 1)
        {
            //遍历数组
            for (int i = 0; i < self.idArry.count; i ++)
            {
                NSString *idStr = self.idArry[i];
                NSString *selectIdStr = self.vegetablesIdArry3[indexPath.row];
                if (selectIdStr.intValue == idStr.intValue)
                {
                    
                    self.isAdd = NO;
                    self.isAddLb.text = @"购物车存在该商品";
                    [self importAnimation];

                }
            }
            
            if (self.isAdd == YES)
            {
                NSString *proid = self.vegetablesIdArry3[indexPath.row];
                NSString *dtlid = self.dtlIdArry3[indexPath.row];
                //增加购物车接口
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
                //jason解析
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url2];
                NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                self.isAddLb.text = @"添加成功";
                [self importAnimation];

            }

            
        }
        else
        {
           
            //遍历数组
            for (int i = 0; i < self.idArry.count; i ++)
            {
                NSString *idStr = self.idArry[i];
                NSString *selectIdStr = self.vegetablesIdArry1[indexPath.row];
                if (selectIdStr.intValue == idStr.intValue)
                {
                    
                    self.isAdd = NO;
                    self.isAddLb.text = @"购物车存在该商品";
                    [self importAnimation];

                }
            }
            
            if (self.isAdd == YES)
            {
                NSString *proid = self.vegetablesIdArry1[indexPath.row];
                NSString *dtlid = self.dtlIdArry1[indexPath.row];
                //增加购物车接口
                NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=1",del.User,proid.intValue,dtlid.intValue]];
                //jason解析
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url2];
                NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                self.isAddLb.text = @"添加成功";
                [self importAnimation];

            }

        }
        
    }
}
- (void)getShoppingCarInfo
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //获取用户购物车接口
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C04&loginName=%@",del.User]];
    //json解析
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
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

//自定义section背景和字体
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, self.view.frame.size.width, 20)];

    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:26.0 / 255.0 green:26.0 / 255.0 blue:26.0 / 255.0 alpha:1.0];
    headerLabel.highlightedTextColor = [UIColor colorWithRed:26.0 / 255.0 green:26.0 / 255.0 blue:26.0 / 255.0 alpha:1.0];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.frame = CGRectMake(10.0, 0.0, self.view.frame.size.width, 20);
    [customView addSubview:headerLabel];
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (section == 0)
    {
        headerLabel.text =  del.tempArry[0];
    }
    else if(section == 1)
    {
        headerLabel.text = del.tempArry[1];
    }
    else
    {
        headerLabel.text = del.tempArry[2];
    }
    return customView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailViewController *view = [[GoodsDetailViewController alloc]init];
    
    VegetablesTableViewCell *cell = (VegetablesTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.goodsImage = cell.goodsImg.image;
    
    //传递商品id
    del.goodsId = cell.goodsId;
    //通知中心 输入所要发送的信息 ，同时将label的值通过button方法调用传递，
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:del.goodsId,@"textOne", nil];
    //创建通知  (发送多个通知)
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSLog(@"goodid = %@",del.goodsId);
    
    [self presentViewController:view animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//搜索
- (IBAction)shoppingCarBt:(id)sender
{
    SearchViewController *view = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];

}
@end
