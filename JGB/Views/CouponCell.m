//
//  CouponCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CouponCell.h"
#import "ColorsHeader.h"

@implementation CouponCell



- (void)setCoupson:(Coupon *)coupson
{
    _coupson = coupson ;
    

    // 100
    _lb_howMuch.text = [NSString stringWithFormat:@"￥%d",(int)coupson.coupon_money] ;
    
    // title
    _lb_title.text   = coupson.name ;

    // limit
    NSString *limitStr = ((int)coupson.coupon_money_limit) ? [NSString stringWithFormat:@"购物满%d",(int)coupson.coupon_money_limit] : @"无订单金额限制" ;
    _lb_case.text = limitStr ;
    
    // time
    _lb_detail.text  = [NSString stringWithFormat:@"有效期: %@ 到 %@",coupson.begintime,coupson.endtime] ;
    
    //
    self.isSelected = NO ;
}


- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected ;
    
    //
    [self changeStyle] ;
}

- (void)changeStyle
{
    _upLine.backgroundColor = _isSelected ? COLOR_PINK : COLOR_BACKGROUND ;
    _bg_coupson.layer.borderColor = _isSelected ? COLOR_PINK.CGColor : COLOR_BACKGROUND.CGColor ;

}


- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    
    _lb_howMuch.textColor = COLOR_PINK ;
    _lb_title.textColor = [UIColor darkGrayColor] ;
    _lb_case.textColor = [UIColor lightGrayColor] ;
    _lb_detail.textColor = [UIColor lightGrayColor] ;
    
    //
    _bg_coupson.backgroundColor = [UIColor whiteColor] ;
    _bg_coupson.layer.borderColor = COLOR_PINK.CGColor ;
    _bg_coupson.layer.borderWidth = 1 ;
    
    //
    _upLine.backgroundColor = COLOR_PINK ;
    
    //
    _bg_coupson.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _bg_coupson.layer.masksToBounds = YES ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
