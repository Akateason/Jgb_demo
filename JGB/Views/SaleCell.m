//
//  SaleCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "SaleCell.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "UIImageView+WebCache.h"
#import "ColorsHeader.h"


@implementation SaleCell

- (void)setViewStyle
{
    
    _bgView_NoStart.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.8] ;
    [TeaCornerView setRoundHeadPicWithView:_startCornerView] ;
    self.backgroundColor = [UIColor whiteColor]  ;
    
}

- (void)awakeFromNib
{
    // Initialization code
    [self setViewStyle] ;
    
    _bgView_NoStart.hidden  = YES ;
    _startCornerView.hidden = YES ;
    _lb_willStart.hidden    = YES ;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    CABasicAnimation *animation = [TeaAnimation scale:@1.02 orgin:@0.96 durTimes:1.05 Rep:100] ;
    [_startCornerView.layer addAnimation:animation forKey:@"transi"] ;
}


#pragma mark --
#pragma mark - Setter



- (void)setSaleObj:(SaleIndex *)saleObj
{
    _saleObj = saleObj ;
    
    // set imgs
    [_bgImg setIndexImageWithURL:[NSURL URLWithString:saleObj.images] placeholderImage:[UIImage imageNamed:@"noPic_indexSale"] options:0 AndSaleSize:CGSizeMake(640, 270)] ;
    
    
    self.lb_words.text = saleObj.name ;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end





