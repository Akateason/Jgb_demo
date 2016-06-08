//
//  Order.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OrderInfo.h"
#import "OrderProduct.h"
#import "ReceiveAddress.h"
#import "Bag.h"
#import "Parcel.h"


@interface Order : NSObject

@property (nonatomic,retain)    OrderInfo       *orderInfo ;
@property (nonatomic,retain)    ReceiveAddress  *address ;
@property (nonatomic,retain)    NSArray         *product ;
@property (nonatomic,retain)    NSArray         *bagArray ;
@property (nonatomic,retain)    NSArray         *parcelArray ;//子订单list

- (instancetype)initWithDictionary:(NSDictionary *)dictionary ;

@end




/*
 @property (nonatomic,assign)    int            orderId ;            //订单号
 
 @property (nonatomic,assign)    long long      date ;               //tick
 
 @property (nonatomic,assign)    int            status ;             //状态
 
 @property (nonatomic,assign)    float          total ;
 
 @property (nonatomic,copy)      NSString       *code ;              //订单号 显示字符串
 
 @property (nonatomic,copy)      NSString       *payType ;
 
 @property (nonatomic,assign)    int            rate ;               //星级
 
 @property (nonatomic,retain)    NSDictionary   *productDiction ;
 
 @property (nonatomic,retain)    NSArray        *productList ;
 
 @property (nonatomic,retain)    ReceiveAddress *address ;
 
 // ----------------------
 
 // 快递
 @property (nonatomic,assign)    int            kuaidi ;
 
 @property (nonatomic,assign)    int            bag_status ;
 
 @property (nonatomic,assign)    int            type ;               //1.父订单   2.子订单
 
 @property (nonatomic,retain)    NSArray        *bagArray ;            //bagDic
 
 
 @property (nonatomic)           int            residual_status ;    //剩余的未打包的商品
 
 @property (nonatomic,retain)    NSArray        *residualArray ;     //剩余的未打包的商品list
 
 
 - (instancetype)initWithDic:(NSDictionary *)dictionary ;
 */