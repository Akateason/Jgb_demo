//
//  ShopCarTotal.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-9.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

//购物车总价

@interface ShopCarTotal : NSObject

@property (nonatomic) float product_total_price ;   //商品总价
@property (nonatomic) float total_price         ;   //订单总价(含运费)
@property (nonatomic) int   total_number        ;   //商品总数

- (instancetype)initWithDiction:(NSDictionary *)dictionary ;

@end
