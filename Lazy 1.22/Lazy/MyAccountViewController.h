//
//  MyAccountViewController.h
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
#import "ASIHTTPRequest.h"//上传数据

@interface MyAccountViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate>

@property (copy, nonatomic) NSString *path;
//性别
@property (assign, nonatomic) int sexType;
@property (copy, nonatomic) NSString *HeadImageName;
@property (strong, nonatomic) FMDatabase *db;
@property (copy, nonatomic) NSString *User;                    //登录账号
//用户信息url
@property (strong, nonatomic) NSURL *url;
//弹出框
@property (strong,nonatomic) UIAlertView *alter;

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *femaleBt;
- (IBAction)femaleBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *maleBt;
- (IBAction)maleBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *birthTextField;
@property (strong, nonatomic) IBOutlet UITextField *otherTextField;
- (IBAction)finishBt:(id)sender;
- (IBAction)quitBt:(id)sender;
- (IBAction)chooseImgBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *personImg;
@property (strong, nonatomic) IBOutlet UITextField *telNumTextField;
@property (strong, nonatomic) IBOutlet UIButton *chooseImgBt;
@property (strong, nonatomic) IBOutlet UIButton *finishedBt;
- (IBAction)modifyBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *modifyBt;
@property (strong, nonatomic) IBOutlet UIButton *quitBt;
@property (strong, nonatomic) IBOutlet UITextField *femaleText;
@property (strong, nonatomic) IBOutlet UITextField *maleText;

@end
