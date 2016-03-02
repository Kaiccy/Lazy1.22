//
//  GoodsDetailViewController.m
//  Lazy
//
//  Created by yinqijie on 15/9/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "AppDelegate.h"
#import "FinallyPaymentViewController.h"
#import "SubmitOrderViewController.h"
#import "ViewController.h"
#import "CommonMacro.h"

@interface GoodsDetailViewController ()

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //布局
    [self layout];
    
    self.scrollerView.delegate = self;
    self.isAdd = YES;
    
    self.idArry = [[NSMutableArray alloc]init];
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(self.view.frame.size.width/2 - 50/2, self.goodsImg.frame.size.height/2 - 25, 50, 50);
    self.activity.hidesWhenStopped = YES;
    [self.view addSubview:self.activity];
    [self.activity startAnimating];
    
    //商品详情接口
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=B02&prodId=%d",del.goodsId.intValue]];
    
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
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:250.0 / 255.0 blue:248.0 / 255.0 alpha:1.0];
    //滚动
    self.scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 65)];
    [self.view addSubview:self.scrollerView];
    //商品展示图
    self.goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height / 3)];
    [self.scrollerView addSubview:self.goodsImg];
    //商品名称
    self.goodsTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.goodsImg.frame.origin.y + self.goodsImg.frame.size.height + 10, self.view.frame.size.width - 10, 30)];
    self.goodsTitleLb.font = [UIFont systemFontOfSize:16.0];
    self.goodsTitleLb.textColor = [UIColor colorWithRed:26.0 / 255.0 green:26.0 / 255.0 blue:26.0 / 255.0 alpha:1.0];
    [self.scrollerView addSubview:self.goodsTitleLb];
    //商品介绍
    self.goodsIntroduceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.goodsTitleLb.frame.origin.y + self.goodsTitleLb.frame.size.height, self.view.frame.size.width - 20, 100)];
    self.goodsIntroduceLb.font = [UIFont boldSystemFontOfSize:13.0];
    self.goodsIntroduceLb.adjustsFontSizeToFitWidth = YES;
    self.goodsIntroduceLb.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    [self.scrollerView addSubview:self.goodsIntroduceLb];
    //分界线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, self.goodsIntroduceLb.frame.origin.y + self.goodsIntroduceLb.frame.size.height + 10, self.view.frame.size.width - 10, 0.6)];
    view.backgroundColor = [UIColor colorWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    [self.scrollerView addSubview:view];
    //价格
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(10, view.frame.origin.y + view.frame.size.height + 10, 40, 30)];
    lb1.text = @"价格:";
    lb1.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    lb1.font = [UIFont systemFontOfSize:15];
    [self.scrollerView addSubview:lb1];
    
    UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(80, view.frame.origin.y + view.frame.size.height + 10, 20, 30)];
    lb2.text = @"¥";
    lb2.font = [UIFont systemFontOfSize:14];
    lb2.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    [self.scrollerView addSubview:lb2];
    
    self.goodsPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(90, view.frame.origin.y + view.frame.size.height + 10, 200, 30)];
    self.goodsPriceLb.font = [UIFont systemFontOfSize:15];
    self.goodsPriceLb.textColor = [UIColor redColor];
    [self.scrollerView addSubview:self.goodsPriceLb];
    
    UILabel *lb4 = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsPriceLb.text.length * 15 + 40, 0, 20, 30) ];
    lb4.text = @"/份";
    lb4.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    lb4.font = [UIFont systemFontOfSize:14];
    [self.goodsPriceLb addSubview:lb4];
    //市场价
    UILabel *lb5 = [[UILabel alloc] initWithFrame:CGRectMake(10, lb1.frame.origin.y + lb1.frame.size.height, 50, 30) ];
    lb5.text = @"市场价:";
    lb5.font = [UIFont systemFontOfSize:15];
    lb5.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    [self.scrollerView addSubview:lb5];
    
    self.goodsMarketPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(80, lb1.frame.origin.y + lb1.frame.size.height, 200, 30)];
    self.goodsMarketPriceLb.font = [UIFont systemFontOfSize:14];
    self.goodsMarketPriceLb.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    [self.scrollerView addSubview:self.goodsMarketPriceLb];
    //规格
    UILabel *lb7 = [[UILabel alloc]initWithFrame:CGRectMake(10, lb5.frame.origin.y + lb5.frame.size.height, 40, 30)];
    lb7.text = @"规格:";
    lb7.font = [UIFont systemFontOfSize:15];
    lb7.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    [self.scrollerView addSubview:lb7];
    
    self.goodsStandardLb = [[UILabel alloc]initWithFrame:CGRectMake(80, lb5.frame.origin.y + lb5.frame.size.height, 200, 30)];
    self.goodsStandardLb.font = [UIFont systemFontOfSize:14];
    self.goodsStandardLb.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    [self.scrollerView addSubview:self.goodsStandardLb];
    //页脚
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60)];
    footview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footview];
    //按钮
    self.minusBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 15, 30, 30)];
    [self.minusBt setTitle:@"-" forState:UIControlStateNormal];
    [self.minusBt setTitleColor:[UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.minusBt addTarget:self action:@selector(minusBt:) forControlEvents:UIControlEventTouchUpInside];
    self.minusBt.layer.borderWidth = 0.6;
    self.minusBt.layer.borderColor = [UIColor grayColor].CGColor;
    [footview addSubview:self.minusBt];
    
    self.addbt = [[UIButton alloc]initWithFrame:CGRectMake(70, 15, 30, 30)];
    [self.addbt setTitle:@"+" forState:UIControlStateNormal];
    [self.addbt setTitleColor:[UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.addbt addTarget:self action:@selector(addBt:) forControlEvents:UIControlEventTouchUpInside];
    self.addbt.layer.borderWidth = 0.6;
    self.addbt.layer.borderColor = [UIColor grayColor].CGColor;
    [footview addSubview:self.addbt];
    
    self.rightnowBuy = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 15, 60, 30)];
    self.rightnowBuy.titleLabel.font = [UIFont systemFontOfSize:11.0];
    self.rightnowBuy.backgroundColor = [UIColor colorWithRed:162.0 / 255.0 green:73.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
    [self.rightnowBuy setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.rightnowBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightnowBuy addTarget:self action:@selector(rightnowBuy:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:self.rightnowBuy];
    
    self.addShoppingCarBt = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70 - self.rightnowBuy.frame.origin.y - self.rightnowBuy.frame.size.width, 15, 60, 30)];
    self.addShoppingCarBt.titleLabel.font = [UIFont systemFontOfSize:11.0];
    self.addShoppingCarBt.backgroundColor = [UIColor colorWithRed:162.0 / 255.0 green:73.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
    [self.addShoppingCarBt setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.addShoppingCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addShoppingCarBt addTarget:self action:@selector(addShoppingCarBt:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:self.addShoppingCarBt];
    
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20,Width , 40)];
    self.view1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.view1];
    
    self.backBt = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [self.backBt setImage:[UIImage imageNamed:@"wrong1.png"] forState:UIControlStateNormal];
    [self.backBt addTarget:self action:@selector(backBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view1 addSubview:self.backBt];
    
    self.shoppingCarBt = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 35, 10, 25, 25)];
    [self.shoppingCarBt setImage:[UIImage imageNamed:@"shoppingcar.png"] forState:UIControlStateNormal];
    [self.shoppingCarBt addTarget:self action:@selector(shoppingCarBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view1 addSubview:self.shoppingCarBt];
    //数量
    self.goodsNumberLb = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 30, 30)];
    [footview addSubview:self.goodsNumberLb];
    self.goodsNumberLb.textAlignment = NSTextAlignmentCenter;
    self.goodsNumberLb.layer.borderWidth = 0.6;
    self.goodsNumberLb.layer.borderColor = [UIColor grayColor].CGColor;
    //隐藏提示“添加成功...”
    self.importTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75, self.view.frame.size.height - 100, 150, 30)];
    self.importTextField.text = @"~添加购物车成功~";
    self.importTextField.textAlignment = NSTextAlignmentCenter;
    self.importTextField.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    [self.scrollerView addSubview:self.importTextField];
    self.importTextField.hidden = YES;

    self.scrollerView.contentSize = CGSizeMake(self.view.frame.size.width, self.goodsStandardLb.frame.size.height + self.goodsStandardLb.frame.origin.y + 100);

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
        NSLog(@"商品详情信息获取成功!");
    }
    
    //商品详情的图片
    NSArray *imglistArry = [returnlistArry[0] objectForKey:@"imgList"];
    if (imglistArry.count != 0)
    {
        self.nameStr =  [imglistArry[0] objectForKey:@"imgName"];
        self.listImgNameStr = [imglistArry[1] objectForKey:@"imgName"];
    }
    
    else
    {
        self.nameStr = @"";
        self.listImgNameStr = @"";
    }
    
    if (self.nameStr.length != 0)
    {
        //请求图片
        UIImage *img =  [UIImage imageWithData:[NSData
                                                dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.nameStr]]]];
        self.goodsImg.image = img;
    }
    else
    {
        self.goodsImg.image = [UIImage imageNamed:@"moren.png"];
    }
    
    if (self.listImgNameStr.length != 0)
    {
        //商品清单列表的图片
        self.listImg =  [UIImage imageWithData:[NSData
                                                dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.listImgNameStr]]]];
    }
    else
    {
        self.listImg = [UIImage imageNamed:@"moren.png"];
    }

    
    //商品名称
    self.goodsTitleLb.text = [returnlistArry[0] objectForKey:@"prodName"];
    //商品备注
    self.goodsIntroduceLb.text = [returnlistArry[0] objectForKey:@"demo"];
    //产品列表
    NSArray *prodDtlListStr = [returnlistArry[0] objectForKey:@"prodDtlList"];
    //dtlid
    NSString *dtlidStr = [prodDtlListStr[0] objectForKey:@"dtlId"];
    self.dtlid = dtlidStr.intValue;
    //商品价格
    NSString *priceStr = [NSString stringWithFormat:@"%@",[prodDtlListStr[0] objectForKey:@"amount"]];
    self.goodsPriceLb.text = [NSString stringWithFormat:@"%.2f",priceStr.floatValue/100];
    //商品市场价格
    NSString *marketPriceStr = [NSString stringWithFormat:@"%@",[prodDtlListStr[0] objectForKey:@"originalAmount"]];
    NSString *Str = [NSString stringWithFormat:@"%.2f",marketPriceStr.floatValue / 100];
    //label删除线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, self.goodsMarketPriceLb.frame.size.height / 2, Str.length * 8, 0.6)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.goodsMarketPriceLb addSubview:lineView];
    self.goodsMarketPriceLb.text = [NSString stringWithFormat:@"¥ %.2f",marketPriceStr.floatValue/100];
    //商品规格
    self.goodsStandardLb.text = [prodDtlListStr[0] objectForKey:@"prodStandard"];
   
    //抢购结束时间
    //时间戳转时间的方法:
    NSDictionary *endTimeDic = [returnlistArry[0] objectForKey:@"panicEndDate"];
    if (![endTimeDic valueForKey:@"<null>"])
    {
        NSDictionary *endTimeDic = [returnlistArry[0] objectForKey:@"panicEndDate"];
        self.endtimeStr = [NSString stringWithFormat: @"%@",[endTimeDic objectForKey:@"time"]];
        self.endtimeStr = [self.endtimeStr substringToIndex:10];
        
        NSDate *now = [NSDate date];
        //把当前时间转化成时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
        NSLog(@"timeSp:%@",timeSp);
        //总时间设置
        int total = self.endtimeStr.intValue + 480 - timeSp.intValue;
        double time = [[NSDate date] timeIntervalSinceDate:now];
        double remainTime = total - time;
        //如果限时抢购产品时间结束  就不能购买和加入购物车
        if (remainTime < 0.0)
        {
            self.addShoppingCarBt.enabled = NO;
            self.rightnowBuy.enabled = NO;
            self.addShoppingCarBt.backgroundColor = [UIColor grayColor];
            self.rightnowBuy.backgroundColor = [UIColor grayColor];
            self.addbt.enabled = NO;
            self.minusBt.enabled = NO;
        }
        
    }
    
    
    //初始化购物车数量
    self.goodsNumberLb.text = @"1";
    
    //传值给提交订单页面
    del.goodsImage = self.goodsImg.image;
    del.goodsNameStr = self.goodsTitleLb.text;
    del.goodsPriceStr = self.goodsPriceLb.text;
    
    [self.activity stopAnimating];
}

