//
//  MainViewController.m
//  Lazy
//
//  Created by yinqijie on 15/9/22.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "MainViewController.h"
#import "PanicViewController.h"
#import "OrderFoodmaterialViewController.h"
#import "VegetablesViewController.h"
#import "AppDelegate.h"
#import "UserLoginViewController.h"
#import "AboutViewController.h"
#import "MyAccountViewController.h"
#import "GetGoodsAddressViewController.h"
#import "MyOrderViewController.h"
#import "ViewController.h"
#import "SearchViewController.h"
#import "LinkUsViewController.h"
#import "GoodsDetailViewController.h"
#import "ASIDownloadCache.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.view reloadInputViews];
    [super viewWillAppear:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //数组初始化
    [self initArray];
    
    //广告推荐栏商品信息接口
    NSURL *url=[NSURL URLWithString:@"http://junjuekeji.com/appServlet?requestCode=B01&displayType=1&prodType=0&panicFlag=0"];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess:)];
    [requestUrl setDidFailSelector:@selector(requestError:)];
    [requestUrl startAsynchronous];
    
    //设置自动播放，定时器。每隔1秒钟播放下一张图片
    [self timerOn];
    
    //左扫
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftAction)];
    [left setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:left];

    //5个商品界面
    [self kindofGoods];
    
}

//布局
- (void)layout
{
    //屏幕适配
    self.view.frame = [[UIScreen mainScreen]bounds];
    //布局
    self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    self.titlelb.frame = CGRectMake(0, 0, self.view.frame.size.width, 75);
    self.userCenterLb.frame = CGRectMake(0, 27, self.view.frame.size.width / 3 * 2, 30);
    self.scrollerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.orderView.frame = CGRectMake(-self.view.frame.size.width / 3 * 2, 0, self.view.frame.size.width / 3 * 2, self.view.frame.size.height);
    self.borderView1.frame = CGRectMake(0, 70, self.view.frame.size.width / 3 * 2, 1);
    self.borderView2.frame = CGRectMake(40, 70 + 50, self.view.frame.size.width / 3 * 2 - 40, 1);
    self.borderView3.frame = CGRectMake(40, 70 + 50 * 2, self.view.frame.size.width / 3 * 2 - 40, 1);
    self.borderView4.frame = CGRectMake(40, 70 + 50 * 3, self.view.frame.size.width / 3 * 2 - 40, 1);
    self.borderView5.frame = CGRectMake(40, 70 + 50 * 4, self.view.frame.size.width / 3 * 2 - 40, 1);
    self.borderView6.frame = CGRectMake(40, 70 + 50 * 5, self.view.frame.size.width / 3 * 2 - 40, 1);
    self.borderView7.frame = CGRectMake(40, 70 + 50 * 7, self.view.frame.size.width / 3 * 2 - 40, 1);
    self.orderView8.frame = CGRectMake(40, 70 + 50 * 6, self.view.frame.size.width / 3 * 2 - 40, 1);
    self.img1.frame = CGRectMake(40, 87, 20, 20);
    self.img2.frame = CGRectMake(40, 87 + 50, 20, 20);
    self.img3.frame = CGRectMake(40, 87 + 50 * 2, 20, 20);
    self.img4.frame = CGRectMake(40, 87 + 50 * 3, 20, 20);
    self.img5.frame = CGRectMake(40, 87 + 50 * 4, 20, 20);
    self.img6.frame = CGRectMake(40, 87 + 50 * 5, 20, 20);
    self.img7.frame = CGRectMake(40, 87 + 50 * 6, 20, 20);
    self.loginBt.frame = CGRectMake(40, 70, 114 + 20, 54);
    self.shoppingCarBt.frame = CGRectMake(40, 70 + 50, 114, 54);
    self.myOrderBt.frame = CGRectMake(40, 70 + 50 * 2, 114, 54);
    self.addressBt.frame = CGRectMake(40, 70 + 50 * 3, 114, 54);
    self.myAccountBt.frame = CGRectMake(40, 70 + 50 * 4, 114, 54);
    self.aboutBt.frame = CGRectMake(40, 70 + 50 * 5, 114, 54);
    self.linkbt.frame = CGRectMake(40, 70 + 50 * 6, 114, 54);
    
    //设置button字体位置和距离边框位置  上左下右
    self.loginBt.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.loginBt.contentEdgeInsets = UIEdgeInsetsMake(15, 20, 0, 0);
    self.shoppingCarBt.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.shoppingCarBt.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 0, 0);
    self.myOrderBt.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.myOrderBt.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 0, 0);
    self.addressBt.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.addressBt.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 0, 0);
    self.myAccountBt.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.myAccountBt.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 0, 0);
    self.aboutBt.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.aboutBt.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 0, 0);
    self.linkbt.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.linkbt.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 0, 0);
    
    self.myScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.scrollerView.frame.size.height / 4)];
    [self.scrollerView addSubview:self.myScrollview];
    
    //风火轮
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(self.myScrollview.frame.size.width/2 - 50/2, self.myScrollview.frame.size.height/2 + 25, 50, 50);
   
    self.activity.hidesWhenStopped = YES;
    [self.scrollerView addSubview:self.activity];
    [self.activity startAnimating];

}

