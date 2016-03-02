//
//  UserLoginViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "UserLoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "MyAccountViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "UMSocial.h"

@class MainViewController;

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    self.telnumTextField.delegate = self;
    self.sureTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.rtelnumTextField.delegate = self;
    self.rsurePwdTextField.delegate = self;
    self.rsurecodeTextField.delegate = self;
    self.rpwdTextField.delegate = self;
    
    //获取验证码初始化时间
    self.second = 60;
    
    //初始化沙盒数据库路径
    self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FMDB.sqlite"];
    //创建FMDatabase对象,参数为沙盒路径
    //沙盒路径文件路径无需真实存在，如果不存在会自动创建。
    self.db = [FMDatabase databaseWithPath:self.path];
    //允许数据库缓存提升查询效率
    [self.db setShouldCacheStatements:YES];
    //打开所需数据库
    [self DBInitialization];


}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.geCodetBt.layer.borderWidth = 1.0;
    self.geCodetBt.layer.borderColor = [[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] CGColor];
    
    self.rgetCodeBt.layer.borderWidth = 1.0;
    self.rgetCodeBt.layer.borderColor = [[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] CGColor];
    
    self.registerBt.backgroundColor = [UIColor colorWithRed:162.0/255.0 green:73.0/255.0 blue:200.0/255.0 alpha:1.0];
    [self.registerBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.weixinBt.frame = CGRectMake(self.view.frame.size.width / 2 - 20, 401, 45, 45);
    self.weixinLb.frame = CGRectMake(self.view.frame.size.width / 2 - 20, 454, 42, 21);
    
    self.forgetPwdBt.frame = CGRectMake(self.telnumTextField.frame.origin.x + self.telnumTextField.frame.size.width - 60, self.sureLoginBt.frame.origin.y + 45, 60, 20);
    self.rightnowBt.frame = CGRectMake(self.telnumTextField.frame.origin.x, self.sureLoginBt.frame.origin.y + 45, 80, 20);

    
    //隐藏注册界面
    self.registerView.hidden = YES;
    self.geCodetBt.hidden = YES;
    self.sureTextField.hidden = YES;
}

//数据库初始化
- (void)DBInitialization
{
    //打开数据库
    if ([self.db open])
    {
        //判断登录状态表是否存在
        if (![self.db tableExists :@"LOGIN_STATE"])
        {
            //创建登录状态表
            if ([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS LOGIN_STATE (TEL TEXT PRIMARY KEY, LOGIN TEXT NOT NULL, NICKNAME TEXT);"])
            {
                NSLog(@"创建“LOGIN_STATE”表成功！");
            }
            else
            {
                NSLog(@"创建“LOGIN_STATE”表失败！");
            }
        }
    }
    else
    {
        NSLog(@"打开数据库失败！");
    }
}


//成为第一响应者 弹出键盘
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
//当点击键盘上return按钮的时候调用
{
    //代理记录了当前正在工作的UITextField的实例，因此你点击哪个UITextField对象，形参就是哪个UITextField对象
    [textField resignFirstResponder];//键盘回收代码
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 2 ||textField.tag == 4)
    {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11 || strLength < 0)
        {
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0)
        {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }
        else
        {
            text = [textField.text substringToIndex:range.location];
        }
        if ([self isMobile:text])
        {
            [self.geCodetBt setEnabled:YES];
            [self.rgetCodeBt setEnabled:YES];
            [self.sureLoginBt setEnabled:YES];
            [self.rightNowRegisterBt setEnabled:YES];

        }
        else
        {
            [self.geCodetBt setEnabled:NO];
            [self.rgetCodeBt setEnabled:NO];
            [self.sureLoginBt setEnabled:NO];
            [self.rightNowRegisterBt setEnabled:NO];
        }
    }
    return YES;
}

