//
//  UserLoginViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "FMDB.h"
#import "ASIHTTPRequest.h"

@interface UserLoginViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>

@property (copy, nonatomic) NSString *path;               //沙盒数据库路径
@property (strong, nonatomic) FMDatabase *db;             //FMDB数据库对象
@property (copy, nonatomic) NSString *User;               //登录账号
@property (copy, nonatomic) NSString *imgUrlStr;
@property int sexType;

- (IBAction)backBt:(id)sender;
- (IBAction)loginBt:(id)sender;
- (IBAction)registerBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginBt;
@property (strong, nonatomic) IBOutlet UIButton *registerBt;
@property (strong, nonatomic) IBOutlet UITextField *telnumTextField;
@property (strong, nonatomic) IBOutlet UITextField *sureTextField;
@property (strong, nonatomic) IBOutlet UIButton *geCodetBt;
- (IBAction)getCodeBt:(id)sender;
- (IBAction)sureLoginBt:(id)sender;
- (IBAction)qqBt:(id)sender;
- (IBAction)weichatBt:(id)sender;
- (IBAction)weiboBt:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *rtelnumTextField;
@property (strong, nonatomic) IBOutlet UITextField *rpwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *rsurePwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *rsurecodeTextField;
@property (strong, nonatomic) IBOutlet UIButton *rgetCodeBt;
- (IBAction)rgetCodeBt:(id)sender;
- (IBAction)rightNowRegisterBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *registerView;
//常用登录密码
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)forgetpwdBt:(id)sender;
- (IBAction)telloginBt:(id)sender;

//发送验证码倒计时Label
@property (strong, nonatomic) IBOutlet UILabel *loginCodeTimeLb;
@property (strong, nonatomic) IBOutlet UILabel *registerCodeLb;
//倒计时变量
@property int second;
@property (strong, nonatomic) IBOutlet UIButton *sureLoginBt;
@property (strong, nonatomic) IBOutlet UIButton *rightNowRegisterBt;
@property (strong, nonatomic) IBOutlet UIButton *weixinBt;
@property (strong, nonatomic) IBOutlet UILabel *weixinLb;
@property (copy, nonatomic) NSString *pwdStr;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBt;
@property (weak, nonatomic) IBOutlet UIButton *rightnowBt;

@end
