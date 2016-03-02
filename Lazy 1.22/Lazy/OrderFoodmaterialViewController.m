//
//  OrderFoodmaterialViewController.m
//  Lazy
//
//  Created by yinqijie on 15/9/23.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "OrderFoodmaterialViewController.h"
#import "SearchViewController.h"
#import "DetailFoodmaterialViewController.h"

#import "AppDelegate.h"

@interface OrderFoodmaterialViewController ()

@end

@implementation OrderFoodmaterialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //布局
    [self layout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)layout
{
    self.view.frame = [[UIScreen mainScreen]bounds];
    
    self.qiangImg.frame = CGRectMake(0, 65, self.view.frame.size.width, (self.view.frame.size.height - 65) / 4);
    self.collection.frame = CGRectMake(0, self.qiangImg.frame.origin.y + self.qiangImg.frame.size.height + 5, self.view.frame.size.width, self.view.frame.size.height - 70 - self.qiangImg.frame.size.height);
    self.collection.dataSource = self;
    self.collection.delegate = self;
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
}

- (IBAction)backBt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellid = @"cellid";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    UIView *view = [[UIView alloc]init];
    UIImageView *img= [[UIImageView alloc]init];
    [view addSubview:img];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    if(indexPath.row == 0)
    {
        img.frame = CGRectMake(0, 0, self.view.frame.size.width / 2 - 10, (self.view.frame.size.height - 65) / 5);
        img.image = [UIImage imageNamed:@"rice2.png"];
        UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(img.frame.size.width - img.frame.size.width / 4, 0, img.frame.size.width / 4, img.frame.size.width / 4)];
        img2.image = [UIImage imageNamed:@"timeOrder1.png"];
        [img addSubview:img2];
       
    }
    else if(indexPath.row == 1)
    {
        img.frame = CGRectMake(0, 0, self.view.frame.size.width / 2 - 10, (self.view.frame.size.height - 65) / 5);
        img.image = [UIImage imageNamed:@"oil.png"];
        UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(img.frame.size.width - img.frame.size.width / 4, 0, img.frame.size.width / 4, img.frame.size.width / 4)];
        img2.image = [UIImage imageNamed:@"timeOrder1.png"];
        [img addSubview:img2];
        
    }
    else if(indexPath.row == 2)
    {
        img.frame = CGRectMake(self.collection.frame.size.width / 4, 0, self.collection.frame.size.width / 2, (self.view.frame.size.height - 65) / 5);
        img.image = [UIImage imageNamed:@"wine.png"];
        UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 5 -((self.view.frame.size.width / 2 - 10) / 4 ), 0, (self.view.frame.size.width / 2 - 10) / 4, (self.view.frame.size.height - 65) / 5)];
        img2.image = [UIImage imageNamed:@"timeOrder2.png"];
        [view addSubview:img2];
    }
    
    cell.backgroundView = view;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 || indexPath.row == 1)
    {
        return CGSizeMake(self.view.frame.size.width / 2 - 10, (self.view.frame.size.height - 65) / 5);
    }
    else
    {
        return CGSizeMake(self.view.frame.size.width, (self.view.frame.size.height - 65) / 5);
    }
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailFoodmaterialViewController *view = [[DetailFoodmaterialViewController alloc]initWithNibName:@"DetailFoodmaterialViewController" bundle:nil];

    if(indexPath.row == 0)
    {
        view.i = 0;
    }
    else if(indexPath.row == 1)
    {
        view.i = 1;
    }
    else if(indexPath.row == 2)
    {
        view.i = 2;
    }
    
    [self presentViewController:view animated:YES completion:nil];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//搜索
- (IBAction)shoppingCarBt:(id)sender
{
    SearchViewController *view = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:nil];
    
}
@end