//数组初始化
- (void)initArray
{
    self.goodsTitleArry1 = [[NSMutableArray alloc]initWithObjects:@"生蔬类",@"酒类",@"大米类", nil];
    self.goodsTitleArry2 = [[NSMutableArray alloc]initWithObjects:@"酒类",@"生蔬类",@"大米类", nil];
    self.goodsTitleArry3 = [[NSMutableArray alloc]initWithObjects:@"大米类",@"酒类",@"生蔬类", nil];
    
    self.imageArray = [[NSMutableArray alloc] init];
    
    self.imgArry1 = [[NSMutableArray alloc]initWithObjects:
                     [UIImage imageNamed:@"fruit.png"],
                     [UIImage imageNamed:@"fruit.png"],
                     [UIImage imageNamed:@"fruit.png"],nil];
    
    self.imgArry2 = [[NSMutableArray alloc]initWithObjects:
                     [UIImage imageNamed:@"wine.png"],
                     [UIImage imageNamed:@"wine.png"],
                     [UIImage imageNamed:@"wine.png"],nil];
    
    self.imgArry3 = [[NSMutableArray alloc]initWithObjects:
                     [UIImage imageNamed:@"riceOil.png"],
                     [UIImage imageNamed:@"riceOil.png"],
                     [UIImage imageNamed:@"riceOil.png"],nil];
    
    self.titleGoodsNameArry = [[NSMutableArray alloc] init];
    self.titleGoodspriceArry = [[NSMutableArray alloc] init];
    self.goodsIntroduceArry = [[NSMutableArray alloc] init];
    self.titleGoodsIdArry = [[NSMutableArray alloc] init];
    self.titleGoodsImgIdArry = [[NSMutableArray alloc] init];
    self.titleImgNameArry = [[NSMutableArray alloc] init];
    self.titleImgPathArry = [[NSMutableArray alloc] init];
    self.titleGoodsStandArry = [[NSMutableArray alloc] init];
    self.titleMarketPriceArry = [[NSMutableArray alloc] init];

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
        NSLog(@"广告栏商品信息获取成功!");
    }
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        [self.titleGoodsNameArry addObject:[returnlistArry[i] objectForKey:@"prodName"]];
        //商品备注
        [self.goodsIntroduceArry addObject:[returnlistArry[i] objectForKey:@"demo"]];
        //商品ID
        [self.titleGoodsIdArry addObject:[NSString stringWithFormat:@"%@",[returnlistArry[i] objectForKey:@"prodId"]]];
        //当前商品推荐图
        NSArray *imglistArry = [returnlistArry[i] objectForKey:@"imgList"];
        if (imglistArry.count != 0)
        {
            [self.titleGoodsImgIdArry addObject:[imglistArry[2] objectForKey:@"imgId"]];
            [self.titleImgNameArry addObject:[imglistArry[2] objectForKey:@"imgName"]];
            [self.titleImgPathArry addObject:[imglistArry[2] objectForKey:@"imgPath"]];
        }
        else
        {
            [self.titleImgNameArry addObject:@""];
        }
        NSArray *prodDtlListArry = [returnlistArry[i] objectForKey:@"prodDtlList"];
        //商品价格
        [self.titleGoodspriceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"amount"]]];
        //商品市场价格
        [self.titleMarketPriceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListArry[0] objectForKey:@"originalAmountYuan"]]];
        //商品规格
        [self.titleGoodsStandArry addObject:[prodDtlListArry[0] objectForKey:@"prodStandard"]];
        
    }
    
    for (int i = 0; i < self.titleImgNameArry.count; i++)
    {
        if ([self.titleImgNameArry[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.titleImgNameArry[i]]]]];
            [self.imageArray addObject:img];
        }
        else
        {
            [self.imageArray addObject:[UIImage imageNamed:@"moren.png"]];
        }
    }
    
    // ****************************
    self.scrollerView.delegate = self;
    CGFloat imageY = 0;
    CGFloat imageW = self.myScrollview.frame.size.width;
    CGFloat imageH = self.myScrollview.frame.size.height;
    //用for循环往ScrollView中添加图片，这里面计算每张图片的x值是重点
    for (int i = 0; i < self.imageArray.count; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        CGFloat imageX = i*imageW;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        imageView.image = self.imageArray[i];
        [self.myScrollview addSubview:imageView];
        //把第一张图片放到最后的位置
        UIImageView * imgView0 = [[UIImageView alloc]initWithFrame:CGRectMake(self.myScrollview.frame.size.width * ([self.imageArray count]+1), self.myScrollview.frame.origin.y, self.myScrollview.frame.size.width, self.myScrollview.frame.size.height)];
        imgView0.image = [self.imageArray objectAtIndex:0];
        [self.myScrollview addSubview:imgView0];
        
        
    }
    //然后设置scrollView的contentSize，这样才能滚动起来，这里滚动只有横向滚动，所以竖向的为0
    self.myScrollview.contentSize = CGSizeMake(self.imageArray.count *imageW, 0);
    //分页，pagingEnabled是scrollView的一个属性
    self.myScrollview.pagingEnabled = YES;
    //去除水平滚动条
    self.myScrollview.showsHorizontalScrollIndicator = NO;
    self.myScrollview.showsVerticalScrollIndicator = NO;
    //设置页数控制器总页数，即按钮数
    self.myPagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 80, self.myScrollview.frame.size.height + 30, imageW, 30)];
    self.myPagecontrol.currentPageIndicatorTintColor = [UIColor purpleColor];
    self.myPagecontrol.pageIndicatorTintColor = [UIColor whiteColor];
    
    [self.scrollerView addSubview:self.myPagecontrol];
    
    self.myPagecontrol.numberOfPages = self.imageArray.count;
    //设置代理
    self.myScrollview.delegate = self;
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTapAction)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    [self.myScrollview addGestureRecognizer:singleRecognizer];
    
    [self.activity stopAnimating];

}