//检测是否是手机号码
- (BOOL)isMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//切换登录和注册的两个按钮
- (IBAction)loginBt:(id)sender
{
    self.registerBt.backgroundColor = [UIColor colorWithRed:162.0/255.0 green:73.0/255.0 blue:200.0/255.0 alpha:1.0];
    [self.registerBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.loginBt.backgroundColor = [[UIColor alloc]initWithRed:248.0/255.0 green:250.0/255.0 blue:248.0/255.0 alpha:1.0];
    [self.loginBt setTitleColor:[[UIColor alloc]initWithRed:162.0/255.0 green:73.0/255.0 blue:200.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    self.registerView.hidden = YES;
}

- (IBAction)registerBt:(id)sender
{
    self.loginBt.backgroundColor = [UIColor colorWithRed:162.0/255.0 green:73.0/255.0 blue:200.0/255.0 alpha:1.0];
    [self.loginBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.registerBt.backgroundColor = [[UIColor alloc]initWithRed:248.0/255.0 green:250.0/255.0 blue:248.0/255.0 alpha:1.0];
    [self.registerBt setTitleColor:[[UIColor alloc]initWithRed:162.0/255.0 green:73.0/255.0 blue:200.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    self.registerView.hidden = NO;
}

//获取登录验证码按钮
- (IBAction)getCodeBt:(id)sender
{
    if (self.telnumTextField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入手机号码" message:@"手机号码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A01&phoneNumber=%@",self.telnumTextField.text]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        request.didFinishSelector = @selector(requestFinishedAction:);
        request.didFailSelector = @selector(requestFailed:);
        [request startSynchronous];
    }
}

//请求成功
-(void)requestFinishedAction:(ASIHTTPRequest *)request
{
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if ([returncode isEqualToString:@"ok"])
    {
        self.loginCodeTimeLb.hidden = NO;
        self.geCodetBt.hidden = YES;
        self.loginCodeTimeLb.text = [NSString stringWithFormat:@"还剩%d秒",self.second];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(descreaseTimeAction1:) userInfo:nil repeats:YES];
    }
}
//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}
//倒计时
- (void)descreaseTimeAction1:(NSTimer *)tm{
    //一分钟之内不能再点击获取验证吗按钮
    self.geCodetBt.enabled = NO;
    self.second = self.second - 1;
    self.loginCodeTimeLb.text = [NSString stringWithFormat:@"还剩%d秒",self.second];
    if (self.second == 0){
        [tm invalidate];
        self.geCodetBt.enabled = YES;
        self.loginCodeTimeLb.hidden = YES;
        self.geCodetBt.hidden = NO;
    }
}
//确定登录
- (IBAction)sureLoginBt:(id)sender
{
    if ((self.telnumTextField.text.length > 0 && self.pwdTextField.text.length > 0) || (self.telnumTextField.text.length > 0 && self.sureTextField.text.length > 0))
    {
        //用户信息获取接口
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A02&phoneNumber=%@",self.telnumTextField.text]];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess1:)];
        [requestUrl setDidFailSelector:@selector(requestError1:)];
        [requestUrl startSynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:@"请检查输入错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)requestSuccess1:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnListArry = [dic objectForKey:@"returnList"];
    if ([returncode isEqualToString:@"ok"])
    {
        NSLog(@"登录用户信息获取成功");
    }
    if (returnListArry.count != 0)
    {
        self.pwdStr = [returnListArry[0] objectForKey:@"passwd"];
    }
    //校验验证码
    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A06&phoneNumber=%@&registerKey=%@",self.telnumTextField.text,self.sureTextField.text]];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url1];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess2:)];
    [requestUrl setDidFailSelector:@selector(requestError2:)];
    [requestUrl startSynchronous];
}

- (void)requestError1:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)requestSuccess2:(ASIHTTPRequest *)request{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSData *data  = [request responseData];
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic1);
    NSString *returncode1 = [dic1 objectForKey:@"returnCode"];
    if([returncode1 isEqualToString:@"ok"])
    {
        NSLog(@"校验密码成功!");
    }
    
    //判断用户是否匹配  匹配就直接跳回主页
    
    //MD5加密
    const char *cStr = [self.pwdTextField.text UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    int length = (int)self.pwdTextField.text.length;
    CC_MD5( cStr, length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    NSLog(@"result = %@",result);
    
    if ([result isEqualToString:self.pwdStr] || [returncode1 isEqualToString:@"ok"] || [self.pwdTextField.text isEqualToString:self.pwdStr])
    {
        //清除登录状态表之前的表记录
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM LOGIN_STATE"];
        if (![self.db executeUpdate:sqlstr])
        {
            NSLog(@"Erase table error!");
        }
        else
        {
            NSLog(@"Erase table success!");
        }
        
        //修改该账号的登录状态为YES
        NSString *insertSql1 = [NSString stringWithFormat:@"INSERT INTO LOGIN_STATE (TEL, LOGIN) VALUES ('%@', '%@')",self.telnumTextField.text, @"YES"];
        [self.db executeUpdate:insertSql1];
        
        if ([self.db close])
        {
            NSLog(@"登录页面数据库已关闭");
        }
        else
        {
            NSLog(@"登录页面数据库关闭失败");
        }
    
        del.User = self.telnumTextField.text;
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录错误" message:@"登录名或密码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }

}

- (void)requestError2:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//QQ登录
- (IBAction)qqBt:(id)sender
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取QQ用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //创建用户接口
            NSURL *url1 = [NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A03&loginName=%@&passwd=123456&loginType=2&nickName=%@&sexType=%d&userName=%@",del.User,del.userNickName,self.sexType,del.User] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url1];
            [requestUrl setDelegate:self];
            [requestUrl setRequestMethod:@"GET"];
            [requestUrl setTimeOutSeconds:60];
            [requestUrl setDidFinishSelector:@selector(requestSuccess3:)];
            [requestUrl setDidFailSelector:@selector(requestError3:)];
            [requestUrl startSynchronous];
            
            //取头像
            NSURL *url = [NSURL URLWithString:self.imgUrlStr];
            //异步
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            //设置请求方式 时间
            [request setTimeOutSeconds:60];
            [request setRequestMethod:@"GET"];
            [request setDidFinishSelector:@selector(requestSuccess6:)];
            [request setDidFailSelector:@selector(requestError6:)];
            [request setDelegate:self];
            [request startSynchronous];
            
        }});
    //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        
        del.User = [response.data objectForKey:@"uid"];
        del.userNickName = [response.data objectForKey:@"screen_name"];
        self.imgUrlStr = [response.data objectForKey:@"profile_image_url"];
        NSString *sex = [response.data objectForKey:@"gender"];
        if (sex.intValue == 0)//女
        {
            self.sexType = 2;
        }
        else
        {
            self.sexType = 1;
        }

    }];

}

- (void)requestSuccess3:(ASIHTTPRequest *)request
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if ([returncode isEqualToString:@"ok"])
    {
        NSLog(@"第三方QQ用户创建成功！");
    }
    
    //清除登录状态表之前的表记录
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM LOGIN_STATE"];
    if (![self.db executeUpdate:sqlstr])
    {
        NSLog(@"Erase table error!");
    }
    else
    {
        NSLog(@"Erase table success!");
    }

    //修改该账号的登录状态为YES
    NSString *insertSql1 = [NSString stringWithFormat:@"INSERT INTO LOGIN_STATE (TEL, LOGIN, NICKNAME) VALUES ('%@', '%@', '%@')",del.User, @"YES", del.userNickName];
    [self.db executeUpdate:insertSql1];
    
    if ([self.db close])
    {
        NSLog(@"登录数据库已关闭");
    }
    else
    {
        NSLog(@"登录数据库关闭失败");
    }

}

- (void)requestError3:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//微信登录
- (IBAction)weichatBt:(id)sender
{
    if ([WXApi isWXAppInstalled])
    {
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
                //创建用户接口
                NSURL *url1 = [NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A03&loginName=%@&passwd=123456&loginType=2&nickName=%@&sexType=%d&userName=%@",del.User,del.userNickName,self.sexType,del.User] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url1];
                [requestUrl setDelegate:self];
                [requestUrl setRequestMethod:@"GET"];
                [requestUrl setTimeOutSeconds:60];
                [requestUrl setDidFinishSelector:@selector(requestSuccess4:)];
                [requestUrl setDidFailSelector:@selector(requestError4:)];
                [requestUrl startSynchronous];
                
                //取头像
                NSURL *url = [NSURL URLWithString:self.imgUrlStr];
                //异步
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                //设置请求方式 时间
                [request setTimeOutSeconds:60];
                [request setRequestMethod:@"GET"];
                [request setDidFinishSelector:@selector(requestSuccess6:)];
                [request setDidFailSelector:@selector(requestError6:)];
                [request setDelegate:self];
                [request startSynchronous];
            
            }});
        
        //得到的数据在回调Block对象形参respone的data属性
        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
            NSLog(@"SnsInformation is %@",response.data);
            
            del.User = [response.data objectForKey:@"uid"];
            del.userNickName = [response.data objectForKey:@"screen_name"];
            self.imgUrlStr = [response.data objectForKey:@"profile_image_url"];
            NSString *sex = [response.data objectForKey:@"gender"];
            if (sex.intValue == 0)//女
            {
                self.sexType = 2;
            }
            else
            {
                self.sexType = 1;
            }
            
        }];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有微信客户端" message:@"请安装微信客户端后再登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)requestSuccess4:(ASIHTTPRequest *)request
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if ([returncode isEqualToString:@"ok"])
    {
        NSLog(@"第三方微信用户创建成功！");
    }
    //清除登录状态表之前的表记录
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM LOGIN_STATE"];
    if (![self.db executeUpdate:sqlstr])
    {
        NSLog(@"Erase table error!");
    }
    else
    {
        NSLog(@"Erase table success!");
    }

    //修改该账号的登录状态为YES
    NSString *insertSql1 = [NSString stringWithFormat:@"INSERT INTO LOGIN_STATE (TEL, LOGIN, NICKNAME) VALUES ('%@', '%@', '%@')",del.User, @"YES", del.userNickName];
    [self.db executeUpdate:insertSql1];
    
    if ([self.db close])
    {
        NSLog(@"登录数据库已关闭");
    }
    else
    {
        NSLog(@"登录数据库关闭失败");
    }
    
}

