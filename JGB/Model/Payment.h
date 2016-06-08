//
//  Payment.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-19.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_PAY_SUCCESS        @"NOTIFICATION_PAY_SUCCESS"

/**
 * 支付订单流水
 */
@interface Payment : NSObject

@property (nonatomic)           int             idPayment   ;//是支付流水号
@property (nonatomic)           int             userID      ;
@property (nonatomic)           int             type        ;//支付类型 1财付通 2支付宝
@property (nonatomic,copy)      NSString        *domain     ;//支付域 订单为 ORDERS
@property (nonatomic)           float           price       ;
@property (nonatomic,copy)      NSString        *subject    ;//简介
@property (nonatomic,copy)      NSString        *ordersCode ;//订单编号
@property (nonatomic,copy)      NSString        *tradeCode  ;//第三方流水号
@property (nonatomic)           long long       addTime     ;//创建时间
@property (nonatomic)           long long       updateTime  ;//支付时间
@property (nonatomic)           int             status      ;//付款状态 未付款1 已付款2
@property (nonatomic,copy)      NSString        *typeName   ;//支付方式,名字
@property (nonatomic,copy)      NSString        *notifyUrl  ;//通知地址

/*
 *  initial
 */
- (instancetype)initWithDic:(NSDictionary *)dic             ;

/*
 *  payment go to pay
 *  @param: orderStr :  订单号
 */
+ (void)goToAliPayWithOrderStr:(NSString *)orderStr         ;


@end
