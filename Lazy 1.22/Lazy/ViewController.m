//
//  ViewController.m

#import "ViewController.h"
#import "MyCustomCell.h"
#import "GoodsInfoModel.h"
#import "AppDelegate.h"

#import "FinallyPaymentViewController.h"
#import "GoodsDetailViewController.h"
#import "SubmitOrderViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,MyCustomCellDelegate>
{
    UITableView *_MyTableView;
    float allPrice;
    NSMutableArray *infoArr;
}

@property(strong,nonatomic) UIButton *allSelectBtn;
@property(strong,nonatomic) UILabel *allPriceLab;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_MyTableView reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //初始化数组
    [self initArry];
    
    //初始化数据
    allPrice = 0.0;
    infoArr = [[NSMutableArray alloc]init];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(self.view.frame.size.width/2 - 50/2, self.view.frame.size.height/2 - 70, 50, 50);
    self.activity.hidesWhenStopped = YES;
    [self.view addSubview:self.activity];
    [self.activity startAnimating];
    _MyTableView.hidden = YES;
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //获取用户购物车接口
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C04&loginName=%@",del.User]];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess1:)];
    [requestUrl setDidFailSelector:@selector(requestError1:)];
    [requestUrl startAsynchronous];
    
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
        NSLog(@"购物车获取成功!");
    }
    
    if (returnlistArry.count == 0)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emptyCar.png"]];
        imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        imgView.hidden = NO;
        [self.view addSubview:imgView];
        
    }
    NSLog(@"returnlistArry = %lu",(unsigned long)returnlistArry.count);
    
    for (int i = 0; i < returnlistArry.count; i++)
    {
        //商品名称
        NSDictionary *productDic = [returnlistArry[i] objectForKey:@"product"];
        [self.nameArry addObject:[productDic objectForKey:@"prodName"]];
        
        
        //商品相关图片（字典）当前显示的图片
        NSArray *imglistArry = [productDic objectForKey:@"imgList"];
        
        if (imglistArry.count != 0)
        {
            [self.imgNameArry addObject:[imglistArry[1] objectForKey:@"imgName"]];
        }
        else
        {
            [self.imgNameArry addObject:@""];
        }
        
        NSDictionary *prodDtlListDic = [returnlistArry[i] objectForKey:@"prodDtl"];
        //商品价格
        [self.priceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListDic objectForKey:@"amount"]]];
        //商品市场价格
        [self.markerPriceArry addObject:[NSString stringWithFormat:@"%@",[prodDtlListDic objectForKey:@"originalAmount"]]];
        //商品规格
        [self.standardArry addObject:[prodDtlListDic objectForKey:@"prodStandard"]];
        //商品数量
        NSDictionary *carDic = [returnlistArry[i] objectForKey:@"cart"];
        [self.countArry addObject:[NSString stringWithFormat:@"%@",[carDic objectForKey:@"prodNumber"]]];
        [self.dtlIdArry addObject:[NSString stringWithFormat:@"%@",[carDic objectForKey:@"dtlId"]]];
        [self.carIdArry addObject:[NSString stringWithFormat:@"%@",[carDic objectForKey:@"cartId"]]];
        //商品ID
        [self.idArry addObject:[NSString stringWithFormat:@"%@",[carDic objectForKey:@"prodId"]]];
    
        NSString *panicStr = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"panicFlag"]];
        //抢购结束时间
        //时间戳转时间的方法:
        NSDictionary *endTimeDic = [productDic objectForKey:@"panicEndDate"];

        NSLog(@"panicStr = %@",panicStr);
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
    
    //请求图片
    for (int i = 0; i < self.imgNameArry.count; i++)
    {
        if ([self.imgNameArry[i] length] != 0)
        {
            UIImage *img =  [UIImage imageWithData:[NSData
                                                    dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat:@"http://junjuekeji.com/resources/images/uploadImgs/%@",self.imgNameArry[i]]]]];
            [self.imgArry addObject:img];
            
        }
        else
        {
            [self.imgArry addObject:[UIImage imageNamed:@"moren.png"]];
            
        }
    }
    
    /**
     *  初始化一个数组，数组里面放字典。字典里面放的是单元格需要展示的数据
     */
    
    for (int i = 0; i < self.nameArry.count; i++)
    {
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
        NSString *priceStr1 = self.priceArry[i];
        NSString *price1 = [NSString stringWithFormat:@"%.2f",priceStr1.floatValue / 100];
        NSString *priceStr2 = self.markerPriceArry[i];
        NSString *price2 = [NSString stringWithFormat:@"%.2f",priceStr2.floatValue / 100];
        [infoDict setValue:self.imgArry[i] forKey:@"imageName"];
        [infoDict setValue:self.nameArry[i] forKey:@"goodsTitle"];
        [infoDict setValue:price1 forKey:@"goodsPrice"];
        [infoDict setValue:price2 forKey:@"goodsMarketPrice"];
        [infoDict setValue:self.standardArry[i] forKey:@"goodsStand"];
        [infoDict setValue:self.idArry[i] forKey:@"goodsId"];
        [infoDict setValue:[NSNumber numberWithBool:NO] forKey:@"selectState"];
        NSString *countStr = self.countArry[i];
        [infoDict setValue:[NSNumber numberWithInt:countStr.intValue] forKey:@"goodsNum"];
        [infoDict setValue:self.carIdArry[i] forKey:@"carId"];
        [infoDict setValue:self.dtlIdArry[i] forKey:@"dtlId"];
                
        //封装数据模型
        GoodsInfoModel *goodsModel = [[GoodsInfoModel alloc]initWithDict:infoDict];
        
        //将数据模型放入数组中
        [infoArr addObject:goodsModel];
    }
    
    [self.activity stopAnimating];
    _MyTableView.hidden = NO;
    [_MyTableView reloadData];

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

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.navigationItem.title = @"购物车";
    
    self.view.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:250.0 / 255.0 blue:248.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.clipsToBounds = YES;
    //导航栏字体的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackground.png"] forBarMetrics:UIBarMetricsDefault];
    //返回按钮
    UIButton *buttonBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [buttonBack setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithCustomView:buttonBack];
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    //创建表格
    _MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _MyTableView.backgroundColor = [UIColor colorWithRed:248.0 / 255.0 green:250.0 / 255.0 blue:248.0 / 255.0 alpha:1.0];
    _MyTableView.dataSource = self;
    _MyTableView.delegate = self;
    
    //去掉多余的分割线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_MyTableView setTableFooterView:v];
    
    //给表格添加一个尾部视图
    _MyTableView.tableFooterView = [self creatFootView];
    
    [self.view addSubview:_MyTableView];

}

