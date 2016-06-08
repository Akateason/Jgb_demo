//
//  PaySuccessCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-20.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "PaySuccessCell.h"
#import "ColorsHeader.h"


@implementation PaySuccessCell

- (void)setup
{
    _line1.backgroundColor = COLOR_BACKGROUND ;
    _line2.backgroundColor = COLOR_BACKGROUND ;
    
    _lb_paySuccess.textColor = [UIColor colorWithRed:88.0/255.0 green:156.0/255.0 blue:72.0/255.0 alpha:1.0] ;
    
    _lb_title_receiveMan.textColor = [UIColor grayColor];
    _lb_receiveMan.textColor = [UIColor grayColor];
    
    _lb_title_phone.textColor = [UIColor grayColor];
    _lb_phone.textColor = [UIColor grayColor];
    
    _lb_title_address.textColor = [UIColor grayColor];
    _lb_address.textColor = [UIColor grayColor];
    
    _lb_title_payway.textColor = [UIColor grayColor];
    _lb_payway.textColor = [UIColor grayColor];
    
    _lb_title_price.textColor = [UIColor grayColor];
    _lb_price.textColor = [UIColor grayColor];
    
    
    _bt_seeDetail.layer.cornerRadius = 5.0f ;
    _bt_seeDetail.layer.borderWidth  = 1.0f ;
    _bt_seeDetail.layer.borderColor  = COLOR_WD_GRAY.CGColor ;
    _bt_seeDetail.backgroundColor = nil ;
    [_bt_seeDetail setTitleColor:COLOR_WD_GRAY forState:UIControlStateNormal] ;
    [_bt_seeDetail setTitle:@"查看订单详情" forState:UIControlStateNormal] ;
}

- (void)awakeFromNib
{
    // Initialization code
    [self setup] ;
    
}

- (void)setOrder:(Order *)order
{
    _order = order ;
    
    _lb_payway.text = order.orderInfo.pay_name ;
    _lb_price.text  = [NSString stringWithFormat:@"￥%.2f",order.orderInfo.actual_total_price] ;
    
}

- (void)setAddress:(ReceiveAddress *)address
{
    _address = address ;
    
    _lb_receiveMan.text = address.uname ;
    _lb_phone.text      = address.phone ;
    _lb_address.text    = [address getDetailAddress] ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)seeOrderDetailAction:(id)sender
{
    NSLog(@"seeOrderDetailAction") ;
    [self.delegate seeOrderDetail] ;
}

@end
