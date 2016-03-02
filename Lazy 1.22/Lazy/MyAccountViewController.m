//
//  MyAccountViewController.m
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
    //默认为女生选中 男生不选中
    [self.femaleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex1.png"] forState:UIControlStateNormal];
    [self.maleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex.png"] forState:UIControlStateNormal];
    
    self.sexType = 2;
    
    self.nameTextField.delegate = self;
    self.birthTextField.delegate = self;
    self.otherTextField.delegate = self;
    self.telNumTextField.delegate = self;
    
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //初始化沙盒数据库路径
    self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FMDB.sqlite"];
    //创建FMDatabase对象,参数为沙盒路径
    //沙盒路径文件路径无需真实存在，如果不存在会自动创建。
    self.db = [FMDatabase databaseWithPath:self.path];
    //允许数据库缓存提升查询效率
    [self.db setShouldCacheStatements:YES];
    //打开所需数据库
    [self DBInitialization];
    //初始化文本框信息
    if (del.User != nil)
    {
        [self setTextlabelInfo];
    }
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];

    self.personImg.frame = CGRectMake(self.view.frame.size.width / 2 - 50, 70, 100, 100);
    self.chooseImgBt.frame = CGRectMake(self.view.frame.size.width / 2 - 50, 70, 100, 100);
    self.femaleBt.frame = CGRectMake(self.view.frame.size.width / 4 , self.femaleText.frame.origin.y + 8, 15, 15);
    self.maleBt.frame = CGRectMake(self.view.frame.size.width / 4 * 3 - 30, self.femaleText.frame.origin.y + 8, 15, 15);
    self.finishedBt.frame = CGRectMake(self.birthTextField.frame.origin.x , self.otherTextField.frame.origin.y + 50, self.femaleText.frame.size.width, self.femaleText.frame.size.height);
    self.quitBt.frame = CGRectMake(self.finishedBt.frame.origin.x + self.femaleText.frame.size.width + 20 , self.otherTextField.frame.origin.y + 50, self.femaleText.frame.size.width, self.femaleText.frame.size.height);
    
    self.nameTextField.layer.borderWidth = 1.0;
    self.nameTextField.layer.borderColor = [[UIColor alloc]initWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
    
    self.modifyBt.hidden = YES;
    
    self.personImg.layer.cornerRadius = 50.0;
    self.personImg.layer.masksToBounds = YES;
    
    self.chooseImgBt.layer.cornerRadius = 50.0;
    self.chooseImgBt.layer.masksToBounds = YES;

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

        //确定登录的是哪个账号
        FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM LOGIN_STATE"];
        //遍历登录状态数据
        while ([resultSet next])
        {
            NSString *user = [resultSet stringForColumn:@"TEL"];
            NSString *LOGIN = [resultSet stringForColumn:@"LOGIN"];
            //如果存在已登录
            if ([LOGIN isEqualToString:@"YES"])
            {
                self.User = user;
                //停止遍历
                break;
            }
        }
        
    }
    else
    {
        NSLog(@"用户中心打开数据库失败！");
    }
}

//初始化文本框信息
- (void)setTextlabelInfo
{

    //如果是手机号 就获取手机注册用户的信息
    if ([self isMobile:self.User])
    {
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A02&phoneNumber=%@",self.User]];
    }
    //如果不是手机号，那么就获取第三方登录用户的信息
    else
    {
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A02&loginName=%@",self.User]];
    }
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:self.url];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess1:)];
    [requestUrl setDidFailSelector:@selector(requestError1:)];
    [requestUrl startSynchronous];
    
}