//请求失败
- (void)requestError:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
    if ([[error localizedDescription] isEqualToString:@"A connection failure occurred"])
    {
        [self.activity stopAnimating];
    }

}

//左扫
- (void)leftAction
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.orderView.frame = CGRectMake(-self.view.frame.size.width / 3 * 2,0, self.view.frame.size.width / 3 * 2, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

//每隔1秒播放图片，其实是每隔1秒调用imgPlay方法
- (void)timerOn
{
    self.mytimer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(imgPlay) userInfo:nil repeats:YES];
    //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
    [[NSRunLoop currentRunLoop]addTimer:self.mytimer forMode:NSRunLoopCommonModes];
}

//比方下一张图片，其实就是拖动scrollView，也就是改变scrollView的contentOffset属性
//当然，这里要判断一下，如果播放最后一张了，那么下一张就是第一张
- (void)imgPlay
{
    CGFloat pageWidth = self.myScrollview.frame.size.width;
    int page = floor((self.myScrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPagecontrol.currentPage = page;
    
    NSInteger i=self.myPagecontrol.currentPage;
    if (i==self.imageArray.count-1)
    {
        i = -1;
    }
    i++;
    [self.myScrollview setContentOffset:CGPointMake(i*self.myScrollview.frame.size.width, 0) animated:YES];
}

//当用户准备拖拽的时候，关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self timerOff];
}

//当用户停止拖拽的时候，添加一个定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self timerOn];
}

