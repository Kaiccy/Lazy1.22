//
//  DetailFoodmaterialViewController.m
//  Lazy
//
//  Created by yinqijie on 15/9/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "DetailFoodmaterialViewController.h"
#import "GoodsDetailViewController.h"
#import "AppDelegate.h"
#import "SearchViewController.h"
#import "SubmitOrderViewController.h"

@interface DetailFoodmaterialViewController ()

@end

@implementation DetailFoodmaterialViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.collectionView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //初始化数组
    [self initArray];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(self.view.frame.size.width/2 - 50/2, self.view.frame.size.height/2 - 25, 50, 50);
    [self.view addSubview:self.activity];
    self.activity.hidesWhenStopped = YES;
    self.collectionView.hidden = YES;
    [self.activity startAnimating];
    
    if (self.i == 0)
    {
        NSURL *url=[NSURL URLWithString:@"http://junjuekeji.com/appServlet?requestCode=B01&displayType=2&prodType=6&panicFlag=1"];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess1:)];
        [requestUrl setDidFailSelector:@selector(requestError1:)];
        [requestUrl startAsynchronous];
    }
    else if (self.i == 1)
    {
        NSURL *url=[NSURL URLWithString:@"http://junjuekeji.com/appServlet?requestCode=B01&displayType=2&prodType=2&panicFlag=1"];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess2:)];
        [requestUrl setDidFailSelector:@selector(requestError2:)];
        [requestUrl startAsynchronous];
    }
    else
    {
        NSURL *url=[NSURL URLWithString:@"http://junjuekeji.com/appServlet?requestCode=B01&displayType=2&prodType=4&panicFlag=1"];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess3:)];
        [requestUrl setDidFailSelector:@selector(requestError3:)];
        [requestUrl startAsynchronous];
    }
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    //提示加载失败
    self.lb = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 2 - 30, 200, 60)];
    self.lb.textAlignment = NSTextAlignmentCenter;
    self.lb.font = [UIFont systemFontOfSize:17];
    self.lb.numberOfLines = 2;
    self.lb.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    self.lb.text = @"加载失败,请检查您的网络环境!";
}

