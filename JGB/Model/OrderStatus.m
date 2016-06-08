//
//  OrderStatus.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "OrderStatus.h"

@implementation OrderStatus

- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    if (self)
    {
        _idStatus = [[diction objectForKey:@"id"] intValue] ;
        _name     = [diction objectForKey:@"name"]          ;
    }
    
    
    return self;
}


+ (NSArray *)getOrderStatusList:(NSDictionary *)config
{
    NSMutableArray  *orderStatus = [NSMutableArray array] ;
    NSArray         *orderStatusArr   = [config objectForKey:@"ORDERS_STATUS"] ;
    for (NSDictionary *dic in orderStatusArr)
    {
        OrderStatus *orderSta = [[OrderStatus alloc] initWithDic:dic] ;
        [orderStatus addObject:orderSta] ;
    }

    return orderStatus ;
}





@end
