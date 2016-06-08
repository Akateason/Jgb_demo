//
//  BagNumView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "BagNumView.h"
#import "UIImageView+WebCache.h"

#define NOTIFICATION_PRESS_PRODUCT_IN_ORDERDETAIL   @"NOTIFICATION_PRESS_PRODUCT_IN_ORDERDETAIL"


@implementation BagNumView

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
    
    _img_pro.contentMode = UIViewContentModeScaleAspectFit ;
    
}


#pragma mark --
#pragma mark - setter
- (void)setProduct:(OrderProduct *)product
{
    _product = product ;
    
    [_img_pro setIndexImageWithURL:[NSURL URLWithString:_product.images] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(60*2, 60*2)] ;
    
    _lb_nums.text = [NSString stringWithFormat:@"x%d",_product.nums] ;
}



#pragma mark --
#pragma mark -
- (IBAction)productImgClickedAction:(id)sender
{
    NSLog(@"productImgClickedAction") ;
    
    // notification send click which product
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PRESS_PRODUCT_IN_ORDERDETAIL object:_product.pid] ;
}

@end
