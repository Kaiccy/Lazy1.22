//
//  AppDelegate.m
//  Lazy
//
//  Created by yinqijie on 15/9/22.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "AppDelegate.h"
#import "TransitionViewController.h"
#import "MainViewController.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
//友盟更新
#import "UMCheckUpdate.h"
#import "MobClick.h"

#import <AlipaySDK/AlipaySDK.h>

#import "payRequsestHandler.h"

#import "StartPageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //设置搭档缺省头像
    self.DefaultAvatar = [[UIImage alloc]init];
    self.DefaultAvatar = [UIImage imageNamed:@"user.png"];
    
    [self.window makeKeyAndVisible];
    
    //注册第三方登录
    [UMSocialData setAppKey:@"561e14e067e58e858f000c1f"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104911897" appKey:@"EhiFMvxqwUQnnA6d" url:@"http://www.umeng.com/social"];
    
    [UMSocialWechatHandler setWXAppId:@"wx16408db628773d61" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.umeng.com/social"];
    
    //[UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"585317554" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    // 向微信终端注册appID
    [WXApi registerApp:@"wx16408db628773d61" withDescription:@"demo 2.0"];

    //百度地图Key
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"YZA1TOxz0A3rHLOUP4dZ2lXy"  generalDelegate:nil];
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }
    
    //版本更新
    [UMCheckUpdate checkUpdateWithAppkey:@"561e14e067e58e858f000c1f" channel:@"www.umtrack.com"];
    [UMCheckUpdate checkUpdate:@"更新版本" cancelButtonTitle:@"取消" otherButtonTitles:@"去商店" appkey:@"561e14e067e58e858f000c1f" channel:@"www.umtrack.com"];
    
    //统计
    [MobClick startWithAppkey:@"561e14e067e58e858f000c1f" reportPolicy:BATCH   channelId:@""];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick profileSignInWithPUID:@"playerID"];
    [MobClick profileSignInWithPUID:@"playerID" provider:@"WB"];
    
    
    //初始化沙盒路径,并将命名文件名为FMDB
    self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FMDB.sqlite"];
    NSLog(@"%@",self.path);
    
    //创建FMDatabase对象,参数为沙盒路径
    //沙盒路径文件路径无需真实存在，如果不存在会自动创建。
    self.db = [FMDatabase databaseWithPath:self.path];
    //允许数据库缓存提升查询效率
    [self.db setShouldCacheStatements:YES];
    //打开所需数据库
    [self DBInitialization];
    
    //实现自动登录
    //查询所有的登录信息
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM LOGIN_STATE"];
    //遍历登录状态数据
    if([resultSet next])
    {
        NSString *user = [resultSet stringForColumn:@"TEL"];
        NSString *isLOGIN = [resultSet stringForColumn:@"LOGIN"];
        self.name = [resultSet stringForColumn:@"NICKNAME"];
        NSLog(@"user = %@ islogin = %@",user,isLOGIN);
        
        //如果存在已登录 跳转到主页面
        if ([isLOGIN isEqualToString:@"YES"] || [StartPageManager sharedStartPageManager].firstLaunchl == NO)
        {
    
            MainViewController *view = [[MainViewController alloc]init];
            self.window.rootViewController = view;
            //为该用户设置全局头像
            self.User = user;
            NSLog(@"自动登录成功");
            //如果已经登录  设置登录昵称
            NSLog(@"name = %@",self.name);
            if (self.name.length != 0)
            {
                [view.loginBt setTitle:self.name forState:UIControlStateNormal];
                
            }
            else if (self.userNickName != nil)
            {
                [view.loginBt setTitle:self.userNickName forState:UIControlStateNormal];
            }
            else
            {
                [view.loginBt setTitle:self.User forState:UIControlStateNormal];
            }
            if ([self.db close])
            {
                NSLog(@"登录页面数据库已关闭");
            }
            else{
                NSLog(@"登录页面数据库关闭失败");
            }
            //停止遍历
            //break;
        }
        
    }
    
    else
    {
        //如果没有该表 就先跳到欢迎界面
        TransitionViewController *tranView = [[TransitionViewController alloc]init];
        self.window.rootViewController = tranView;
        
        //下次进入应用的时候就不需要再显示引导页
        [StartPageManager sharedStartPageManager].firstLaunchl = NO;
    }

    //初始化数组
    self.tempArry = [[NSMutableArray alloc] init];
    
    self.personNameArray = [[NSMutableArray alloc] init];
    self.personTelArray = [[NSMutableArray alloc] init];
    self.provinceArray = [[NSMutableArray alloc] init];
    self.cityArry = [[NSMutableArray alloc] init];
    self.areaArry = [[NSMutableArray alloc] init];
    self.courtArray = [[NSMutableArray alloc] init];
    self.courtNumberArray = [[NSMutableArray alloc] init];
    
    self.listImgArray = [[NSMutableArray alloc] init];
    self.listNameArray = [[NSMutableArray alloc] init];
    self.listPriceArray = [[NSMutableArray alloc] init];
    self.listCountArray = [[NSMutableArray alloc] init];
    self.listIdArry = [[NSMutableArray alloc] init];
    
    self.addressIdArry = [[NSMutableArray alloc] init];
    self.addflagArry = [[NSMutableArray alloc] init];
    
    self.orderGoodsid = [[NSMutableArray alloc] init];
    self.orderGoodsCount = [[NSMutableArray alloc] init];
    self.dtlidArry = [[NSMutableArray alloc] init];

    return YES;
}

//数据库初始化
- (void)DBInitialization
{
    if ([self.db open])
    {
        NSLog(@"首页打开数据库成功");
    }
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //1.支付宝
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){ //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    //2.微信
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]])
    {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            }
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                break;
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
