//
//  HandPriceCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "HandPriceCell.h"
#import "DigitInformation.h"
#import "ColorsHeader.h"
#import "LSCommonFunc.h"
#import "LabelNoteVIew.h"

@interface HandPriceCell()
{
    float   m_angle ;
    int     m_cycle ;
}
@end

@implementation HandPriceCell

- (void)setup
{
    _lb_inHandPrice.textColor = COLOR_PINK ;
    _lb_zhekou_orgPrice.textColor = COLOR_PINK ;
    _lb_salePrice.textColor = COLOR_PINK ;
    _t_salePrice.textColor = [UIColor darkGrayColor] ;
    _t_zhekou.textColor = [UIColor darkGrayColor] ;
    _t_inHandPrice.textColor = [UIColor darkGrayColor] ;
    _lb_comeFrom.textColor = [UIColor lightGrayColor] ;
    
    _contain1.backgroundColor = [UIColor whiteColor] ;
    _contain2.backgroundColor = [UIColor whiteColor] ;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    [self setup]        ;
    
    m_angle = 0.0f      ;
    m_cycle = 0         ;
    
    [self startSpin]    ;
}

- (void)startSpin
{
    if (m_cycle > 600) return ;
    
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(m_angle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _img_loading.transform = endAngle;
        
    } completion:^(BOOL finished) {
        
        m_angle += 90 ;
        m_cycle ++ ;
        
        [self startSpin] ;
        
    }];
    
}


- (void)setGood:(Goods *)good
{
    _good = good ;
    
//1 到手价  改为 人民币价格区间
    BOOL bFirstAndHasSection = ( _good.rmb_max_price - _good.rmb_min_price > 0 ) && !_selectedProducts ;        // 有区间, 且 ,为选择过尺码
    if (bFirstAndHasSection)
    {
        _t_inHandPrice.text = @"售价：" ;
        NSString *maxRmb = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"￥%.2f",_good.rmb_max_price]] ;
        NSString *minRmb = [LSCommonFunc changeFloat:[NSString stringWithFormat:@"￥%.2f",_good.rmb_min_price]] ;
        _lb_inHandPrice.text = [NSString stringWithFormat:@"%@ -%@",minRmb,maxRmb] ;
        self.accessoryType = UITableViewCellAccessoryNone ;
        _priceRightFlex.constant = 15.0f ; //调节边距
        _discountFlex.constant = 15.0f ; //调节边距
    }
    else
    {
        _t_inHandPrice.text = @"到手价：" ;
        _lb_inHandPrice.text = [NSString stringWithFormat:@"￥%.2f",_good.actual_price] ;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        _priceRightFlex.constant = 3.0f ; //调节边距
        _discountFlex.constant = 3.0f ; //调节边距
    }
    
//2 暂无
//    商品价格为0  price == 0
    if (!_good.price)
    {
        _t_inHandPrice.text      = @"暂无" ;
        _lb_inHandPrice.hidden = YES ;
        _t_zhekou.hidden = YES ;
        _lb_zhekou_orgPrice.hidden = YES ;
        //_lb_comeFrom.hidden = YES ;
        _img_loading.hidden = YES ;
    }
    
//3 下架
//    shelves == 0
    if (!_good.shelves) {
        _t_inHandPrice.text    = @"已下架" ;
        _lb_inHandPrice.hidden = YES ;
        _t_zhekou.hidden = YES ;
        _lb_zhekou_orgPrice.hidden = YES ;
        //_lb_comeFrom.hidden = YES ;
        _img_loading.hidden = YES ;
    }
   
//4 售价
    //商品售价
    if (bFirstAndHasSection) {
        _lb_salePrice.hidden = YES ;
        _t_salePrice.hidden = YES ;
    } else {
        _lb_salePrice.hidden = NO ;
        _t_salePrice.hidden = NO ;
        
        BOOL isSelfSale = ([good.seller.seller_id intValue] == 1000) ;
        NSString *strSellPrice = isSelfSale ? [NSString stringWithFormat:@"￥%.2f",good.rmb_price] : [NSString stringWithFormat:@"￥%.2f($%.2f)",good.rmb_price,good.price]  ;
        _lb_salePrice.text = strSellPrice ;
    }
    
    