//关闭定时器，并且把定时器设置为nil，这是习惯
-(void)timerOff
{
    [self.mytimer invalidate];
    self.mytimer = nil;
}

//这个事判断定时器滚动的时候，实时判断滚动位置，以让Page Controll显示当前的点是哪一个点
//这个需要在总宽度上加上半个scrollView的宽度，是为了保证拖拽到一半时候左右的效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.myPagecontrol.currentPage = (self.myScrollview.frame.size.width*0.5+self.myScrollview.contentOffset.x)/self.myScrollview.frame.size.width;
    //NSLog(@"%d",self.myPagecontrol.currentPage);
}

//主页的商品列表展示
- (void)kindofGoods
{
    //海鲜按钮
    UIButton *seafoodBt = [[UIButton alloc]initWithFrame:CGRectMake(0, self.myScrollview.frame.size.height + self.myScrollview.frame.origin.y + 5, self.view.frame.size.width / 2 - 2.5, self.scrollerView.frame.size.height / 5)];
    seafoodBt.backgroundColor = [UIColor whiteColor];
    [seafoodBt setImage:[UIImage imageNamed:@"seafood.png"] forState:UIControlStateNormal];
    [seafoodBt addTarget:self action:@selector(seafoodAction)
        forControlEvents:UIControlEventTouchUpInside];
    //添加限时抢购图片
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(seafoodBt.frame.size.width - 40, 0, 40, 40)];
    img1.image = [UIImage imageNamed:@"timeOrder1.png"];
    [seafoodBt addSubview:img1];
    [self.scrollerView addSubview:seafoodBt];
    
    //粮酒按钮
    UIButton *liangjiuBt = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 2.5, self.myScrollview.frame.size.height + self.myScrollview.frame.origin.y + 5, self.view.frame.size.width / 2 - 2.5, self.scrollerView.frame.size.height / 5)];
    liangjiuBt.backgroundColor = [UIColor whiteColor];
    [liangjiuBt setImage:[UIImage imageNamed:@"oil.png"] forState:UIControlStateNormal];
    [liangjiuBt addTarget:self action:@selector(liangjiuAction) forControlEvents:UIControlEventTouchUpInside];
    //添加限时抢购图片
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(seafoodBt.frame.size.width - 40, 0, 40, 40)];
    img2.image = [UIImage imageNamed:@"timeOrder1.png"];
    [liangjiuBt addSubview:img2];
    [self.scrollerView addSubview:seafoodBt];
    [self.scrollerView addSubview:liangjiuBt];
    
    //果蔬
    UIButton *vegetablesBt = [[UIButton alloc]initWithFrame:CGRectMake(0, liangjiuBt.frame.size.height + liangjiuBt.frame.origin.y + 5, self.view.frame.size.width, self.scrollerView.frame.size.height / 5)];
    [vegetablesBt setBackgroundColor:[UIColor whiteColor]];
    [vegetablesBt addTarget:self action:@selector(vegetablesAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollerView addSubview:vegetablesBt];
    
    self.img8 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.scrollerView.frame.size.height / 5)];
    self.img8.image = [UIImage imageNamed:@"fruit.png"];
    
    //动画
    [self.img8 setAnimationImages:self.imgArry1];
    [self.img8 setAnimationDuration:60.0];
    [self.img8 startAnimating];
    [vegetablesBt addSubview:self.img8];
    
    
    UILabel *kindLb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.scrollerView.frame.size.height / 5 / 2 - 40, self.view.frame.size.width / 2, 30)];
    UILabel *titleLb1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 60, self.scrollerView.frame.size.height / 5 / 2, 120, 30)];
    kindLb1.textColor = [UIColor purpleColor];
    kindLb1.numberOfLines = 1;
    kindLb1.text = @"蔬菜水果";
    kindLb1.font = [UIFont boldSystemFontOfSize:20.0];
    kindLb1.textAlignment = NSTextAlignmentCenter;
    kindLb1.adjustsFontSizeToFitWidth = YES;
    [vegetablesBt addSubview:kindLb1];
    
    titleLb1.textColor = [UIColor grayColor];
    titleLb1.numberOfLines = 2;
    titleLb1.text = @"新鲜蔬菜供应！您到家，蔬菜就到家";
    titleLb1.font = [UIFont boldSystemFontOfSize:13.0];
    titleLb1.textAlignment = NSTextAlignmentCenter;
    titleLb1.adjustsFontSizeToFitWidth = YES;
    [vegetablesBt addSubview:titleLb1];
    
    //酒类
    UIButton *wineBt = [[UIButton alloc]initWithFrame:CGRectMake(0, vegetablesBt.frame.size.height + vegetablesBt.frame.origin.y + 5, self.view.frame.size.width, self.scrollerView.frame.size.height / 5)];
    [wineBt setBackgroundColor:[UIColor whiteColor]];
    [wineBt addTarget:self action:@selector(wineBtAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollerView addSubview:wineBt];
    
    self.img9 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.scrollerView.frame.size.height / 5)];
    self.img9.image = [UIImage imageNamed:@"wine.png"];
    
    //动画
    [self.img9 setAnimationImages:self.imgArry2];
    [self.img9 setAnimationDuration:60.0];
    [self.img9 startAnimating];
    [wineBt addSubview:self.img9];
    
    UILabel *kindLb2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.scrollerView.frame.size.height / 5 / 2 - 40, self.view.frame.size.width / 2, 30)];
    UILabel *titleLb2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 60, self.scrollerView.frame.size.height / 5 / 2, 120, 30)];
    kindLb2.textColor = [UIColor redColor];
    kindLb2.numberOfLines = 1;
    kindLb2.text = @"酒水";
    kindLb2.font = [UIFont boldSystemFontOfSize:20.0];
    kindLb2.textAlignment = NSTextAlignmentCenter;
    kindLb2.adjustsFontSizeToFitWidth = YES;
    [wineBt addSubview:kindLb2];
    
    titleLb2.textColor = [UIColor grayColor];
    titleLb2.numberOfLines = 2;
    titleLb2.text = @"新鲜蔬菜供应！您到家，蔬菜就到家";
    titleLb2.font = [UIFont boldSystemFontOfSize:13.0];
    titleLb2.textAlignment = NSTextAlignmentCenter;
    titleLb2.adjustsFontSizeToFitWidth = YES;
    [wineBt addSubview:titleLb2];
    
    //大米类
    UIButton *riceBt = [[UIButton alloc]initWithFrame:CGRectMake(0, wineBt.frame.size.height + wineBt.frame.origin.y + 5, self.view.frame.size.width, self.scrollerView.frame.size.height / 5)];
    [riceBt setBackgroundColor:[UIColor whiteColor]];
    [riceBt addTarget:self action:@selector(riceBtAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollerView addSubview:riceBt];
    
    self.img10 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.scrollerView.frame.size.height / 5)];
    self.img10.image = [UIImage imageNamed:@"riceOil.png"];
    
    //动画
    [self.img10 setAnimationImages:self.imgArry3];
    [self.img10 setAnimationDuration:60.0];
    [self.img10 startAnimating];
    [riceBt addSubview:self.img10];
    
    UILabel *kindLb3 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.scrollerView.frame.size.height / 5 / 2 - 40 , self.view.frame.size.width / 2, 30)];
    UILabel *titleLb3 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4 - 60, self.scrollerView.frame.size.height / 5 / 2  , 120, 30)];
    kindLb3.textColor = [UIColor yellowColor];
    kindLb3.numberOfLines = 1;
    kindLb3.text = @"大米粮油";
    kindLb3.font = [UIFont boldSystemFontOfSize:20.0];
    kindLb3.textAlignment = NSTextAlignmentCenter;
    kindLb3.adjustsFontSizeToFitWidth = YES;
    [riceBt addSubview:kindLb3];
    
    titleLb3.textColor = [UIColor grayColor];
    titleLb3.numberOfLines = 2;
    titleLb3.text = @"新鲜蔬菜供应！您到家，蔬菜就到家";
    titleLb3.font = [UIFont boldSystemFontOfSize:13.0];
    titleLb3.textAlignment = NSTextAlignmentCenter;
    titleLb3.adjustsFontSizeToFitWidth = YES;
    [riceBt addSubview:titleLb3];

    self.scrollerView.contentSize = CGSizeMake(self.view.frame.size.width, riceBt.frame.size.height + riceBt.frame.origin.y + 5);
}

