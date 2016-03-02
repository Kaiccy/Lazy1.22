//
//  OrderFoodmaterialViewController.h
//  Lazy
//
//  Created by yinqijie on 15/9/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFoodmaterialViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

- (IBAction)backBt:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *collection;
- (IBAction)shoppingCarBt:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *qiangImg;

@end