- (void)initArray
{
    self.materailImgArry = [[NSMutableArray alloc]init];
    self.materailImgNameArry = [[NSMutableArray alloc]init ];
    self.nameArry = [[NSMutableArray alloc]init];
    self.priceArry = [[NSMutableArray alloc]init];
    self.materailPathArry = [[NSMutableArray alloc]init];
    self.materailImgIdArry = [[NSMutableArray alloc]init];
    self.materailIdArry = [[NSMutableArray alloc]init];
    self.materailStandArry = [[NSMutableArray alloc]init];
    self.materailRemarkArry = [[NSMutableArray alloc]init];
    self.materailMarketPriceArry = [[NSMutableArray alloc]init];
    self.endtimeArry = [[NSMutableArray alloc]init];

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
        NSLog(@"生活专区商品信息获取成功!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        [self.nameArry addObject:[returnlistArry[i] objectForKey:@"prodName"]];
        //商品备注
        [self.materailRemarkArry addObject:[returnlistArry[i] objectForKey:@"demo"]];
        //商品ID
        [self.materailIdArry addObject:[returnlistArry[i] objectForKey:@"prodId"]];
        
        //商品相关图片（字典）当前显示的图片
        NSArray *imglistArry = [returnlistArry[i] objectForKey:@"imgList"];
        if (imglistArry.count != 0)
        {
            [self.materailImgIdArry addObject:[imglistArry[1] objectForKey:@"imgId"]];
            [self.materailImgNameArry addObject:[imglistArry[1] objectForKey:@"imgName"]];
            [self.materailPathArry addObject:[imglistArry[1] objectForKey:@"imgPath"]];
        }
        else
        {
            [self.materailImgNameArry addObject:@""];
        }
        
        NSArray *prodDtlListArry = [returnlistArry[i] objectForKey:@"prodDtlList"];
        //商品价格
        [self.priceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"amount"]]];
        //商品市场价格
        [self.materailMarketPriceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"originalAmountYuan"]]];
        //商品规格
        [self.materailStandArry addObject:[prodDtlListArry[0] objectForKey:@"prodStandard"]];
        
        //抢购结束时间
        //时间戳转时间的方法:
        NSDictionary *endTimeDic = [returnlistArry[i] objectForKey:@"panicEndDate"];
        NSString *endtime = [NSString stringWithFormat: @"%@",[endTimeDic objectForKey:@"time"]];
        endtime = [endtime substringToIndex:10];
        [self.endtimeArry addObject:endtime];
        
    }
    //请求图片
    
    for (int i = 0; i < self.materailImgNameArry.count; i++)
    {
        if ([self.materailImgNameArry[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.materailImgNameArry[i]]]]];
            [self.materailImgArry addObject:img];
        }
        else
        {
            [self.materailImgArry addObject:[UIImage imageNamed:@"moren.png"]];
        }
        
    }
    
    [self.activity stopAnimating];
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
    
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
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"生活专区商品信息获取成功!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        [self.nameArry addObject:[returnlistArry[i] objectForKey:@"prodName"]];
        //商品备注
        [self.materailRemarkArry addObject:[returnlistArry[i] objectForKey:@"demo"]];
        //商品ID
        [self.materailIdArry addObject:[returnlistArry[i] objectForKey:@"prodId"]];
        
        //商品相关图片（字典）当前显示的图片
        NSArray *imglistArry = [returnlistArry[i] objectForKey:@"imgList"];
        if (imglistArry.count != 0)
        {
            [self.materailImgIdArry addObject:[imglistArry[1] objectForKey:@"imgId"]];
            [self.materailImgNameArry addObject:[imglistArry[1] objectForKey:@"imgName"]];
            [self.materailPathArry addObject:[imglistArry[1] objectForKey:@"imgPath"]];
        }
        else
        {
            [self.materailImgNameArry addObject:@""];
        }
        
        NSArray *prodDtlListArry = [returnlistArry[i] objectForKey:@"prodDtlList"];
        //商品价格
        [self.priceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"amount"]]];
        //商品市场价格
        [self.materailMarketPriceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"originalAmountYuan"]]];
        //商品规格
        [self.materailStandArry addObject:[prodDtlListArry[0] objectForKey:@"prodStandard"]];
        //抢购结束时间
        //时间戳转时间的方法:
        NSDictionary *endTimeDic = [returnlistArry[i] objectForKey:@"panicEndDate"];
        NSString *endtime = [NSString stringWithFormat: @"%@",[endTimeDic objectForKey:@"time"]];
        endtime = [endtime substringToIndex:10];
        [self.endtimeArry addObject:endtime];
        
    }
    
    //请求图片
    for (int i = 0; i < self.materailImgNameArry.count; i++)
    {
        if ([self.materailImgNameArry[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.materailImgNameArry[i]]]]];
            [self.materailImgArry addObject:img];
            
        }
        else
        {
            [self.materailImgArry addObject:[UIImage imageNamed:@"moren.png"]];
        }
    }
    
    [self.activity stopAnimating];
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
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
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"生活专区商品信息获取成功!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        [self.nameArry addObject:[returnlistArry[i] objectForKey:@"prodName"]];
        //商品备注
        [self.materailRemarkArry addObject:[returnlistArry[i] objectForKey:@"demo"]];
        //商品ID
        [self.materailIdArry addObject:[returnlistArry[i] objectForKey:@"prodId"]];
        
        //商品相关图片（字典）当前显示的图片
        NSArray *imglistArry = [returnlistArry[i] objectForKey:@"imgList"];
        if (imglistArry.count != 0)
        {
            [self.materailImgIdArry addObject:[imglistArry[1] objectForKey:@"imgId"]];
            [self.materailImgNameArry addObject:[imglistArry[1] objectForKey:@"imgName"]];
            [self.materailPathArry addObject:[imglistArry[1] objectForKey:@"imgPath"]];

        }
        
        else
        {
            [self.materailImgNameArry addObject:@""];
        }
        NSArray *prodDtlListArry = [returnlistArry[i] objectForKey:@"prodDtlList"];

        //商品价格
        [self.priceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"amount"]]];
        //商品市场价格
        [self.materailMarketPriceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"originalAmountYuan"]]];
        //商品规格
        [self.materailStandArry addObject:[prodDtlListArry[0] objectForKey:@"prodStandard"]];
        
        //抢购结束时间
        //时间戳转时间的方法:
        NSDictionary *endTimeDic = [returnlistArry[i] objectForKey:@"panicEndDate"];
        NSString *endtime = [NSString stringWithFormat: @"%@",[endTimeDic objectForKey:@"time"]];
        endtime = [endtime substringToIndex:10];
        [self.endtimeArry addObject:endtime];
        
    }
    //请求图片
    
    for (int i = 0; i < self.materailImgNameArry.count; i++)
    {
        if ([self.materailImgNameArry[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.materailImgNameArry[i]]]]];
            [self.materailImgArry addObject:img];
            
        }
        else
        {
            [self.materailImgArry addObject:[UIImage imageNamed:@"moren.png"]];
        }
    }
    [self.activity stopAnimating];
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
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