//单击
- (void)SingleTapAction
{
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //传值
    del.goodsId = self.titleGoodsIdArry[self.myPagecontrol.currentPage];
    NSLog(@"pagecount = %ld",(long)self.myPagecontrol.currentPage);
    //通知中心 输入所要发送的信息 ，同时将label的值通过button方法调用传递，
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:del.goodsId,@"textOne", nil];
    //创建通知  (发送多个通知)
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    GoodsDetailViewController *vegetableView = [[GoodsDetailViewController alloc]init];

    [self presentViewController:vegetableView animated:YES completion:nil];
   
}

//跳转海鲜
- (void)seafoodAction
{
    PanicViewController *seafoodView = [[PanicViewController alloc]init];
    [self presentViewController:seafoodView animated:YES completion:nil];
}

//跳转粮食酒类
- (void)liangjiuAction
{
    OrderFoodmaterialViewController *foodView = [[OrderFoodmaterialViewController alloc]initWithNibName:@"OrderFoodmaterialViewController" bundle:nil];
    [self presentViewController:foodView animated:YES completion:nil];
}

//跳转生疏类
- (void)vegetablesAction
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    VegetablesViewController *vegetableView = [[VegetablesViewController alloc]initWithNibName:@"VegetablesViewController" bundle:nil];
    [self presentViewController:vegetableView animated:YES completion:nil];
    [del.tempArry setArray:self.goodsTitleArry1];
}

