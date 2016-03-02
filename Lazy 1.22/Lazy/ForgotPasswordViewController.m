//
//  ForgotPasswordViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/10.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    self.second = 60;
}

- (void)layout
{
    //屏幕适配
    self.view.frame = [[UIScreen mainScreen]bounds];
    
    self.titleLb.frame = CGRectMake(0, 0, self.view.frame.size.width, 75);
    self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    
    self.getCodeBt.layer.borderWidth = 1.0;
    self.getCodeBt.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.telTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.secondPwdTextFied.delegate = self;
    self.codeTextField.delegate = self;
}

//成为第一响应者 弹出键盘
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self becomeFirstResponder];
}

//辞去第一响应者 隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
//当点击键盘上return按钮的时候调用
{
    [textField resignFirstResponder];//键盘回收代码
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//确认
- (IBAction)sureBt:(id)sender
{
    if (self.telTextField.text.length > 0 && self.pwdTextField.text.length >= 6 && self.pwdTextField.text.length <= 12 && self.codeTextField.text.length > 0 && [self.pwdTextField.text isEqualToString:self.secondPwdTextFied.text])
    {
        //校验验证码
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A06&phoneNumber=%@&registerKey=%@",self.telTextField.text,self.codeTextField.text]];
        
        ASIHTTPRequest *requestUrl = [ ASIHTTPRequest requestWithURL :url];
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

//请求成功
- (void)requestSuccess1:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"校验密码成功!");
    }
    
    if (self.telTextField.text.length > 0 && self.pwdTextField.text.length >= 6 && self.pwdTextField.text.length <= 12 && self.codeTextField.text.length > 0 && [self.pwdTextField.text isEqualToString:self.secondPwdTextFied.text] && [returncode isEqualToString:@"ok"])
    {
        
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        //重置密码接口
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A05&loginName=%@&passwd=%@&registerKey=%@",del.User,self.pwdTextField.text,self.codeTextField.text]];
        
        ASIHTTPRequest *requestUrl = [ ASIHTTPRequest requestWithURL :url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess2:)];
        [requestUrl setDidFailSelector:@selector(requestError2:)];
        [requestUrl startSynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:@"请检查输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }

}

//请求失败
- (void)requestError1:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)requestSuccess2:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    self.returncode = [dic objectForKey:@"returnCode"];
    if([self.returncode isEqualToString:@"ok"])
    {
        NSLog(@"重置密码成功!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)requestError2:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//获取验证码
- (IBAction)getCodeBt:(id)sender
{
    if (self.telTextField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入手机号码" message:@"手机号码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];

    }
    else
    {
        //获取验证码
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A01&phoneNumber=%@",self.telTextField.text]];
        
        ASIHTTPRequest *requestUrl = [ ASIHTTPRequest requestWithURL :url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess3:)];
        [requestUrl setDidFailSelector:@selector(requestError3:)];
        [requestUrl startSynchronous];

    }
}

- (void)requestSuccess3:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if ([returncode isEqualToString:@"ok"])
    {
        self.timeCountLb.hidden = NO;
        self.getCodeBt.hidden = YES;
        self.timeCountLb.text = [NSString stringWithFormat:@"还剩%d秒",self.second];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(descreaseTimeAction1:) userInfo:nil repeats:YES];
    }

    
}

- (void)requestError3:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

//倒计时
- (void)descreaseTimeAction1:(NSTimer *)tm
{
    //一分钟之内不能再点击获取验证吗按钮
    self.getCodeBt.enabled = NO;
    self.second = self.second - 1;
    self.timeCountLb.text = [NSString stringWithFormat:@"还剩%d秒",self.second];
    if (self.second == 0)
    {
        [tm invalidate];
        self.getCodeBt.enabled = YES;
        self.timeCountLb.hidden = YES;
        self.getCodeBt.hidden = NO;
    }
}


@end
