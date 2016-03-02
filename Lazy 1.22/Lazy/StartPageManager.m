//
//  StartPageManager.m
//  Lazy
//
//  Created by 君爵信息科技 on 16/3/2.
//  Copyright © 2016年 yinqijie. All rights reserved.
//

#import "StartPageManager.h"

@implementation StartPageManager

+ (instancetype)sharedStartPageManager{     
    
    static StartPageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    
    return manager;
}

- (instancetype)init{
    
    if (self = [super init]) {
        self.firstLaunchl = YES;
    }
    return self;
}

@end
