//
//  DetailCellObj.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-10.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "DetailCellObj.h"
#import "LSCommonFunc.h"
#import "DigitInformation.h"

@implementation DetailCellObj

// initial
- (instancetype)initWithKey:(NSString *)key AndWithPrice:(float)price AndWithOrder:(int)order
{
    self = [super init];
    if (self)
    {
        _order = order ;
        _keyChinese = key ;

        _valDescrip = [self getPriceStrWithFloat:price] ;
        
        self.price = price ;
    }
    
    return self;
}



- (NSString *)getPriceStrWithFloat:(float)price
{
    return [NSString stringWithFormat:@"￥%.2f",price] ;
}



/*
 ********************************************************
 *  good detail 中
 *  价格详情
 *  get obj list with good detail
 ********************************************************
 */
- (NSMutableArray *)getObjListWithGoodDetail:(Goods *)good
{
    BOOL isSelfSale = ([good.seller.seller_id intValue] == 1000) ;
    
    //商品售价
    NSString *strSellPrice ;
    if (!good.promotiom) {
        strSellPrice = isSelfSale ? [NSString stringWithFormat:@"￥%.2f",good.rmb_price] : [NSString stringWithFormat:@"￥%.2f($%.2f)",good.rmb_price,good.price]  ;
    } else if (good.promotiom.price) {
        strSellPrice = [NSString stringWithFormat:@"￥%.2f",good.promotiom.price]  ;
    }

    DetailCellObj *productSalesPrice = [[DetailCellObj alloc] init] ;
    productSalesPrice.keyChinese = KEYS_PRO_PRICE ;
    productSalesPrice.valDescrip = strSellPrice ;
    
    
    //国内运费
    NSString *strInsideFreight = (isSelfSale) ? @"国内运费" : [NSString stringWithFormat:@"%@运费",good.seller.name] ;
    DetailCellObj *countryInFreight  = [[DetailCellObj alloc] initWithKey:strInsideFreight AndWithPrice:good.seller_freight AndWithOrder:0] ;

    //国际运费
    DetailCellObj *internatiolFreigt ;
    if (!isSelfSale)
    {
         internatiolFreigt = [[DetailCellObj alloc] initWithKey:KEYS_NATIONAL_FREIGHT AndWithPrice:good.freight AndWithOrder:0] ;
    }
    
    //关税
    DetailCellObj *tax               = [[DetailCellObj alloc] init] ;
    tax.keyChinese = KEYS_TAX ;
    tax.valDescrip = good.revenue ;

    // result
    NSMutableArray *tempList ;
    if (!isSelfSale)
    {
        tempList = [NSMutableArray arrayWithArray:@[productSalesPrice,countryInFreight,internatiolFreigt,tax]]  ;
    }
    else
    {
        tempList = [NSMutableArray arrayWithArray:@[productSalesPrice,countryInFreight,tax]] ;
    }
    
    
    if ([good.seller.seller_id intValue] != 1000)
    {// 若非自营, 加一行
        DetailCellObj *mathObj = [[DetailCellObj alloc] init] ;
        mathObj.keyChinese = @"到手价 = 商品价格 x 汇率 + 运费" ;
        
        mathObj.valDescrip = [NSString stringWithFormat:@"今日汇率 $1 = ￥%@",[LSCommonFunc changeFloat:[NSString stringWithFormat:@"%f",G_EXCHANGE_RATE]]] ;
        
        [tempList insertObject:mathObj atIndex:0] ;
    }
    
    return [NSMutableArray arrayWithArray:tempList] ;
}




/*
 ********************************************************
 *  order confirm 中
 *  价格详情
 *  get obj list with checkout ---- in order / confirm
 ********************************************************
 */

