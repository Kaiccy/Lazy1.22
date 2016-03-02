//
//  AddressViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "AddressViewController.h"
#import "AppDelegate.h"

@interface AddressViewController ()

@end

@implementation AddressViewController
- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    self.nameTextField.delegate = self;
    self.telTextField.delegate = self;
    self.provinceTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.areaTextField.delegate = self;
    self.addressIdArry = [[NSMutableArray alloc] init];
    
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:_mapView];
    _mapView.hidden = YES;
}

//成为第一响应者 弹出键盘
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self becomeFirstResponder];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 2)
    {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11)
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
            [self.saveBt setEnabled:YES];
        }
        else
        {
            [self.saveBt setEnabled:NO];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
//当点击键盘上return按钮的时候调用
{
    //代理记录了当前正在工作的UITextField的实例，因此你点击哪个UITextField对象，形参就是哪个UITextField对象
    [textField resignFirstResponder];//键盘回收代码
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将TextField中的数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    NSLog(@"%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
    // 调用反地址编码方法，让其在代理方法中输出
    [self.geoCode reverseGeoCode:option];
    [_locService stopUserLocationService];
}
#pragma mark geoCode的Get方法，实现延时加载
- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode) {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}
#pragma mark 地理编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result)
    {
        NSString *str = [NSString stringWithFormat:@"经度为：%.2f   纬度为：%.2f", result.location.longitude, result.location.latitude];
        NSLog(@"str = %@",str);
        NSLog(@"address = %@", result.address);
    }
    else{
        
        NSLog(@"str = 找不到相对应的位置");
    }
}
#pragma mark 反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result)
    {
        NSString *str = [NSString stringWithFormat:@"%@", result.address];
        NSLog(@"str = %@",str);
        NSLog(@"%@ - %@", result.address, result.addressDetail.streetNumber);
        NSLog(@"%@ %@ %@ %@ %@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber);
        self.provinceStr = result.addressDetail.province;
        self.cityStr = result.addressDetail.city;
        self.areaStr = result.addressDetail.district;
        self.villageStr = result.addressDetail.streetName;
    }
    else
    {
        NSLog(@"str = 找不到相对应的位置信息");
    }
}



- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBt:(id)sender
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (self.nameTextField.text.length < 1 || self.telTextField.text.length < 1 || self.provinceTextField.text.length < 1 || self.areaTextField.text.length < 1 || self.cityTextField.text.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:@"请检查输入错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }

    else
    {
        //增加收货地址接口
       NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=C05&loginName=%@&addrUserName=%@&addrPhone=%@&proinceUrl=%@&cityUrl=%@&areaUrl=%@&villageUrl=%@&houseUrl=%@&firstFlag=1",del.User,self.nameTextField.text,self.telTextField.text,self.provinceStr,self.cityStr,self.areaStr,self.cityTextField.text,self.areaTextField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

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
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    [self.addressIdArry addObject:[NSString stringWithFormat:@"%@",returnlistArry[0]]];
    [del.addressIdArry setArray:self.addressIdArry];
    if([returncode isEqualToString:@"ok"])
    {
        NSLog(@"增加地址成功!");
    }
    else
    {
        NSLog(@"增加地址失败!");
    }

}

- (void)requestError1:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}


- (IBAction)gpsBt1:(id)sender
{
    if(self.provinceStr == nil && self.cityStr == nil && self.areaStr == nil)
    {
        self.provinceTextField.text = @"";
    }
    else
    {
        self.provinceTextField.text = [NSString stringWithFormat:@"%@%@%@",self.provinceStr,self.cityStr,self.areaStr];
    }
    
}

- (IBAction)gpsBt2:(id)sender
{
    if(self.villageStr == nil)
    {
        self.cityTextField.text = @"";
    }
    else
    {
        self.cityTextField.text = [NSString stringWithFormat:@"%@",self.villageStr];
    }
    
}
@end