- (void)requestSuccess1:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if ([returncode isEqualToString:@"ok"])
    {
        NSLog(@"用户信息获取成功！");
    }
    
    NSArray *returnlistArry = [dic objectForKey:@"returnList"];
    if (returnlistArry.count > 0)
    {
        NSString *birth = [returnlistArry[0] objectForKey:@"birthday"];
        NSString *headimg = [returnlistArry[0] objectForKey:@"headImg"];
        NSString *email = [returnlistArry[0] objectForKey:@"mail"];
        NSString *nickname = [returnlistArry[0] objectForKey:@"nickName"];
        NSString *tel = [returnlistArry[0] objectForKey:@"phoneNumber"];
        NSString *sex = [returnlistArry[0] objectForKey:@"sexType"];
        
        if ([headimg isEqualToString:@"(null)"])
        {
            self.personImg.image = [UIImage imageNamed:@"user.png"];
        }
        else
        {
            NSString *HeadPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.User]];
            NSData *imageData = [[NSData alloc]initWithContentsOfFile:HeadPath];
            UIImage *image = [[UIImage alloc]initWithData:imageData];
            self.personImg.image = image;

        }
        self.birthTextField.text = birth;
        self.otherTextField.text = email;
        self.telNumTextField.text = tel;
        self.nameTextField.text = nickname;
        self.sexType = sex.intValue;
        if(self.sexType == 2)
        {
            
            [self.femaleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex1"] forState:UIControlStateNormal];
            [self.maleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex"] forState:UIControlStateNormal];
        }
        else
        {
            [self.maleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex1"] forState:UIControlStateNormal];
            [self.femaleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex"] forState:UIControlStateNormal];
        }

    }
    
    //如果我的账户信息有内容，就显示修改按钮  可以进行修改内容
    if (self.nameTextField.text.length > 0 || self.telNumTextField.text.length > 0 || self.otherTextField.text.length > 0 || self.birthTextField.text.length > 0)
    {
        self.modifyBt.hidden = NO;
        self.finishedBt.hidden = YES;
    }

}

- (void)requestError1:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
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
        if (strLength > 11 || strLength < 0)
        {
            return NO;
        }
        NSString *text1 = nil;
        //如果string为空，表示删除
        if (string.length > 0)
        {
            text1 = [NSString stringWithFormat:@"%@%@",self.telNumTextField.text,string];
        }
        else
        {
            text1 = [textField.text substringToIndex:range.location];
        }
        if ([self isMobile:text1])
        {
            [self.finishedBt setEnabled:YES];
        }
        else
        {
            [self.finishedBt setEnabled:NO];
        }
    }
    if (textField.tag == 4)
    {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength < 0)
        {
            return NO;
        }
        NSString *text1 = nil;
        //如果string为空，表示删除
        if (string.length > 0)
        {
            text1 = [NSString stringWithFormat:@"%@%@",self.otherTextField.text,string];
        }
        else
        {
            text1 = [textField.text substringToIndex:range.location];
        }
        if ([self validateEmail:text1])
        {
            [self.finishedBt setEnabled:YES];
        }
        else
        {
            [self.finishedBt setEnabled:NO];
        }
    }

    return YES;
}
//邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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


- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)femaleBt:(id)sender
{
    [self.femaleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex1.png"] forState:UIControlStateNormal];
    [self.maleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex.png"] forState:UIControlStateNormal];
    self.sexType = 2;
    NSLog(@"sex = %d",self.sexType);
}

- (IBAction)maleBt:(id)sender
{
    [self.femaleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex.png"] forState:UIControlStateNormal];
    [self.maleBt setBackgroundImage:[UIImage imageNamed:@"chooseSex1.png"] forState:UIControlStateNormal];
    self.sexType = 1;
    NSLog(@"sex = %d",self.sexType);

}

- (IBAction)finishBt:(id)sender
{
    
    if (self.telNumTextField.text.length > 0 || self.birthTextField.text.length > 0 || self.otherTextField.text.length > 0 || self.nameTextField.text.length > 0)
    {
        //创建用户接口
        NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A03&phoneNumber=%@&birthday=%@&loginName=%@passwd=111&headImg=%@&loginType=1&mail=%@&nickName=%@&sexType=%d",self.telNumTextField.text,self.birthTextField.text,self.User,self.HeadImageName,self.otherTextField.text,self.nameTextField.text,self.sexType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url];
        [requestUrl setDelegate:self];
        [requestUrl setRequestMethod:@"GET"];
        [requestUrl setTimeOutSeconds:60];
        [requestUrl setDidFinishSelector:@selector(requestSuccess2:)];
        [requestUrl setDidFailSelector:@selector(requestError2:)];
        [requestUrl startSynchronous];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:@"请完善信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (void)requestSuccess2:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *returncode = [dic objectForKey:@"returnCode"];
    if ([returncode isEqualToString:@"ok"])
    {
        NSLog(@"创建用户信息成功");
        
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
        NSString *insertSql1 = [NSString stringWithFormat:@"INSERT INTO LOGIN_STATE (TEL, LOGIN, NICKNAME) VALUES ('%@', '%@', '%@')",self.User, @"YES", self.nameTextField.text];
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

}

- (void)requestError2:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

- (IBAction)quitBt:(id)sender
{
    //创建 UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //取消按钮事件
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];

    //退出登录按钮事件
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //退出登录弹出框
        self.alter = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"您是否要退出登陆?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.alter show];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:exitAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//退出登录代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog(@"退出登录成功！");
        //删除相应登陆信息
        NSString *delete1 = [NSString stringWithFormat:@"DELETE FROM LOGIN_STATE WHERE TEL = '%@';", self.User];
        [self.db executeUpdate:delete1];
        //退出程序
        exit(2);
    }
}

//打开图库
- (IBAction)chooseImgBt:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    //设置来源类型为图片库
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate 设置取得图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    //获取选择的图片类型为原图
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //修改全局头像
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.HeadImage = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    //将图库按钮的背景图片修改为获得的图片
    [self.chooseImgBt setBackgroundImage:image forState:UIControlStateNormal];
    //获取点选图片时，获取图片名称
    NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        self.HeadImageName = [representation filename];
        NSLog(@"fileName : %@",self.HeadImageName);
        //将图片的后缀名切除
        NSArray *arr = [self.HeadImageName componentsSeparatedByString:@"."];
        self.HeadImageName = arr[0];
        //将选择的图片放到沙盒中
        NSString *HeadPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.HeadImageName]];
        NSLog(@"headPath = %@",HeadPath);
        //将图片输出为png,并写入沙盒指定路径
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:HeadPath atomically:YES];
        
        //把图片上传到服务器
        NSURL *url = [NSURL URLWithString:@"http://junjuekeji.com/resources/images/uploadUserImgs"];
        ASIFormDataRequest *arequest = [ASIFormDataRequest requestWithURL:url];
        [arequest setDelegate:self];
        [arequest setRequestMethod:@"POST"];
        [arequest setTimeOutSeconds:60.0];
        [arequest setFile:HeadPath forKey:@"imgPath"];
        [arequest buildPostBody];
        [arequest startAsynchronous];
    
        };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];

    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    NSString *str = [dic objectForKey:@"imgPath"];
    NSLog(@"%@", str);
    NSLog(@"图片请求上传成功");
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appImgServlet"]];
    //json解析
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:requestUrl returningResponse:nil error:nil];
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic1);
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"上传失败");
}
//按Cancel回到图库
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//修改信息
- (IBAction)modifyBt:(id)sender
{
    //修改用户信息接口
    NSURL *url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://junjuekeji.com/appServlet?requestCode=A04&loginName=%@&phoneNumber=%@&birthday=%@&headImg=%@&mail=%@&nickName=%@&sexType=%d",self.User,self.telNumTextField.text,self.birthTextField.text,self.HeadImageName,self.otherTextField.text,self.nameTextField.text,self.sexType]];
    
    ASIHTTPRequest *requestUrl = [ASIHTTPRequest requestWithURL:url2];
    [requestUrl setDelegate:self];
    [requestUrl setRequestMethod:@"GET"];
    [requestUrl setTimeOutSeconds:60];
    [requestUrl setDidFinishSelector:@selector(requestSuccess3:)];
    [requestUrl setDidFailSelector:@selector(requestError3:)];
    [requestUrl startSynchronous];
    
}

- (void)requestSuccess3:(ASIHTTPRequest *)request
{
    NSData *data  = [request responseData];
    NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic2);
    NSString *returncode2 = [dic2 objectForKey:@"returnCode"];
    if ([returncode2 isEqualToString:@"ok"])
    {
        NSLog(@"修改用户成功");
        
        
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
        NSString *insertSql1 = [NSString stringWithFormat:@"INSERT INTO LOGIN_STATE (TEL, LOGIN, NICKNAME) VALUES ('%@', '%@', '%@')",self.User, @"YES", self.nameTextField.text];
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
}

- (void)requestError3:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}

@end
