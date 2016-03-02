//
//  AddressManageViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "AddressManageViewController.h"
#import "AppDelegate.h"

@interface AddressManageViewController ()

@end

@implementation AddressManageViewController

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    self.view.frame = [[UIScreen mainScreen]bounds];

    self.personNameTextField.delegate = self;
    self.telTextField.delegate = self;
    self.provinceTextField.delegate = self;
    self.cityTextFied.delegate = self;
    self.areaTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
//当点击键盘上return按钮的时候调用
{
    //代理记录了当前正在工作的UITextField的实例，因此你点击哪个UITextField对象，形参就是哪个UITextField对象
    [textField resignFirstResponder];//键盘回收代码
    return YES;
}

- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBt:(id)sender
{
    NSString *str4 = [self.provinceTextField.text substringToIndex:3];
    NSLog(@"str4 = %@",str4);
    NSString *str5 =[self.provinceTextField.text substringWithRange:NSMakeRange(3,3)];
    NSLog(@"str5 = %@",str5);
    NSString *str6 = [self.provinceTextField.text substringFromIndex:6];
    NSLog(@"str6 = %@",str6);

    if (self.personNameTextField.text.length < 1 || self.telTextField.text.length < 1 || self.provinceTextField.text.length < 1 || self.areaTextField.text.length < 1 || self.cityTextFied.text.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:@"请检查输入错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }

    else
    {
        //修改收货地址接口
        NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C06&addrUserName=%@&addrId=%d&addrPhone=%@&proinceUrl=%@&cityUrl=%@&areaUrl=%@&villageUrl=%@&houseUrl=%@&firstFlag=2",self.personNameTextField.text,self.addidStr.intValue,self.telTextField.text,str4,str5,str6,self.cityTextFied.text,self.areaTextField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess1:)];
        [requestUrl setDidFailSelector:@selector(requestError1:)];
        [requestUrl startSynchronous];

    }
    

}

- (void)requestSuccess1:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"收货地址更新成功!");
    }
    else
    {
        NSLog(@"收货地址更新失败!");
    }
}

- (void)requestError1:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

@end
