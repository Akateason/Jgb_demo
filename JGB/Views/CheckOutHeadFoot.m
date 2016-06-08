//
//  CheckOutHeadFoot.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CheckOutHeadFoot.h"
#import "ColorsHeader.h"


@implementation CheckOutHeadFoot

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        
        self.showOrNot    = YES  ;      //是否显示
        self.totalBusnessPrice = 0 ;
        self.dollarsNeeds = 0 ;      //需要多少美元包邮(美元)
        self.freightUsa   = 0 ;      //美国国内运费(人民币)
        self.bid          = 0 ;
    
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
}


- (void)awakeFromNib
{
    [super awakeFromNib] ;
    //
    _lb_key.textColor   = [UIColor blackColor]      ;
    _lb_price.textColor = [UIColor darkGrayColor]   ;
    //
    UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)] ;
    baseline.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:baseline] ;
    
    UIView *upline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)] ;
    upline.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:upline] ;
    

    
    self.backgroundColor    = [UIColor whiteColor] ;
    _bgView.backgroundColor = [UIColor whiteColor] ;

}



- (void)setIsShopcarFoot:(BOOL)isShopcarFoot
{
    _isShopcarFoot = isShopcarFoot  ;
    
    if (!isShopcarFoot) return      ;
    
    _bgView.backgroundColor    = COLOR_LIGHT_GRAY ;
    self.lb_key.font           = [UIFont systemFontOfSize:9.5f]     ;
    self.lb_key.numberOfLines  = 0                                  ;
    self.lb_key.textColor      = [UIColor blackColor]               ;
    self.lb_price.font         = [UIFont systemFontOfSize:10.0f]    ;
    self.lb_price.textColor    = [UIColor blackColor]               ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