//跳转酒类
- (void)wineBtAction
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    VegetablesViewController *vegetableView = [[VegetablesViewController alloc]initWithNibName:@"VegetablesViewController" bundle:nil];
    [self presentViewController:vegetableView animated:YES completion:nil];
    [del.tempArry setArray:self.goodsTitleArry2];

}

//跳转大米类
- (void)riceBtAction
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    VegetablesViewController *vegetableView = [[VegetablesViewController alloc]initWithNibName:@"VegetablesViewController" bundle:nil];
    [self presentViewController:vegetableView animated:YES completion:nil];
    [del.tempArry setArray:self.goodsTitleArry3];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//用户中心
- (IBAction)kindBt:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.orderView.frame = CGRectMake(0, 0, self.view.frame.size.width / 3 * 2, self.view.frame.size.height);
    [UIView commitAnimations];
}

//我的订单
- (IBAction)myOrderBt:(id)sender
{
    MyOrderViewController *view = [[MyOrderViewController alloc]initWithNibName:@"MyOrderViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
}

//购物车
- (IBAction)shoppingCarBt:(id)sender
{
  
    ViewController *view = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
    [self presentViewController:nav animated:YES completion:nil];
}

//收货地址
- (IBAction)addressBt:(id)sender
{
    GetGoodsAddressViewController *view = [[GetGoodsAddressViewController alloc]initWithNibName:@"GetGoodsAddressViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];

}

//我的账户
- (IBAction)myAccountBt:(id)sender
{
    MyAccountViewController *view = [[MyAccountViewController alloc]initWithNibName:@"MyAccountViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];

}

//关于
- (IBAction)aboutBt:(id)sender
{
    AboutViewController *view = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];

}

//登录注册
- (IBAction)loginBt:(id)sender
{
    UserLoginViewController *view = [[UserLoginViewController alloc]initWithNibName:@"UserLoginViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];

}

//联系我们
- (IBAction)linkBt:(id)sender
{
    LinkUsViewController *view = [[LinkUsViewController alloc]initWithNibName:@"LinkUsViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
}

//搜索
- (IBAction)searchBt:(id)sender
{
    SearchViewController *searchView = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    [self presentViewController:searchView animated:YES completion:nil];

}
@end