-(UIView *)creatFootView
{
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    //添加一个总价文本框标签
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, 70, 20)];
    lab.text = @"总价:";
    lab.textColor = [UIColor redColor];
    lab.font = [UIFont fontWithName:@"Arial" size:14.0];
    [footView addSubview:lab];
    //全选标签
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 70, 20)];
    lab1.text = @"全选";
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"Arial" size:14.0];
    [footView addSubview:lab1];

    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(115, 15, 20, 20)];
    lab2.text = @"¥";
    lab2.textColor = [UIColor redColor];
    lab2.font = [UIFont fontWithName:@"Arial" size:20.0];
    [footView addSubview:lab2];

    
    //添加全选图片按钮
    _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allSelectBtn.frame = CGRectMake(15, 14, 20, 20);
    [_allSelectBtn setImage:[UIImage imageNamed:@"chooseSex.png"] forState:UIControlStateNormal];
    [_allSelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_allSelectBtn];
    
    //添加一个总价格文本框，用于显示总价
    _allPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(130, 15, 100, 20)];
    _allPriceLab.textColor = [UIColor redColor];
    _allPriceLab.text = @"0.0";
    _allPriceLab.font = [UIFont fontWithName:@"Arial" size:20.0];
    [footView addSubview:_allPriceLab];
    
    
    //添加一个结算按钮
    self.goToPayBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.goToPayBt setTitle:@"去结算" forState:UIControlStateNormal];
    [self.goToPayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.goToPayBt.frame = CGRectMake(self.view.frame.size.width / 3 * 2  , 10, self.view.frame.size.width / 4 + 20, 30);
    self.goToPayBt.backgroundColor = [[UIColor alloc]initWithRed:162.0/255.0 green:73.0/255.0 blue:200/255.0 alpha:1];
    [self.goToPayBt addTarget:self action:@selector(goToPayAction) forControlEvents:UIControlEventTouchUpInside];
    self.goToPayBt.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.goToPayBt.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 0, 0);
    [footView addSubview:self.goToPayBt];    
    return footView;
}
- (void)initArry
{
    
    self.idArry = [[NSMutableArray alloc] init];
    self.nameArry = [[NSMutableArray alloc] init];
    self.priceArry = [[NSMutableArray alloc] init];
    self.markerPriceArry = [[NSMutableArray alloc] init];
    self.imgArry = [[NSMutableArray alloc] init];
    self.imgNameArry = [[NSMutableArray alloc] init];
    self.standardArry = [[NSMutableArray alloc] init];
    self.countArry = [[NSMutableArray alloc] init];
    self.dtlIdArry = [[NSMutableArray alloc] init];
    self.carIdArry = [[NSMutableArray alloc] init];
    self.remainTimeArry = [[NSMutableArray alloc] init];
}

