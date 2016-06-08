//
//  GoodConditionCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "GoodConditionCell.h"
#import "ColorsHeader.h"
#import <AKATeasonFramework/AKATeasonFramework.h>


@implementation GoodConditionCell

- (void)setViewStyle
{
    self.backgroundColor = COLOR_BACKGROUND ;
    
    _bt_addshopCar.backgroundColor = COLOR_PINK ;
    _bt_addshopCar.layer.cornerRadius = CORNER_RADIUS_ALL ;
    
}


- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    [self setViewStyle] ;
    
    
    
    int index = 0 ;
    for (ConditionSubView *cSubView in _subConditionViewList)
    {
        NSString *strImage = @"" ;
        NSString *strTitle = @"" ;
        NSString *strContent = @"" ;
        
        if (index == 0) {
            strImage = @"condition_zheng_1" ;
            strTitle = @"正品保障" ;
            strContent = @"100%国外网站下单购买" ;
        } else if (index == 1) {
            strImage = @"condition_door_1" ;
            strTitle = @"关税补贴" ;
            strContent = @"2000元以内关税补贴" ;
        } else if (index == 2) {
            strImage = @"condition_save_1" ;
            strTitle = @"全程保险" ;
            strContent = @"全程保险保障让您购物无忧" ;
        } else if (index == 3) {
            strImage = @"condition_speed_1" ;
            strTitle = @"极速送达" ;
            strContent = @"海外仓发货后20个工作日送达" ;
        }
        
        cSubView.img.image = [UIImage imageNamed:strImage] ;
        cSubView.lb_title.text = strTitle ;
        cSubView.lb_content.text = strContent ;
        
        index++ ;
    }
    
    
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    [TeaAnimation turnRoundBackWithView:_img_monkey] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - setter
- (void)setIsSelfSupport:(BOOL)isSelfSupport
{
    _isSelfSupport = isSelfSupport ;
    
}


- (void)setIsOpenShutdownShopCarButton:(BOOL)isOpenShutdownShopCarButton
{
    _isOpenShutdownShopCarButton = isOpenShutdownShopCarButton ;
    
    self.bt_addshopCar.backgroundColor          = isOpenShutdownShopCarButton ? COLOR_PINK : [UIColor lightGrayColor] ;
    self.bt_addshopCar.userInteractionEnabled   = isOpenShutdownShopCarButton ;

}


- (IBAction)addShopCarAction:(id)sender
{
    [self.delegate addShopCarCallBack] ;
}



@end










