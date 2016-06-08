//
//  SelectGoodCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "SelectGoodCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+AddFunction.h"
#import "SDImageCache.h"
#import "ColorsHeader.h"
#import "LSCommonFunc.h"
#import "DigitInformation.h"
#import "WarehouseTB.h"

@implementation SelectGoodCell


- (void)awakeFromNib
{
    // Initialization code
    self.lb_title1.textColor = [UIColor darkGrayColor];

}

- (void)setMyGood:(Goods *)myGood
{
    _myGood = myGood ;
    // title
//    self.lb_title1.text     = _myGood.title ; ?
    
    BOOL bCnAndEn = [myGood.title_cn isEqualToString:@""] || !myGood.title_cn;
    if (bCnAndEn)
    {
        self.lb_title1.text = myGood.title ;
    }
    else
    {
        self.lb_title1.text = myGood.title_cn ;
    }

    
    // img
    NSString *imgStr ;
    if (myGood.galleries == nil)
    {
        imgStr = @"";
    }
    else
    {
        imgStr = [myGood.galleries firstObject] ;
    }
    [self.goodImgView setIndexImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(75*2, 75*2)] ;
    
    [self.goodImgView   setContentMode:UIViewContentModeScaleAspectFit] ;

    _lb_usaPrice.hidden = NO ;
    
    //  商品售价
    if ([_myGood.seller.seller_id intValue] == 1000)
    {
        //自营, 只有人民币价格
        NSString *rmb = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"￥%.2f",_myGood.price]] ;
        _lb_rmbPrice.text   = rmb ;
        _lb_usaPrice.hidden = YES ;
    }
    else
    {
        //非自营, 有美元
        NSString *strSalePriceDollar = @"" ; //美元价格
        NSString *rmbSalePrice       = @"" ; //人民币价格
        
        //判断是否有区间
        if (_myGood.price_max - _myGood.price_min == 0)
        {
            strSalePriceDollar = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"$%.2f",_myGood.price]];
            
            rmbSalePrice       = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"￥%.2f",_myGood.rmb_price]] ;
        }
        else
        {
            NSString *max = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"$%.2f",_myGood.price_max]] ;
            NSString *min = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"$%.2f",_myGood.price_min]] ;
            
            strSalePriceDollar = [NSString stringWithFormat:@"%@-%@",min,max] ;
            
            NSString *maxR = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"￥%.2f",_myGood.rmb_max_price]] ;
            NSString *minR = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"￥%.2f",_myGood.rmb_min_price]] ;
            
            rmbSalePrice = [NSString stringWithFormat:@"%@ -%@",minR,maxR] ;
        }
        _lb_usaPrice.text = strSalePriceDollar ;
        _lb_rmbPrice.text = rmbSalePrice ;
        
    }
    
    //  下价商品  price == 0
    if (!_myGood.price)
    {
        _lb_rmbPrice.text      = @"暂无" ;
        _lb_usaPrice.hidden = YES ;
    }
    
    //  下架  shelves == 0
    if (!_myGood.shelves)
    {
        _lb_rmbPrice.text    = @"已下架" ;
        _lb_usaPrice.hidden = YES ;
    }

    
    //折扣
    // 无折扣 hidden
    BOOL bHasZhekou = !_myGood.price || !_myGood.list_price || (_myGood.price / _myGood.list_price == 1.0f) ;
    _img_zhekou.hidden = bHasZhekou ;
    _lb_zhekou.hidden  = bHasZhekou ;
    if (!bHasZhekou)
    {
        _img_zhekou.image = (_myGood.price_max - _myGood.price_min == 0) ? [UIImage imageNamed:@"zhe1"] : [UIImage imageNamed:@"zhe2"] ;
        
        float rate = (_myGood.price / _myGood.list_price) * 10.0f ;

        NSNumber *num = [NSNumber numberWithFloat:rate];
        NSString *zhekou = [NSString stringWithFormat:@"%.1f",round([num floatValue]*10.0)/10.0] ;
        if ([zhekou isEqualToString:@"10.0"]) zhekou = @"9.9" ;
        
        _lb_zhekou.text = (_myGood.price_max - _myGood.price_min == 0) ? [NSString stringWithFormat:@"%@折",zhekou] : [NSString stringWithFormat:@"%@折起",zhekou] ;
    }
    
    //来自商家
    WareHouse *wareHouse = [WareHouse getWarehouseWithID:_myGood.warehouse_id] ;
    _lb_comeFromSeller.text = [NSString stringWithFormat:@"来自%@",wareHouse.name] ;
    _lb_comeFromSeller.textColor = (_myGood.seller_id == 1000) ? COLOR_PINK : [UIColor darkGrayColor] ;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
