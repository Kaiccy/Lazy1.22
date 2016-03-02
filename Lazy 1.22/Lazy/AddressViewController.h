//
//  AddressViewController.h
//  Lazy
//
//  Created by yinqijie on 15/10/8.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "ASIHTTPRequest.h"

@interface AddressViewController : UIViewController<UITextFieldDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,ASIHTTPRequestDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoCode;
    
}
- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *telTextField;
@property (strong, nonatomic) IBOutlet UITextField *provinceTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UITextField *areaTextField;
//增加收获地址返回的id
@property (strong, nonatomic) NSMutableArray *addressIdArry;
- (IBAction)saveBt:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *saveBt;

- (IBAction)gpsBt1:(id)sender;
- (IBAction)gpsBt2:(id)sender;

@property (copy, nonatomic) NSString *provinceStr;
@property (copy, nonatomic) NSString *cityStr;
@property (copy, nonatomic) NSString *areaStr;
@property (copy, nonatomic) NSString *villageStr;
@property (copy, nonatomic) NSString *villageNumStr;

@end
