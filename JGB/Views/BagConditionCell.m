//
//  BagConditionCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-26.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "BagConditionCell.h"

@implementation BagConditionCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    self.lb_bagID.textColor = [UIColor darkGrayColor] ;
    self.lb_bagStatus.textColor = [UIColor darkGrayColor] ;
    self.lb_orderID.textColor = [UIColor darkGrayColor] ;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTheBag:(Bag *)theBag
{
    _theBag = theBag ;
    
    
    //运单号
    NSString *strExpress ;
    if (theBag.express_domestic_id)
    {
        strExpress = theBag.express_domestic_id ;
    }
    else
    {
        if (theBag.logistics_number)
        {
            strExpress = theBag.logistics_number ;
        }
        else
        {
            strExpress = nil ;
        }
    }
    self.lb_bagID.text = (!strExpress) ? @"" : [NSString stringWithFormat:@"运单号: %@",strExpress] ;
    
    //包裹状态
    self.lb_bagStatus.text = [NSString stringWithFormat:@"包裹: %@",[Bag getBagStatusStrWithStatus:theBag.status]] ;
    
}

- (void)setParcelID:(NSString *)parcelID
{
    _parcelID = parcelID ;
    
    //订单号
    self.lb_orderID.text = [NSString stringWithFormat:@"订单号: %@",_parcelID] ;

}

@end
