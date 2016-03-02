//
//  TimeModel.m
//  CountDownTimerForTableView
//
//  Created by FrankLiu on 15/9/10.
//  Copyright (c) 2015年 FrankLiu. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.titleStr = dict[@"goodsTitle"];
        self.countNum = [dict[@"count"] intValue];
        self.goodsPrice = dict[@"goodsPrice"];
        self.goodsId = dict[@"goodsId"];
        self.dtlId = dict[@"dtlId"];
    }
    return  self;
}

- (void)countDown
{

    _countNum -= 1;
}

- (NSString*)currentTimeString
{

    if (_countNum <= 0)
    {
        
        return @"00:00:00";
        
    }
    
    else
    {
        int inputSeconds = _countNum;
        int hours =  inputSeconds / 3600;
        int minutes = ( inputSeconds - hours * 3600 ) / 60;
        int seconds = inputSeconds - hours * 3600 - minutes * 60;
        
        NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, seconds];

        
        //return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)_countNum/3600,(long)_countNum%3600/60,(long)_countNum%60];
        return strTime;
    }
}

@end