#pragma mark - 种类
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.nameArry.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellid = @"cellid";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    UIView *view = [[UIView alloc]init];
    UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width / 2 - 12.5, self.view.frame.size.height / 5)];
    [view addSubview:img];
    img.image = self.materailImgArry[indexPath.row];
    cell.backgroundView = view;
    
    //商品的名字
    UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height / 5 + 5, self.view.frame.size.width / 2 - 10, 20)];
    nameLb.textColor = [[UIColor alloc]initWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    nameLb.textAlignment = NSTextAlignmentCenter;
    nameLb.text = self.nameArry[indexPath.row];
    nameLb.font = [UIFont boldSystemFontOfSize:15.0];
    [view addSubview:nameLb];
    
    //商品的价格
    UILabel *priceLb = [[UILabel alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height / 5 + 30, 80, 20)];
    priceLb.textColor = [[UIColor alloc]initWithRed:255.0 green:0 blue:0 alpha:1.0];
    NSString *priceStr = self.priceArry[indexPath.row];
    priceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
    priceLb.font = [UIFont boldSystemFontOfSize:15.0];
    [view addSubview:priceLb];
    
    //¥
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height / 5 + 30, 20, 20)];
    label1.textColor = [[UIColor alloc]initWithRed:255.0 green:0 blue:0 alpha:1.0];
    label1.text = @"¥";
    label1.font = [UIFont boldSystemFontOfSize:15.0];
    [view addSubview:label1];

    ///份
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(priceLb.text.length * 8, 0, 30, 20)];
    label2.textColor = [[UIColor alloc]initWithRed:255.0 green:0 blue:0 alpha:1.0];
    label2.text = @"/份";
    label2.font = [UIFont boldSystemFontOfSize:15.0];
    [priceLb addSubview:label2];

    //立即购买按钮
    UIButton *buyLb = [[UIButton alloc]initWithFrame:CGRectMake(90, self.view.frame.size.height / 5 + 30, 60, 20)];    [buyLb setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyLb setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyLb setBackgroundColor:[[UIColor alloc]initWithRed:162.0/255.0 green:73.0/255.0 blue:200.0/255.0 alpha:1.0]];
    buyLb.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [buyLb addTarget:self action:@selector(rigntNowBuyAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:buyLb];
    return cell;
}

- (void)rigntNowBuyAction:(UIButton *)bt
{
    UIView *v = [bt superview];
    UICollectionViewCell *cell = (UICollectionViewCell *)[v superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSLog(@"indexpath = %ld",(long)indexPath.row);

    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //抢购结束时间
    //开始时间获取
    NSDate *now = [NSDate date];
    //把当前时间转化成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    
    NSString *timeStr = self.endtimeArry[indexPath.row];
    
    //总时间设置
    int total = timeStr.intValue + 480 - timeSp.intValue;
    double time = [[NSDate date] timeIntervalSinceDate:now];
    double remainTime = total - time;

    SubmitOrderViewController *view = [[SubmitOrderViewController alloc]initWithNibName:@"SubmitOrderViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
    
    //先清空该数组 再把当前的商品加到商品列表中
    [del.listImgArray removeAllObjects];
    [del.listCountArray removeAllObjects];
    [del.listNameArray removeAllObjects];
    [del.listPriceArray removeAllObjects];
    [del.listIdArry removeAllObjects];
    [del.orderGoodsid removeAllObjects];
    
    [del.listImgArray addObject:self.materailImgArry[indexPath.row]];
    [del.listNameArray addObject:self.nameArry[indexPath.row]];
    [del.listCountArray addObject:@"1"];
    [del.listIdArry addObject:self.materailIdArry[indexPath.row]];
    
    //把商品列表的图片传给订单界面
    view.goodsImg1.image = self.materailImgArry[indexPath.row];
    view.moreImg.hidden = YES;
    
    view.totalCountLb.text = [NSString stringWithFormat:@"共1件"];
    //立即购买 把宝贝详情的价钱传给提交订单页
    NSString *price = self.priceArry[indexPath.row];
    view.priceLb.text = [NSString stringWithFormat:@"%.2f",price.floatValue / 100];
    [del.listPriceArray addObject:view.priceLb.text];
    
    //如果限时抢购产品时间结束  就不能购买和加入购物车
    if (remainTime < 0.0)
    {
        view.submitBt.enabled = NO;
        view.submitBt.backgroundColor = [UIColor grayColor];
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width / 2 - 10, self.view.frame.size.height / 5 + 50);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);//上左下右
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.index = indexPath.row;
    //传递商品id
    del.goodsId = self.materailIdArry[indexPath.row];
    //通知中心 输入所要发送的信息 ，同时将label的值通过button方法调用传递，
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:del.goodsId,@"textOne", nil];
    //创建通知  (发送多个通知)
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSLog(@"goodid = %@",del.goodsId);

    GoodsDetailViewController *detailView = [[GoodsDetailViewController alloc]init];
    [self presentViewController:detailView animated:YES completion:nil];
    
    //抢购结束时间
    //开始时间获取
    NSDate *now = [NSDate date];
    //把当前时间转化成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    
    NSString *timeStr = self.endtimeArry[indexPath.row];
    
    //总时间设置
    int total = timeStr.intValue + 480 - timeSp.intValue;
    double time = [[NSDate date] timeIntervalSinceDate:now];
    double remainTime = total - time;
    //如果限时抢购产品时间结束  就不能购买和加入购物车
    if (remainTime < 0.0)
    {
        detailView.addShoppingCarBt.enabled = NO;
        detailView.rightnowBuy.enabled = NO;
        detailView.addShoppingCarBt.backgroundColor = [UIColor grayColor];
        detailView.rightnowBuy.backgroundColor = [UIColor grayColor];
        detailView.addbt.enabled = NO;
        detailView.minusBt.enabled = NO;
    }

    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchBt:(id)sender
{
    SearchViewController *view = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
}
@end
