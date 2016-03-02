//
//  AddressManageViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ASIHTTPRequest.h"

@interface AddressManageViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>

- (IBAction)backBt:(id)sender;
- (IBAction)saveBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *personNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *telTextField;
@property (strong, nonatomic) IBOutlet UITextField *provinceTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextFied;
@property (strong, nonatomic) IBOutlet UITextField *areaTextField;

@property (copy, nonatomic) NSString *addidStr;
@end