- (void)requestError4:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//新浪微博登录
- (IBAction)weiboBt:(id)sender
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);

            //创建用户接口
            NSURL *url1 = [NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A03&loginName=%@&passwd=123456&loginType=2&nickName=%@&sexType=%d&userName=%@",del.User,del.userNickName,self.sexType,del.User] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
            ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url1];
            [requestUrl setDelegate:self];
            [requestUrl setRequestMethod:@"GET"];
            [requestUrl setTimeOutSeconds:60];
            [requestUrl setDidFinishSelector:@selector(requestSuccess5:)];
            [requestUrl setDidFailSelector:@selector(requestError5:)];
            [requestUrl startSynchronous];
            
            
            //取头像
            NSURL *url = [NSURL URLWithString:self.imgUrlStr];
            //异步
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            //设置请求方式 时间
            [request setTimeOutSeconds:60];
            [request setRequestMethod:@"GET"];
            [request setDidFinishSelector:@selector(requestSuccess6:)];
            [request setDidFailSelector:@selector(requestError6:)];
            [request setDelegate:self];
            [request startSynchronous];

        }});
    
    //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        del.User = [response.data objectForKey:@"uid"];
        del.userNickName = [response.data objectForKey:@"screen_name"];
        self.imgUrlStr = [response.data objectForKey:@"profile_image_url"];
        NSString *sex = [response.data objectForKey:@"gender"];
        if (sex.intValue == 0)//女
        {
            self.sexType = 2;
        }
        else
        {
            self.sexType = 1;
        }

    }];
    
    
}

