//
//  PriceDetail.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-10.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceDetail : NSObject

@property (nonatomic)       float   international_freight       ;   //国际运费
@property (nonatomic)       float   overseas_freight            ;   //美国运费
@property (nonatomic)       float   product_price               ;   //商品售价
@property (nonatomic)       float   privilege_freight           ;   //运费折扣（国际运费八折所减的金额）
@property (nonatomic)       float   total_international_price   ;   //实际的运费
@property (nonatomic)       float   total_price                 ;   //订单总价
@property (nonatomic)       float   revenue                     ;   //税收
@property (nonatomic)       float   service_charge              ;   //代购费

- (instancetype)initWithDictionary:(NSDictionary *)dictionary   ;

@end