//5 折扣
    
    // 无折扣 hidden
    BOOL bHasZhekou = !_good.price || !_good.list_price || (_good.price / _good.list_price == 1.0f) ;
    _t_zhekou.hidden = bHasZhekou ;
    _lb_zhekou_orgPrice.hidden  = bHasZhekou ;
    // 有折扣
    if (!bHasZhekou)
    {
        NSString *strZhekou     = [HandPriceCell getZhekouStrWithGoods:_good] ;
        
        // 立即减去
//        NSString *strOrgPrice   = [LSCommonFunc changeFloat:[HandPriceCell getMinusWithGoods:_good]] ;
        // 有折扣一定有原价
//        NSString *resultStr = [NSString stringWithFormat:@"%@(立减%@)",strZhekou,strOrgPrice] ;
        NSString *resultStr = [NSString stringWithFormat:@"%@",strZhekou] ;
        
        _lb_zhekou_orgPrice.text = resultStr ;
    }
    

    
    
//6 代购,自营  加购
    LabelNoteVIew *noteV = [[[NSBundle mainBundle] loadNibNamed:@"LabelNoteVIew" owner:self options:nil] firstObject] ;

    if ( _good.seller_id == 1000 ) {
        //自营
        [noteV setNoteMode:modeZiYin] ;
    } else {
        //代购
        [noteV setNoteMode:modeDaiGou] ;
    }

    [_contain1 addSubview:noteV] ;
    
    //加购
    BOOL isAddon = NO ;
    if (_good.seller_id == 1)
    {
        for (int i = 0; i < _good.type.count ; i++)
        {
            NSString *str = _good.type[i] ;
            if ([str isEqualToString:@"addon"])
            {
                isAddon = YES ;
            }
        }
    }
    
    if (isAddon)
    {
        LabelNoteVIew *noteV2 = [[[NSBundle mainBundle] loadNibNamed:@"LabelNoteVIew" owner:self options:nil] firstObject] ;
        [noteV2 setNoteMode:modeAddons] ;
        [_contain2 addSubview:noteV2] ;
    } else {
        _contain2.hidden = YES ;
    }
        
//7 有促销
    if (_good.promotiom != nil) {
        _t_zhekou.hidden = YES ;
        _lb_zhekou_orgPrice.hidden = YES ;
        _t_inHandPrice.text = @"售价：" ;
        _lb_inHandPrice.text = [NSString stringWithFormat:@"人民币%.2f",_good.promotiom.price] ;
        _lb_salePrice.hidden = YES ;
        _t_salePrice.hidden = YES ;
    }
}

- (void)setPredictTime:(NSString *)predictTime
{
    _predictTime = predictTime ;
    
    //4 发货,工作日到达
    _lb_comeFrom.text = predictTime ;

}

- (void)setCheckPriceFinished:(BOOL)checkPriceFinished
{
    _checkPriceFinished = checkPriceFinished ;
    
    [self performSelector:@selector(hideLoading) withObject:nil afterDelay:1.0f] ;
}

- (void)hideLoading
{
    _img_loading.hidden = YES ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+ (NSString *)getZhekouStrWithGoods:(Goods *)good
{
    float rate = (good.price / good.list_price) * 10.0f ;
    NSNumber *num = [NSNumber numberWithFloat:rate];
    NSString *zhekou = [NSString stringWithFormat:@"%.1f",round([num floatValue]*10.0)/10.0] ;
    if ([zhekou isEqualToString:@"10.0"]) zhekou = @"9.9" ;
    
    return [NSString stringWithFormat:@"%@折",zhekou] ;
}


//get list price
+ (NSString *)getMinusWithGoods:(Goods *)good
{
    // 原价 ￥
    NSString *strMinus = @"" ;
    if (good.list_price)
    {
        float detaFlt = good.list_price - good.price ;
        if (good.seller_id == 1000) {
            strMinus = [NSString stringWithFormat:@"￥%.2f",detaFlt] ;
        } else {
            strMinus = [NSString stringWithFormat:@"￥%.2f",detaFlt * G_EXCHANGE_RATE] ;
        }
    }
    
    return strMinus ;
}



@end