- (void)requestSuccess5:(ASIHTTPRequest *)request
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if ([returncode isEqualToString:@"ok"])
    {
        NSLog(@"第三方微博用户创建成功！");
    }
    
    //清除登录状态表之前的表记录
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM LOGIN_STATE"];
    if (![self.db executeUpdate:sqlstr])
    {
        NSLog(@"Erase table error!");
    }
    else
    {
        NSLog(@"Erase table success!");
    }

    //修改该账号的登录状态为YES
    NSString *insertSql1 = [NSString stringWithFormat:@"INSERT INTO LOGIN_STATE (TEL, LOGIN, NICKNAME) VALUES ('%@', '%@', '%@')",del.User, @"YES", del.userNickName];
    [self.db executeUpdate:insertSql1];
    
    if ([self.db close])
    {
        NSLog(@"登录数据库已关闭");
    }
    else
    {
        NSLog(@"登录数据库关闭失败");
    }

}

- (void)requestError5:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)requestSuccess6:(ASIHTTPRequest *)request
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSData *data = request.responseData;
    del.HeadImage = [UIImage imageWithData:data];
    NSLog(@"img = %@",del.HeadImage);
    if (request.didUseCachedResponse)
    {
        NSLog(@"come from cache!");
    }
    else
    {
        NSLog(@"come from net!");
    }
    //将选择的图片放到沙盒中
    NSString *HeadPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",del.User]];
    NSLog(@"headPath = %@",HeadPath);
    //将图片输出为png,并写入沙盒指定路径
    NSData *data1 = UIImagePNGRepresentation(del.HeadImage);
    [data1 writeToFile:HeadPath atomically:YES];
    
}

