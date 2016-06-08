//
//  OrderInfo.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-14.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

@property (nonatomic)           int         orderID ;        //订单id
@property (nonatomic,copy)      NSString    *oid    ;        //订单编号
@property (nonatomic)           int         cashier_number ; //支付流水号
@property (nonatomic)           int         goods_nums ;     //商品数量
@property (nonatomic)           float       total_prices ;   //总价 不含运费
@property (nonatomic)           float       freight ;        //境外运费
@property (nonatomic)           float       international_freight ;//国际运费
@property (nonatomic)           int         status ;         //订单状态
@property (nonatomic)           int         rate ;           //1未评价或者未完成全部评价,2完成全部评价 (针对 父订单)
@property (nonatomic)           long long   date ;           //tick
@property (nonatomic)           float       product_total_price ;//商品总价
@property (nonatomic,copy)      NSString    *pay_type ;      //支付类型
@property (nonatomic)           float       revenue ;        //关税
@property (nonatomic)           float       service_charge ; //服务费


@property (nonatomic)           NSString    *credit_name ;  //积分名称
@property (nonatomic)           NSString    *coupon_name ;  //优惠券优惠码名称

@property (nonatomic)           NSString    *coupon_code ; //优惠码
@property (nonatomic)           float       coupon_money ;   //优惠券优惠的价格
@property (nonatomic)           float       coupon_code_money ;//优惠码优惠的价格
@property (nonatomic)           float       credit_money ;   //积分优惠价格

@property (nonatomic)           float       actual_total_price ;//订单的价格
@property (nonatomic)           float       privilege_money ;//比特币优惠的价格
@property (nonatomic)           float       privilege_freight_money;//积分优惠的价格
@property (nonatomic)           long        past_time ;//订单过期时间，只有在带付款的时候会使用


// 20150120 ADD BEGIN
@property (nonatomic,copy)      NSString    *pay_name ;//支付方式(中文)
// 20150120 ADD END

- (instancetype)initWithDictionary:(NSDictionary *)dictionary ;

@end


