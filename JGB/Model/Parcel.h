//
//  Parcels.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-14.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OrderProduct.h"
#import "Parcel.h"
#import "Bag.h"


//  子订单
@interface Parcel : NSObject

@property (nonatomic)           int         parcelID    ;//子订单id

@property (nonatomic)           int         goods_nums  ;//商品数量
@property (nonatomic)           float       total_prices ;//订单总价

@property (nonatomic)           long long   date ;//订单创建时间

@property (nonatomic)           int         status ;        //订单状态，看对应config接口

@property (nonatomic,copy)      NSString    *oid ;      //订单号码


@property (nonatomic,retain)    NSArray     *product ;  //商品list
@property (nonatomic,retain)    NSArray     *bags ;     //包裹信息array


@property (nonatomic)           int         warehouse_id ;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary ;


@end
