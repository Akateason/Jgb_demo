//
//  CheckOutGoodCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CheckOutGoodCell.h"
#import "ColorsHeader.h"


@implementation CheckOutGoodCell

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
//    _lb_price.textColor = COLOR_PINK ;
    
    
}

- (void)awakeFromNib
{
    // Initialization code
    
    //
    _lb_price.textColor = COLOR_PINK ;
    //
    self.img.contentMode = UIViewContentModeScaleAspectFit ;
    //
    UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)] ;
    baseline.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:baseline] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
