//
//  BuyCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "BuyCell.h"
#import "ColorsHeader.h"


@implementation BuyCell

#pragma mark --
- (void)setViewStyle
{
    _bgView.backgroundColor = [UIColor whiteColor] ;
    _bgView.layer.borderColor = COLOR_LIGHT_GRAY.CGColor ;
    _bgView.layer.borderWidth = 1.0f ;
    _img_goods.contentMode = UIViewContentModeScaleAspectFit ;
    _img_down.contentMode = UIViewContentModeScaleAspectFit ;
    _img_comeFrom.contentMode = UIViewContentModeScaleAspectFit ;
    
    self.backgroundColor = COLOR_BACKGROUND ;

}

- (void)awakeFromNib
{
    // Initialization code
    
    [self setViewStyle] ;
    
//    
    self.isShowDecline = YES ;
    
    
    
//    
    _img_goods.image = [UIImage imageNamed:@"dog.jpg"] ;
//    _img_down.image = [UIImage imageNamed:@"dog.jpg"] ;
    _img_comeFrom.image = [UIImage imageNamed:@"dog.jpg"] ;

    _lb_title.text = @"hero baby 荷兰美素friso 标准配方奶粉1段 800g 0-6个月" ;
    _lb_yesterday.text = @"昨日价1600.6" ;
    _lb_salePrice.text = @"抢购价1600.6" ;
    
    
}

#pragma mark -- Setter
- (void)setIsShowDecline:(BOOL)isShowDecline
{
    _isShowDecline          = isShowDecline ;
    
    _img_down.hidden        = !isShowDecline ;
    _lb_down_percent.hidden = !isShowDecline ;
}

- (void)setIsTimeOut:(BOOL)isTimeOut
{
    _isTimeOut = isTimeOut ;
    
    if (isTimeOut)
    {
        _img_down.image = [UIImage imageNamed:@"downGray"] ;
        _lb_down_percent.text = @"已经过期" ;
        _lb_down_percent.textColor = [UIColor darkGrayColor] ;
    }
    else {
        _img_down.image = [UIImage imageNamed:@"downRed"] ;
        _lb_down_percent.textColor = [UIColor whiteColor] ;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
