//
//  ListComment.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-15.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ListComment.h"

@implementation ListComment

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        
        _image = [dic objectForKey:@"image"] ;
        _title = [dic objectForKey:@"title"] ;
        _orderProductId = [[dic objectForKey:@"order_product_id"] intValue];
        _code  = [dic objectForKey:@"code"] ;
        _status = [[dic objectForKey:@"status"] intValue] ;
        _price = [[dic objectForKey:@"order_product_prices"] floatValue] ;
        _nums = [[dic objectForKey:@"order_product_prices"] intValue] ;
        _totalPrice = [[dic objectForKey:@"order_product_total_prices"] floatValue] ;
        
    }
    return self;
}


@end
