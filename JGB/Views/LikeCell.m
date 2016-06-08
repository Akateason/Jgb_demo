//
//  LikeCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "LikeCell.h"
#import "UIImageView+WebCache.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@implementation LikeCell

- (void)awakeFromNib
{
    // Initialization code
    
    
    _img_good.contentMode = UIViewContentModeScaleAspectFit ;
    
    self.layer.cornerRadius = 2.0f ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLikePro:(LikeProduct *)likePro
{
    _likePro = likePro ;
    
    
//    [_img_good setImageWithURL:[NSURL URLWithString:[likePro.product.galleries firstObject]] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(70*2, 70*2)] ;
    [_img_good setIndexImageWithURL:[NSURL URLWithString:[likePro.product.galleries firstObject]] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(70*2, 70*2)] ;

    _lb_name.text = likePro.product.title ;
    
//    _lb_onSale.text = [NSString stringWithFormat:@"%.1f￥ (%.1f$)",likePro.product.rmb_price,likePro.product.price] ;
//    _lb_likeTime.text = [MyTick getDateWithTick:likePro.date AndWithFormart:TIME_STR_FORMAT_3] ;
}





@end
