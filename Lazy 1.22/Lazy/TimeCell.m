//
//  TimeCell.m
//  CountDownTimerForTableView
//
//  Created by FrankLiu on 15/9/14.
//  Copyright (c) 2015年 FrankLiu. All rights reserved.
//

#import "TimeCell.h"
#import "TimeModel.h"
#import "CommonMacro.h"

@interface TimeCell ()

@property (nonatomic, strong) UIView      *m_backgroundView;
@property (nonatomic, strong) UILabel     *m_titleLabel;
@property (nonatomic, strong) UILabel     *m_timeLabel;
@property (nonatomic, weak)   id           m_data;
@property (nonatomic, weak)   NSIndexPath *m_tmpIndexPath;
@property (strong, nonatomic) UIImageView *goodsImage;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *stopBuyLb;
@property (copy, nonatomic) NSString *goodsId;
@end

@implementation TimeCell

- (void)defaultConfig
{

    [self registerNSNotificationCenter];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    
}

- (void)buildViews
{

    self.m_backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 120)];
    [self addSubview:_m_backgroundView];
    
    _m_backgroundView.backgroundColor = [UIColor whiteColor];
    
    // 标题
    self.m_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width - 150, 10, 150, 40)];
    [_m_backgroundView addSubview:_m_titleLabel];
    _m_titleLabel.textColor = [UIColor blackColor];
    _m_titleLabel.font      = [UIFont systemFontOfSize:15.0];
    
    // 倒计时
    self.m_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width - 130, 55, 100, 30)];
    [_m_backgroundView addSubview:_m_timeLabel];
    
    _m_timeLabel.textColor     = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    _m_timeLabel.font          = [UIFont systemFontOfSize:14.0];
    
    //价格
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width - 120, 35, Width - 40, 30)];
    [_m_backgroundView addSubview:_priceLabel];
    
    _priceLabel.textColor     = [UIColor redColor];
    _priceLabel.font          = [UIFont systemFontOfSize:16.0];
    
    //仅需
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(Width - 150, 35, 30, 30)];
    [_m_backgroundView addSubview:lb1];
    
    lb1.textColor = [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    lb1.text = @"仅需";
    lb1.font = [UIFont systemFontOfSize:11.0];
    
    //时钟
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 150, 62.5, 15, 15)];
    img.image = [UIImage imageNamed:@"clock1.png"];
    [_m_backgroundView addSubview:img];
    
}

- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath
{
    
    if ([data isMemberOfClass:[TimeModel class]])
    {
        
        [self storeWeakValueWithData:data indexPath:indexPath];
        
        TimeModel *model = (TimeModel*)data;
        
        _m_titleLabel.text = model.titleStr;
        _m_timeLabel.text  = [NSString stringWithFormat:@"%@",[model currentTimeString]];
        _priceLabel.text = model.goodsPrice;
        _goodsId = model.goodsId;

    }
    
}

- (void)storeWeakValueWithData:(id)data indexPath:(NSIndexPath *)indexPath
{
    
    self.m_data         = data;
    self.m_tmpIndexPath = indexPath;
}

- (void)dealloc
{
    
    [self removeNSNotificationCenter];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:nil];
}

- (void)removeNSNotificationCenter
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
}

- (void)notificationCenterEvent:(id)sender
{
    
    if (self.isDisplayed)
    {
        [self loadData:self.m_data indexPath:self.m_tmpIndexPath];
    }
}



@end
