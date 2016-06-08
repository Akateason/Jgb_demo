//
//  PayWayCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "PayWayCell.h"
#import "ColorsHeader.h"
#import "UIImageView+WebCache.h"


@implementation PayWayCell

- (void)layoutSubviews
{
    [super layoutSubviews] ;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    self.backgroundColor = COLOR_BACKGROUND ;
    
//    _img_payWay.layer.borderColor = COLOR_BACKGROUND.CGColor ;
//    _img_payWay.layer.borderWidth = 1.0f ;
//    _img_payWay.contentMode = UIViewContentModeScaleAspectFit ;
//    _img_payWay.layer.masksToBounds = YES ;
//    _img_payWay.layer.cornerRadius = CORNER_RADIUS_ALL ;
    
}


- (void)setPaytype:(PayType *)paytype
{
    _paytype = paytype ;
    
    _lb_payWay.text = paytype.name ;
    

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