- (NSArray *)getObjListWithCheckOut:(CheckOut *)checkout
{
    PriceDetail *detail = checkout.priceDetail ;
    
    
    DetailCellObj *productSalesPrice = [[DetailCellObj alloc] initWithKey:KEYS_PRO_PRICE AndWithPrice:detail.product_price AndWithOrder:0] ;
    
    DetailCellObj *countryInFreight  = [[DetailCellObj alloc] initWithKey:KEYS_INSICE_FREIGHT AndWithPrice:detail.overseas_freight AndWithOrder:0] ;
    
    DetailCellObj *internatiolFreigt = [[DetailCellObj alloc] initWithKey:KEYS_NATIONAL_FREIGHT AndWithPrice:detail.international_freight AndWithOrder:0] ;
    DetailCellObj *tax               = [[DetailCellObj alloc] initWithKey:KEYS_TAX AndWithPrice:detail.revenue AndWithOrder:0] ;
    DetailCellObj *helpBuyMoney      = [[DetailCellObj alloc] initWithKey:KEYS_HELP_BUY AndWithPrice:detail.service_charge AndWithOrder:0] ;
    DetailCellObj *coupsonMoney      = [[DetailCellObj alloc] initWithKey:KEYS_COUPSONS AndWithPrice:0 AndWithOrder:0] ;
    DetailCellObj *pointMoney        = [[DetailCellObj alloc] initWithKey:KEYS_POINTS AndWithPrice:0 AndWithOrder:0] ;
    DetailCellObj *allMoney          = [[DetailCellObj alloc] initWithKey:KEYS_ALLPRICE AndWithPrice:detail.total_price AndWithOrder:0] ;
    
    NSArray       *tempList ;
    if (detail.privilege_freight)
    {
        DetailCellObj *privilegeFreight  = [[DetailCellObj alloc] initWithKey:KEYS_PRIVIGE_FREIGHT AndWithPrice:detail.privilege_freight AndWithOrder:0] ;
//        privilegeFreight.price = detail.privilege_freight ;
        
        tempList = @[productSalesPrice,countryInFreight,internatiolFreigt,privilegeFreight,tax,helpBuyMoney,coupsonMoney,pointMoney,allMoney] ;
    }
    else
    {
        tempList = @[productSalesPrice,countryInFreight,internatiolFreigt,tax,helpBuyMoney,coupsonMoney,pointMoney,allMoney] ;
    }
    
    return tempList ;
}


/*
 ********************************************************
 *  订单详情中
 *  价格详情
 ********************************************************
 */
- (NSArray *)getObjListWithOrderInfo:(OrderInfo *)orderinfo
{
    DetailCellObj *productSalesPrice = [[DetailCellObj alloc] initWithKey:KEYS_PRO_PRICE AndWithPrice:orderinfo.product_total_price AndWithOrder:0] ;
    
    DetailCellObj *countryInFreight  = [[DetailCellObj alloc] initWithKey:KEYS_INSICE_FREIGHT AndWithPrice:orderinfo.freight AndWithOrder:0] ;
    
    DetailCellObj *internatiolFreigt = [[DetailCellObj alloc] initWithKey:KEYS_NATIONAL_FREIGHT AndWithPrice:orderinfo.international_freight AndWithOrder:0] ;
    DetailCellObj *tax               = [[DetailCellObj alloc] initWithKey:KEYS_TAX AndWithPrice:orderinfo.revenue AndWithOrder:0] ;
    DetailCellObj *helpBuyMoney      = [[DetailCellObj alloc] initWithKey:KEYS_HELP_BUY AndWithPrice:orderinfo.service_charge AndWithOrder:0] ;
    
    float fCoupson = orderinfo.coupon_money + orderinfo.coupon_code_money ;
    DetailCellObj *coupsonMoney      = [[DetailCellObj alloc] initWithKey:KEYS_COUPSONS AndWithPrice:fCoupson AndWithOrder:0] ;
    
    DetailCellObj *pointMoney        = [[DetailCellObj alloc] initWithKey:KEYS_POINTS AndWithPrice:orderinfo.credit_money AndWithOrder:0] ;
    DetailCellObj *allMoney          = [[DetailCellObj alloc] initWithKey:KEYS_ALLPRICE AndWithPrice:orderinfo.actual_total_price AndWithOrder:0] ;
    
    NSArray       *tempList ;
    if (orderinfo.privilege_freight_money)
    {
        DetailCellObj *privilegeFreight  = [[DetailCellObj alloc] initWithKey:KEYS_PRIVIGE_FREIGHT AndWithPrice:orderinfo.privilege_freight_money AndWithOrder:0] ;
//        privilegeFreight.price = orderinfo.privilege_freight_money ;
        
        tempList = @[productSalesPrice,countryInFreight,internatiolFreigt,privilegeFreight,tax,helpBuyMoney,coupsonMoney,pointMoney,allMoney] ;
    }
    else
    {
        tempList = @[productSalesPrice,countryInFreight,internatiolFreigt,tax,helpBuyMoney,coupsonMoney,pointMoney,allMoney] ;
    }
    
    return tempList ;
}



#pragma mark --
#pragma mark - setter
- (void)setPrice:(float)price
{
    _price = price ;
    
    _valDescrip = [self getPriceStrWithFloat:price] ;
    
    //  当优惠券或者积分, 显示"-"
    BOOL bCondition = ([_keyChinese isEqualToString:KEYS_POINTS] || [_keyChinese isEqualToString:KEYS_COUPSONS] || [_keyChinese isEqualToString:KEYS_PRIVIGE_FREIGHT]) && (_price) ;
    
    if (bCondition)
    {
        _valDescrip = [NSString stringWithFormat:@"－%@",_valDescrip] ;
    }
}



@end
