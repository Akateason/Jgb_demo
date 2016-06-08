//
//  SubOrderCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "SubOrderCell.h"
#import "BagNumView.h"
#import "ColorsHeader.h"


@implementation SubOrderCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    self.backgroundColor               = COLOR_WHITE_BAI ;

    
//    _lb_subOrderNumber.backgroundColor = COLOR_LIGHT_GRAY ;
//    _lb_subOrderNumber.textColor       = [UIColor darkGrayColor] ;
    
    _scrollView_products.bounces       = NO ;
    
//    _lb_subOrderNumber.hidden          = YES ;
    
//    _line.backgroundColor              = COLOR_BACKGROUND ;
    
    _lb_seeShip.layer.cornerRadius     = CORNER_RADIUS_ALL ;
    _lb_seeShip.layer.masksToBounds    = YES ;
    _lb_seeShip.backgroundColor        = [UIColor whiteColor] ;
    _lb_seeShip.textColor              = COLOR_PINK ;
    _lb_seeShip.layer.borderColor      = COLOR_PINK.CGColor ;
    _lb_seeShip.layer.borderWidth      = 1 ;
    
    _scrollView_products.layer.borderColor = COLOR_BACKGROUND.CGColor ;
    _scrollView_products.layer.borderWidth = 1.0f ;
    _scrollView_products.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _scrollView_products.layer.masksToBounds = YES ;
}

#pragma mark -- setter
- (void)setParcel:(Parcel *)parcel
{
    _parcel = parcel ;
    
    //  子订单号
//    _lb_subOrderNumber.text = [NSString stringWithFormat:@"子订单: %@",parcel.oid] ;

    // hide or not 查看物流信息
    _lb_seeShip.hidden = ( parcel.status == 3 || parcel.status == 4 ) ? NO : YES ;
    
    // 子订单的商品s
    float flexWidth = 60.0f ;
    int nums    =    0 ;
    for (int i = 0; i < parcel.product.count; i ++ )
    {
        BagNumView *bagView = (BagNumView *)[[[NSBundle mainBundle] loadNibNamed:@"BagNumView" owner:self options:nil] lastObject];
        OrderProduct *tempPro = (OrderProduct *)[parcel.product objectAtIndex:i] ;
        bagView.product = tempPro ;
        bagView.frame = CGRectMake(i * flexWidth, 0, bagView.frame.size.width, bagView.frame.size.height) ;
        [_scrollView_products addSubview:bagView] ;
        nums ++ ;
    }
    
    _scrollView_products.contentSize = CGSizeMake(flexWidth * nums, 62) ;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
