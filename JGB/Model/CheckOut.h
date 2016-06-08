//
//  CheckOut.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReceiveAddress.h"
#import "Coupon.h"
#import "Seller_total.h"
#import "WareHouse_Total.h"
#import "PriceDetail.h"


@interface CheckOut : NSObject

//20150109 ADD START  @TEA

//  积分
@property (nonatomic)        int            credit ;

//  比特币 bitcoin_favorable
@property (nonatomic)        BOOL           bitcoin_favorable ;

//  价格详情 array
@property (nonatomic,retain) PriceDetail    *priceDetail ;

//20150109 ADD END



// 地址 list
@property (nonatomic,retain) NSArray        *addressList       ;

// 支付 方式
@property (nonatomic,retain) NSArray        *payType           ;

// 商品 dic
@property (nonatomic,retain) NSDictionary   *productDic   ;

//seller_total
@property (nonatomic,retain) NSDictionary   *totalDiction ;

//warehouse_total
@property (nonatomic,retain) NSDictionary   *totalWarehouseDiction ;

// 优惠券 list
@property (nonatomic,retain) NSArray        *couponList        ;


- (instancetype)initWithDiction:(NSDictionary *)dic     ;


@end
