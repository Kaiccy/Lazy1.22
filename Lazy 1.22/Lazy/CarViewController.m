//
//  CarViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/29.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "CarViewController.h"
#import "CarTableViewCell.h"
#import "GoodsInfoModel.h"
#import "AppDelegate.h"

@interface CarViewController ()<UITableViewDataSource,UITableViewDelegate,MyCustomCellDelegate>

{
    UITableView *_MyTableView;
    float allPrice;
    NSMutableArray *infoArr;
}

@property(strong,nonatomic)UIButton *allSelectBtn;
@property(strong,nonatomic)UILabel *allPriceLab;

@end

@implementation CarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.title = @"购物车";
    //设置标题的属性样式等
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:23.0f]}];
    
    //初始化数据
    allPrice = 0.0;
    infoArr = [[NSMutableArray alloc]init];
    /**
     *  初始化一个数组，数组里面放字典。字典里面放的是单元格需要展示的数据
     */
    for (int i = 0; i < del.CarNameArray.count; i++)
    {
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
        [infoDict setValue:del.CarImageArray[i] forKey:@"imageName"];
        [infoDict setValue:del.CarNameArray[i] forKey:@"goodsTitle"];
        [infoDict setValue:del.CarPriceArray[i] forKey:@"goodsPrice"];
        [infoDict setValue:[NSNumber numberWithBool:NO] forKey:@"selectState"];
        [infoDict setValue:[NSNumber numberWithInt:1] forKey:@"goodsNum"];
        
        //封装数据模型
        GoodsInfoModel *goodsModel = [[GoodsInfoModel alloc]initWithDict:infoDict];
        
        //将数据模型放入数组中
        [infoArr addObject:goodsModel];
    }
    
    /**
     创建表格，并设置代理
     */
    _MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _MyTableView.dataSource = self;
    _MyTableView.delegate = self;
    
    //给表格添加一个尾部视图
    
    _MyTableView.tableFooterView = [self creatFootView];
    
    [self.view addSubview:_MyTableView];

}

/**
 *  创建表格尾部视图
 *
 *  @return 返回一个UIView 对象视图，作为表格尾部视图
 */
-(UIView *)creatFootView{
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    
    //添加一个全选文本框标签
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 10, 50, 30)];
    lab.text = @"全选";
    [footView addSubview:lab];
    
    //添加全选图片按钮
    _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allSelectBtn.frame = CGRectMake(self.view.frame.size.width- 100, 10, 30, 30);
    [_allSelectBtn setImage:[UIImage imageNamed:@"notchoose.png"] forState:UIControlStateNormal];
    [_allSelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_allSelectBtn];
    
    //添加小结文本框
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 40, 60, 30)];
    lab2.textColor = [UIColor redColor];
    lab2.text = @"小结：";
    [footView addSubview:lab2];
    
    //添加一个总价格文本框，用于显示总价
    _allPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 40, 100, 30)];
    _allPriceLab.textColor = [UIColor redColor];
    _allPriceLab.text = @"0.0";
    [footView addSubview:_allPriceLab];
    
    
    //添加一个结算按钮
    UIButton *settlementBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [settlementBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settlementBtn.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, 30);
    settlementBtn.backgroundColor = [UIColor blueColor];
    [footView addSubview:settlementBtn];
    
    
    return footView;
}

//返回单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return infoArr.count;
}
//定制单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify =  @"indentify";
    CarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[CarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
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

//单元格选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  判断当期是否为选中状态，如果选中状态点击则更改成未选中，如果未选中点击则更改成选中状态
     */
    GoodsInfoModel *model = infoArr[indexPath.row];
    
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
    [_MyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self totalPrice];
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
        [sender setImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateNormal];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"notchoose.png"] forState:UIControlStateNormal];
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
        }
            break;
        case 12:
        {
            //做加法
            GoodsInfoModel *model = infoArr[index.row];
            
            model.goodsNum ++;
            
        }
            break;
        default:
            break;
    }
    
    //刷新表格
    [_MyTableView reloadData];
    
    //计算总价
    [self totalPrice];
    
}

#pragma mark -- 计算价格
-(void)totalPrice
{
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格（单价 * 商品数量）
    for ( int i =0; i<infoArr.count; i++)
    {
        GoodsInfoModel *model = [infoArr objectAtIndex:i];
        if (model.selectState)
        {
            allPrice = allPrice + model.goodsNum *[model.goodsPrice intValue];
        }
    }
    
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