- (void)requestError1:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)tongzhi:(NSNotification *)text
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"%@",text.userInfo[@"textOne"]);
    
    del.goodsId = text.userInfo[@"textOne"];
    
    NSLog(@"goodIdStr = %@",del.goodsId);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

//当用户准备拖拽的时候，view颜色变深
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.view1.backgroundColor = [UIColor colorWithRed:209.0 / 255.0 green:209.0 / 255.0 blue:209.0 / 255.0 alpha:0.7];
}

//当用户停止拖拽的时候，view颜色变浅
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.view1.backgroundColor = [UIColor clearColor];
}

- (void)backBt:(UIButton *)bt
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)minusBt:(UIButton *)bt
{
   
    if(self.goodsNumberLb.text.intValue >= 2)
    {
        int count = self.goodsNumberLb.text.intValue;
        count = count - 1;
        self.goodsNumberLb.text = [NSString stringWithFormat:@"%d",count];
    }
}

- (void)addBt:(UIButton *)bt
{
    int count = self.goodsNumberLb.text.intValue;
    count = count + 1;//还应该限定购买的最大数量
    self.goodsNumberLb.text = [NSString stringWithFormat:@"%d",count];
}


- (void)addShoppingCarBt:(UIButton *)bt
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //获取用户购物车接口
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C04&loginName=%@",del.User]];
    
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
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    // NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        NSDictionary *carDic = [returnlistArry[i] objectForKey:@"cart"];
        //商品ID
        [self.idArry addObject:[NSString stringWithFormat:@"%@",[carDic objectForKey:@"prodId"]]];
    }
    
    //遍历数组
    for (int i = 0; i < self.idArry.count; i ++)
    {
        NSString *idStr = self.idArry[i];
        if (del.goodsId.intValue == idStr.intValue)
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"已经加入购物车，请选择其它商品！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            self.isAdd = NO;
        }
    }
    if (self.isAdd == YES)
    {
        //增加购物车接口
        NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C01&loginName=%@&prodId=%d&dtlId=%d&prodNumber=%d",del.User,del.goodsId.intValue,self.dtlid,self.goodsNumberLb.text.intValue]];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url2];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess3:)];
        [requestUrl setDidFailSelector:@selector(requestError3:)];
        [requestUrl startSynchronous];
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
    
    
    self.importTextField.hidden = NO;
    //渐进模糊动画
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = 1;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.importTextField.layer addAnimation:animation forKey:@"animation"];
}

