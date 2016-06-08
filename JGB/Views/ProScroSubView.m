//
//  ProScroSubView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ProScroSubView.h"
#import "ProOneCellView.h"
#import "UIImageView+WebCache.h"

@interface ProScroSubView()

@end

@implementation ProScroSubView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
//    ProOneCellView *cell1 = (ProOneCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ProOneCellView" owner:self options:nil] lastObject] ;
//    [_backView addSubview:cell1] ;
//    NSLog(@"celll1.frame :%@",NSStringFromCGRect(cell1.frame)) ;
    

}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
}


#define FORMAT_RMB      @"￥%.2f"

- (void)setActivity1:(Activity *)activity1
{
    _activity1 = activity1 ;
    _pro1.activity = activity1 ;
    

}


- (void)setActivity2:(Activity *)activity2
{
    _activity2 = activity2 ;
    _pro2.activity = activity2 ;

//    _pro2.lb_title.text = activity2.goods.title ;
//    _pro2.lb_price.text = [NSString stringWithFormat:FORMAT_RMB,activity2.goods.actual_price] ;
//    [_pro2.imgV setImageWithURL:[NSURL URLWithString:activity2.goods.galleries[0]] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(160, 160)] ;
}

- (void)setActivity3:(Activity *)activity3
{
    _activity3 = activity3 ;
    _pro3.activity = activity3 ;

//    _pro3.lb_title.text = activity3.goods.title ;
//    _pro3.lb_price.text = [NSString stringWithFormat:FORMAT_RMB,activity3.goods.actual_price] ;
//    [_pro3.imgV setImageWithURL:[NSURL URLWithString:activity3.goods.galleries[0]] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(160, 160)] ;
}





@end
