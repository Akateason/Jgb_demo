//
//  OrderInfo.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-14.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "OrderInfo.h"

@implementation OrderInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _orderID = [[dictionary objectForKey:@"id"] intValue] ;
        _oid     = [dictionary objectForKey:@"oid"] ;
        _cashier_number = [[dictionary objectForKey:@"cashier_number"] intValue] ;
        _goods_nums = [[dictionary objectForKey:@"goods_nums"] intValue] ;
        _total_prices = [[dictionary objectForKey:@"total_prices"] floatValue] ;
        _freight = [[dictionary objectForKey:@"freight"] floatValue] ;
        _international_freight = [[dictionary objectForKey:@"international_freight"] floatValue] ;
        _status = [[dictionary objectForKey:@"status"] intValue] ;
        _rate = [[dictionary objectForKey:@"rate"] intValue] ;
        _date = [[dictionary objectForKey:@"date"] longLongValue] ;
        
        if (![[dictionary objectForKey:@"product_total_price"] isKindOfClass:[NSNull class]])
        {
            _product_total_price = [[dictionary objectForKey:@"product_total_price"] floatValue] ;
        }
        
        _pay_type = [dictionary objectForKey:@"pay_type"] ;
        _revenue = [[dictionary objectForKey:@"revenue"] floatValue] ;
        _service_charge = [[dictionary objectForKey:@"service_charge"] floatValue] ;
        
        
        
    //  ADD
        _coupon_money = [[dictionary objectForKey:@"coupon_money"] floatValue] ;
        _credit_money = [[dictionary objectForKey:@"credit_money"] floatValue] ;
        _actual_total_price = [[dictionary objectForKey:@"actual_total_price"] floatValue] ;
        _privilege_money = [[dictionary objectForKey:@"privilege_money"] floatValue] ;
        
        if (![[dictionary objectForKey:@"privilege_freight_money"] isKindOfClass:[NSNull class]])
        {
            _privilege_freight_money = [[dictionary objectForKey:@"privilege_freight_money"] floatValue] ;
        }
        
        _coupon_code_money = [[dictionary objectForKey:@"coupon_code_money"] floatValue] ;
        
        if (![[dictionary objectForKey:@"coupon_code"] isKindOfClass:[NSNull class]])
        {
            _coupon_code = [dictionary objectForKey:@"coupon_code"] ;
        }
        
        _past_time = [[dictionary objectForKey:@"past_time"] longValue] ;
        
        
    //
        NSNumber *creditName = [dictionary objectForKey:@"credit_name"] ;
        _credit_name = [NSString stringWithFormat:@"%@",creditName] ;
        
        _coupon_name = ([[dictionary objectForKey:@"coupon_name"] isKindOfClass:[NSNull class]]) ? nil : [dictionary objectForKey:@"coupon_name"] ;
        
        
        _pay_name = [dictionary objectForKey:@"pay_name"] ;
    }
    
    return self;
}


@end
