//
//  ForgotPasswordViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/10.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *telTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)sureBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UIButton *getCodeBt;
- (IBAction)getCodeBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *secondPwdTextFied;
@property (assign, nonatomic) int second;
@property (strong, nonatomic) IBOutlet UILabel *timeCountLb;
@property (copy, nonatomic) NSString *returncode;
@property (strong, nonatomic) IBOutlet UILabel *titleLb;
@property (strong, nonatomic) IBOutlet UIView *titleView;

@end