- (void)requestError6:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//注册时获得验证码
- (IBAction)rgetCodeBt:(id)sender
{
    if (self.rtelnumTextField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入手机号码" message:@"手机号码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }

    else
    {
        //上传数据
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A01&phoneNumber=%@",self.rtelnumTextField.text]];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess7:)];
        [requestUrl setDidFailSelector:@selector(requestError7:)];
        [requestUrl startSynchronous];
    }
    
}

- (void)requestSuccess7:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    
    if ([returncode isEqualToString:@"ok"])
    {
        self.registerCodeLb.hidden = NO;
        self.rgetCodeBt.hidden = YES;
        self.registerCodeLb.text = [NSString stringWithFormat:@"还剩%d秒",self.second];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(descreaseTimeAction2:) userInfo:nil repeats:YES];
    }
}

- (void)requestError7:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)descreaseTimeAction2:(NSTimer *)tm
{
    //一分钟之内不能再点击获取验证吗按钮
    self.rgetCodeBt.enabled = NO;
    self.second = self.second - 1;
    self.registerCodeLb.text = [NSString stringWithFormat:@"还剩%d秒",self.second];
    if (self.second == 0)
    {
        [tm invalidate];
        self.rgetCodeBt.enabled = YES;
        self.registerCodeLb.hidden = YES;
        self.rgetCodeBt.hidden = NO;
    }
    

}
//立即注册
- (IBAction)rightNowRegisterBt:(id)sender
{
    if (self.rtelnumTextField.text.length != 0 && self.rpwdTextField.text.length >= 6 && self.rpwdTextField.text.length <= 12 && self.rsurecodeTextField.text.length != 0 && [self.rpwdTextField.text isEqualToString:self.rsurePwdTextField.text])
    {
        //校验验证码
        NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A06&phoneNumber=%@&registerKey=%@",self.rtelnumTextField.text,self.rsurecodeTextField.text]];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url1];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess8:)];
        [requestUrl setDidFailSelector:@selector(requestError8:)];
        [requestUrl startSynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:@"请检查输入错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }

}

- (void)requestSuccess8:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic1);
    NSString *returncode1 = [dic1 objectForKey:@"returnCode"];
    if([returncode1 isEqualToString:@"ok"])
    {
        NSLog(@"校验密码成功!");
    }
    
    //如果账号密码不为空，则视为有效注册
    if (self.rtelnumTextField.text.length != 0 && self.rpwdTextField.text.length >= 6 && self.rpwdTextField.text.length <= 12 && self.rsurecodeTextField.text.length != 0 && [self.rpwdTextField.text isEqualToString:self.rsurePwdTextField.text] && [returncode1 isEqualToString:@"ok"])
    {
        //创建用户接口
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A03&loginName=%@&passwd=%@&loginType=1&phoneNumber=%@",self.rtelnumTextField.text,self.rpwdTextField.text,self.rtelnumTextField.text]];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess9:)];
        [requestUrl setDidFailSelector:@selector(requestError9:)];
        [requestUrl startSynchronous];

        
    }
    else
    {
        
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"请检查输入内容是否错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert1 show];
    }

}

- (void)requestError8:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)requestSuccess9:(ASIHTTPRequest *)request
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if ([returncode isEqualToString:@"ok"])
    {
        //注册成功，隐藏注册界面
        self.registerView.hidden = YES;
        
        NSLog(@"注册成功！");
    }
    
    //传值
    del.pwdStr = self.rpwdTextField.text;
    del.loginNameStr = self.rtelnumTextField.text;

}

- (void)requestError9:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (IBAction)forgetpwdBt:(id)sender
{
    ForgotPasswordViewController *view = [[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
}

- (IBAction)telloginBt:(id)sender
{
    self.geCodetBt.hidden = NO;
    self.sureTextField.hidden = NO;
    self.pwdTextField.hidden = YES;
}
@end
