//
//  MyCustomCell.m
//  Lazy
//
//  Created by yinqijie on 15/12/11.
//  Copyright (c) 2015年 yinqijie. All rights reserved.
//

#import "MyCustomCell.h"
#define WIDTH ([UIScreen mainScreen].bounds.size.width)

@implementation MyCustomCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //布局界面
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, WIDTH-10, 95)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        //添加商品图片
        _goodsImgV = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 80, 80)];
        _goodsImgV.backgroundColor = [UIColor greenColor];
        [bgView addSubview:_goodsImgV];
        
        //添加商品标题
        _goodsTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(_goodsImgV.frame.size.width + 80, 5, 200, 30)];
        _goodsTitleLab.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_goodsTitleLab];
        
        //¥
        UILabel *signLb = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 80, 37, 10, 30)];
        signLb.text = @"¥";
        signLb.textColor = [UIColor redColor];
        [bgView addSubview:signLb];
        
        //商品价格
        _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 70, 37, 100, 30)];
        _priceLab.font = [UIFont fontWithName:@"Arial" size:20.0];
        _priceLab.textColor = [UIColor redColor];
        [bgView addSubview:_priceLab];
        
        //规格
        _goodsNumLab = [[UILabel alloc]initWithFrame:CGRectMake(_goodsImgV.frame.size.width + 80, 39, 75, 20)];
        _goodsNumLab.text = @"500g";
        _goodsNumLab.font = [UIFont fontWithName:@"Arial" size:14.0];
        _goodsNumLab.textAlignment = NSTextAlignmentCenter;
        _goodsNumLab.textColor = [UIColor grayColor];
        [bgView addSubview:_goodsNumLab];
        
        //减按钮
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(_goodsImgV.frame.size.width + 80, 68, 25, 25);
        [_deleteBtn setTitle:@"-" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _deleteBtn.layer.borderWidth = 0.6;
        _deleteBtn.layer.borderColor = [UIColor grayColor].CGColor;      [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.tag = 11;
        [bgView addSubview:_deleteBtn];
        
        //购买商品的数量
        _numCountLab = [[UILabel alloc]initWithFrame:CGRectMake(_goodsImgV.frame.size.width + 80 + 25, 68, 25, 25)];
        _numCountLab.textColor = [UIColor grayColor];
        _numCountLab.textAlignment = NSTextAlignmentCenter;
        _numCountLab.layer.borderWidth = 0.6;
        _numCountLab.layer.borderColor = [UIColor grayColor].CGColor;
        [bgView addSubview:_numCountLab];
        
        //加按钮
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(_goodsImgV.frame.size.width + 80 + 50, 68, 25, 25);
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _addBtn.layer.borderWidth = 0.6;
        _addBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.tag = 12;
        [bgView addSubview:_addBtn];
        
        //是否选中图片
        _isSelectImg = [[UIButton alloc]initWithFrame:CGRectMake(10, 40, 20, 20)];
        [_isSelectImg addTarget:self action:@selector(isSelectImgAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_isSelectImg];
        _isSelectImg.tag = 13;
        [self addSubview:bgView];
    }
    return self;
}

/**
 *  给单元格赋值
 *
 *  @param goodsModel 里面存放各个控件需要的数值
 */
-(void)addTheValue:(GoodsInfoModel *)goodsModel
{
    _goodsImgV.image = (UIImage *)goodsModel.imageName;
    _goodsTitleLab.text = goodsModel.goodsTitle;
    _priceLab.text = goodsModel.goodsPrice;
    _numCountLab.text = [NSString stringWithFormat:@"%d",goodsModel.goodsNum];
    _priceTitleLab.text = goodsModel.goodsMarketPrice;
    _goodsNumLab.text = goodsModel.goodsStand;
    _goodsId = goodsModel.goodsId;
    _carId = goodsModel.carId;
    _dtlId = goodsModel.dtlId;
    
    if (goodsModel.selectState)
    {
        _selectState = YES;
        [_isSelectImg setImage:[UIImage imageNamed:@"chooseSex1.png"] forState:UIControlStateNormal];
    }else{
        _selectState = NO;
        [_isSelectImg setImage:[UIImage imageNamed:@"chooseSex.png"] forState:UIControlStateNormal];
    }
    
}

/**
 *  点击减按钮实现数量的减少
 *
 *  @param sender 减按钮
 */
-(void)deleteBtnAction:(UIButton *)sender
{
    //判断是否选中，选中才能点击
    if (_selectState == YES)
    {
        //调用代理
        [self.delegate btnClick:self andFlag:(int)sender.tag];
    }
    
}
/**
 *  点击加按钮实现数量的增加
 *
 *  @param sender 加按钮
 */
-(void)addBtnAction:(UIButton *)sender
{
    //判断是否选中，选中才能点击
    if (_selectState == YES)
    {
        //调用代理
        [self.delegate btnClick:self andFlag:(int)sender.tag];
    }
    
}

//单选按钮
- (void)isSelectImgAction:(UIButton *)sender
{
    //调用代理
    [self.delegate btnClick:self andFlag:(int)sender.tag];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