//返回
- (void)backAction
{
   
    [_MyTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goToPayAction
{
    //如果没有选中商品 不能提交到订单
    if (_allPriceLab.text.floatValue != 0.0)
    {
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        //先清空该数组 再把当前的商品加到商品列表中
        [del.listImgArray removeAllObjects];
        [del.listCountArray removeAllObjects];
        [del.listNameArray removeAllObjects];
        [del.listPriceArray removeAllObjects];
        [del.listIdArry removeAllObjects];
        [del.orderGoodsid removeAllObjects];
        [del.dtlidArry removeAllObjects];
        //遍历整个数据源，然后判断如果是选中的商品，加入购物清单（单价 * 商品数量）
        for ( int i =0; i<infoArr.count; i++)
        {
            GoodsInfoModel *model = [infoArr objectAtIndex:i];
            if (model.selectState)
            {
                NSString *price = [NSString stringWithFormat:@"%.2f",model.goodsPrice.floatValue * model.goodsNum];
                [del.listImgArray addObject:model.imageName];
                [del.listCountArray addObject:[NSString stringWithFormat:@"%d",model.goodsNum]];
                [del.listNameArray addObject:model.goodsTitle];
                [del.listPriceArray addObject:price];
                [del.listIdArry addObject:model.goodsId];
                //传值给增加订单的接口
                [del.orderGoodsid addObject:[NSString stringWithFormat:@"%@",model.dtlId]];
                //传给支付界面
                [del.dtlidArry addObject:model.dtlId];
            }
        }
        
        NSLog(@"listId=%@",del.listIdArry);
        NSLog(@"listPrice=%@",del.listPriceArray);
        
        SubmitOrderViewController *view = [[SubmitOrderViewController alloc]initWithNibName:@"SubmitOrderViewController" bundle:nil];
        [self presentViewController:view animated:YES completion:nil];
        //把购物车的总价传给提交订单页
        view.priceLb.text = _allPriceLab.text;
        
        int sum = 0;
        for (int i = 0; i < del.listCountArray.count; i ++)
        {
            NSString *countStr = [NSString stringWithFormat:@"%@",del.listCountArray[i]];
            int count = countStr.intValue;
            sum = sum + count;
        }
        view.totalCountLb.text = [NSString stringWithFormat:@"共%d件",sum];
        //把商品列表的图片传给订单界面
        if (del.listImgArray.count == 1)
        {
            view.goodsImg1.image = del.listImgArray[0];
            view.moreImg.hidden = YES;
            
        }
        else if (del.listImgArray.count == 2)
        {
            view.goodsImg1.image = del.listImgArray[0];
            view.goodsImg2.image = del.listImgArray[1];
            view.moreImg.hidden = YES;
            
        }
        else if (del.listImgArray.count == 3)
        {
            view.goodsImg1.image = del.listImgArray[0];
            view.goodsImg2.image = del.listImgArray[1];
            view.goodsImg3.image = del.listImgArray[2];
            view.moreImg.hidden = YES;
        }
        else if (del.listImgArray.count > 3)
        {
            view.goodsImg1.image = del.listImgArray[0];
            view.goodsImg2.image = del.listImgArray[1];
            view.goodsImg3.image = del.listImgArray[2];
            view.moreImg.hidden = NO;
        }
        

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有结算商品" message:@"请选择商品!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
   
}
//返回单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return infoArr.count;
    return self.nameArry.count;
}

//定制单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *identify =  @"indentify";
    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[MyCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
         cell.delegate = self;
    }
   //调用方法，给单元格赋值
    [cell addTheValue:infoArr[indexPath.row]];
    
    return cell;
}

//返回单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//导航上面的删除
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        //删除购物车接口
        NSString *dtlidStr = self.dtlIdArry[indexPath.row];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C03&loginName=%@&dtlId=%d",del.User,dtlidStr.intValue]];//多个dtlid用逗号隔开
        [_MyTableView reloadData];
        
        NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        NSString *returncode = [dic objectForKey:@"returnCode"];
        if([returncode isEqualToString:@"ok"])
        {
            NSLog(@"删除购物车成功!");
            [self.imgArry removeObjectAtIndex:indexPath.row];
            [self.nameArry removeObjectAtIndex:indexPath.row];
            [self.priceArry removeObjectAtIndex:indexPath.row];
            [self.countArry removeObjectAtIndex:indexPath.row];
            [self.markerPriceArry removeObjectAtIndex:indexPath.row];
            [self.imgNameArry removeObjectAtIndex:indexPath.row];
            [self.standardArry removeObjectAtIndex:indexPath.row];
            [self.idArry removeObjectAtIndex:indexPath.row];
            [self.dtlIdArry removeObjectAtIndex:indexPath.row];
            [self.carIdArry removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

        }
    
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// 指定哪一行可以编辑 哪行不能编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//单元格选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailViewController *view = [[GoodsDetailViewController alloc]init];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.index = indexPath.row;
    
    del.goodsId = self.idArry[indexPath.row];
    //通知中心 输入所要发送的信息 ，同时将label的值通过button方法调用传递，
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:del.goodsId,@"textOne", nil];
    //创建通知  (发送多个通知)
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

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

/**
 *  全选按钮事件
 *
 *  @param sender 全选按钮
 */
-(void)selectBtnClick:(UIButton *)sender
{
    //判断是否选中，是改成否，否改成是，改变图片状态
    sender.tag = !sender.tag;
    if (sender.tag)
    {
        [sender setImage:[UIImage imageNamed:@"chooseSex1.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"chooseSex.png"] forState:UIControlStateNormal];
    }

    
    //改变单元格选中状态
    for (int i=0; i<infoArr.count; i++)
    {
        GoodsInfoModel *model = [infoArr objectAtIndex:i];
        model.selectState = sender.tag;
    }
    //计算价格
    [self totalPrice];
    //刷新表格
    [_MyTableView reloadData];
    
}

#pragma mark -- 实现加减按钮点击代理事件
/**
 *  实现加减按钮点击代理事件
 *
 *  @param cell 当前单元格
 *  @param flag 按钮标识，11 为减按钮，12为加按钮
 */
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSIndexPath *index = [_MyTableView indexPathForCell:cell];
    
    switch (flag) {
        case 11:
        {
            //做减法
            //先获取到当期行数据源内容，改变数据源内容，刷新表格
            GoodsInfoModel *model = infoArr[index.row];
            if (model.goodsNum > 1)
            {
                model.goodsNum --;
            }
            //更新购物车接口
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C02&cartId=%d&prodNumber=%d&dtlId=%d",model.carId.intValue,model.goodsNum,model.dtlId.intValue]];
            NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
            NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dic);
            NSString *returncode = [dic objectForKey:@"returnCode"];
            
            if([returncode isEqualToString:@"ok"])
            {
                NSLog(@"购物车更新成功!");
            }
            else
            {
                NSLog(@"购物车更新失败!");
            }
            
            //获取用户购物车接口
            NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C04&loginName=%@",del.User]];
            
            //jason解析
            NSURLRequest *requestUrl1 = [NSURLRequest requestWithURL:url1];
            NSData *data1 = [NSURLConnection sendSynchronousRequest:requestUrl1 returningResponse:nil error:nil];
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dic1);
            NSString *returncode1 = [dic1 objectForKey:@"returnCode"];
            
            if([returncode1 isEqualToString:@"ok"])
            {
                NSLog(@"购物车获取成功!");
            }
            
        
        }
            break;
        case 12:
        {
            //做加法
            GoodsInfoModel *model = infoArr[index.row];
           
            model.goodsNum ++;
            
            //更新购物车接口
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C02&cartId=%d&prodNumber=%d&dtlId=%d",model.carId.intValue,model.goodsNum,model.dtlId.intValue]];
            NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
            NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dic);
            NSString *returncode = [dic objectForKey:@"returnCode"];
            
            if([returncode isEqualToString:@"ok"])
            {
                NSLog(@"购物车更新成功!");
            }
            else
            {
                NSLog(@"购物车更新失败!");
            }
            
            //获取用户购物车接口
            NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C04&loginName=%@",del.User]];
            
            //jason解析
            NSURLRequest *requestUrl1 = [NSURLRequest requestWithURL:url1];
            NSData *data1 = [NSURLConnection sendSynchronousRequest:requestUrl1 returningResponse:nil error:nil];
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dic1);
            NSString *returncode1 = [dic1 objectForKey:@"returnCode"];
            
            if([returncode1 isEqualToString:@"ok"])
            {
                NSLog(@"购物车获取成功!");
            }
            

        }
            break;
            
        case 13://做单选按钮
        {
            /**
             *  判断当期是否为选中状态，如果选中状态点击则更改成未选中，如果未选中点击则更改成选中状态
             */
            GoodsInfoModel *model = infoArr[index.row];
            
            if (model.selectState)
            {
                model.selectState = NO;
            }
            else
            {
                model.selectState = YES;
            }
            
            //刷新整个表格
            //    [_MyTableView reloadData];
            
            //刷新当前行
            [_MyTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self totalPrice];
        }
        default:
            break;
    }
    
    //刷新表格
    [_MyTableView reloadData];
    
    //计算总价
    [self totalPrice];
    
}

#pragma mark -- 计算价格 个数
-(void)totalPrice
{

    int sum = 0;
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格（单价 * 商品数量）
    for ( int i =0; i<infoArr.count; i++)
    {
        GoodsInfoModel *model = [infoArr objectAtIndex:i];
        if (model.selectState)
        {
            allPrice = allPrice + model.goodsNum * model.goodsPrice.floatValue;
            sum = sum + model.goodsNum;
        }
    }
    
    [self.goToPayBt setTitle:[NSString stringWithFormat:@"去结算(%d)",sum] forState:UIControlStateNormal];

    //给总价文本赋值
    _allPriceLab.text = [NSString stringWithFormat:@"%.2f",allPrice];
    NSLog(@"%f",allPrice);
    
    //每次算完要重置为0，因为每次的都是全部循环算一遍
    allPrice = 0.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
