//
//  StartPageManager.h
//  Lazy
//
//  Created by 君爵信息科技 on 16/3/2.
//  Copyright © 2016年 yinqijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StartPageManager : NSObject

@property(nonatomic,assign)BOOL firstLaunchl;

+ (instancetype)sharedStartPageManager;

@end
