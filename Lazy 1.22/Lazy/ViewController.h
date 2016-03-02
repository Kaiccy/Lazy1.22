//
//  ViewController.h

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface ViewController : UIViewController<ASIHTTPRequestDelegate>

@property (strong, nonatomic) UIButton *goToPayBt;
//商品名称
@property (strong, nonatomic) NSMutableArray *nameArry;
//商品数量
@property (strong, nonatomic) NSMutableArray *countArry;
//商品图片名
@property (strong, nonatomic) NSMutableArray *imgNameArry;
//商品图片
@property (strong, nonatomic) NSMutableArray *imgArry;
//商品id
@property (strong, nonatomic) NSMutableArray *idArry;
//商品价格
@property (strong, nonatomic) NSMutableArray *priceArry;
//商品市场价格
@property (strong, nonatomic) NSMutableArray *markerPriceArry;
//商品规格
@property (strong, nonatomic) NSMutableArray *standardArry;
//dtlid
@property (strong, nonatomic) NSMutableArray *dtlIdArry;
//carid
@property (strong, nonatomic) NSMutableArray *carIdArry;
//风火轮
@property (strong, nonatomic) UIActivityIndicatorView *activity;
@property (strong, nonatomic) NSMutableArray *remainTimeArry;

@end

