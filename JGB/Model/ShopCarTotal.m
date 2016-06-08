//
//  ShopCarTotal.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-9.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "ShopCarTotal.h"

@implementation ShopCarTotal

- (instancetype)initWithDiction:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _product_total_price = [[dictionary objectForKey:@"product_total_price"] floatValue] ;
        _total_price         = [[dictionary objectForKey:@"total_price"] floatValue] ;
        _total_number        = [[dictionary objectForKey:@"total_number"] intValue] ;
    }
    return self;
}

@end