- (void)requestError3:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)rightnowBuy:(UIButton *)sender
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    SubmitOrderViewController *view = [[SubmitOrderViewController alloc]initWithNibName:@"SubmitOrderViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
    
    //先清空该数组 再把当前的商品加到商品列表中
    [del.listImgArray removeAllObjects];
    [del.listCountArray removeAllObjects];
    [del.listNameArray removeAllObjects];
    [del.listPriceArray removeAllObjects];
    [del.listIdArry removeAllObjects];
    [del.orderGoodsid removeAllObjects];
    
    [del.listImgArray addObject:self.listImg];
    [del.listNameArray addObject:self.goodsTitleLb.text];
    [del.listCountArray addObject:self.goodsNumberLb.text];
    [del.listIdArry addObject:del.goodsId];
    
    [del.orderGoodsid addObject:[NSString stringWithFormat:@"%d",self.dtlid]];
    //把商品列表的图片传给订单界面
    view.goodsImg1.image = self.goodsImg.image;
    view.moreImg.hidden = YES;
    
    view.totalCountLb.text = [NSString stringWithFormat:@"共%@件",self.goodsNumberLb.text];
    //立即购买 把宝贝详情的价钱传给提交订单页
    float price = self.goodsPriceLb.text.floatValue  * self.goodsNumberLb.text.intValue;
    view.priceLb.text = [NSString stringWithFormat:@"%.2f",price];
    [del.listPriceArray addObject:[NSString stringWithFormat:@"%.2f",price ]];
}
- (void)shoppingCarBt:(UIButton *)bt
{
    ViewController *view = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
