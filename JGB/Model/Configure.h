//
//  Configure.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-5.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configure : NSObject

@property (nonatomic)           float           EXCHANGE_RATE           ;
@property (nonatomic)           float           FREIGHT_EXCHANGE_RATE   ;
@property (nonatomic)           float           ADDON                   ;
@property (nonatomic)           float           FREIGHT                 ;
@property (nonatomic)           long            AUTHORIZATION_TIME      ;
@property (nonatomic,retain)    NSArray         *ORDERS_STATUS          ;
@property (nonatomic,retain)    NSArray         *PRODUCT_STATUS_INFO    ;
@property (nonatomic,retain)    NSArray         *BAG_STATUS           ;
@property (nonatomic,retain)    NSArray         *TRANSPORT_STATUS       ;
@property (nonatomic,retain)    NSDictionary    *EXPRESSAGE_DETAILS     ;



@property (nonatomic,retain)    NSArray         *payTypeList ;
@property (nonatomic,retain)    NSDictionary    *wareHouseDic ;

- (instancetype)initWithDic:(NSDictionary *)dic ;


@end
