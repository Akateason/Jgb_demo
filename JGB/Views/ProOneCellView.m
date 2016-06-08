//
//  ProOneCellView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ProOneCellView.h"
#import "UIImageView+WebCache.h"
#import "ColorsHeader.h"


@implementation ProOneCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setViewStyle
{
    _clickButton.backgroundColor = [UIColor clearColor] ;
    
    _killDidFinishView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5] ;
    _killWillStartView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5] ;

    [self.layer setCornerRadius:3.0f] ;
    [self.layer setBorderWidth:1.5f]                      ;
    [self.layer setBorderColor:COLOR_LIGHT_GRAY.CGColor]  ;
    
    _lb_title.textColor = COLOR_WD_GRAY ;
    _lb_price.textColor = COLOR_WD_GRAY ;
    _lb_killPrice.textColor = COLOR_PINK ;
    _lb_killPrice.font = [UIFont boldSystemFontOfSize:12.0f] ;
    
    
    _imgV.contentMode   = UIViewContentModeScaleAspectFit ;
}


- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
//    [self startTime] ;
    
    [self setViewStyle] ;
    
    _killDidFinishView.hidden = YES     ;
    _killWillStartView.hidden = YES     ;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews]  ;
}


- (void)setIsSellFinish:(BOOL)isSellFinish
{
    _isSellFinish = isSellFinish ;
    
    if (isSellFinish)
    {
        _killDidFinishView.hidden = NO      ;
        _killWillStartView.hidden = YES     ;
    }
    else
    {
        _killDidFinishView.hidden = YES     ;
        _killWillStartView.hidden = YES     ;
    }
}

- (void)setIsSellStart:(BOOL)isSellStart
{
    _isSellStart = isSellStart ;
    
    if (isSellStart)
    {
        _killDidFinishView.hidden = YES     ;
        _killWillStartView.hidden = NO      ;
    }
    else
    {
        _killDidFinishView.hidden = YES     ;
        _killWillStartView.hidden = YES     ;
    }
}

- (void)setActivity:(Activity *)activity
{
    _activity = activity ;
    
    
    _lb_title.text = activity.goods.title ;
    
    _lb_price.text = [NSString stringWithFormat:@"原价￥%.2f",activity.goods.actual_price] ;
    
    _lb_killPrice.text = [NSString stringWithFormat:@"秒杀￥%.2f",activity.goods.price] ;
    
    [_imgV setImageWithURL:[NSURL URLWithString:activity.goods.galleries[0]] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(160, 160)] ;
}


#pragma mark --
#pragma mark --
- (IBAction)actionClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PROONECELL_PRO_CLICKED object:_activity.goods.code] ;
}








@end
