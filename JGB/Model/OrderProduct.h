//
//  OrderProduct.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderProduct : NSObject



@property (nonatomic) int                   orders_id ;             //订单id

@property (nonatomic) int                   bag_id ;                //包裹id

@property (nonatomic) int                   uid ;                   //用户id

@property (nonatomic) int                   bid ;                   //商家id

@property (nonatomic,copy) NSString         *pid ;                  //商品id

@property (nonatomic,copy) NSString         *sku ;

@property (nonatomic,retain) NSDictionary   *guige ;                //规格

@property (nonatomic) float                 prices ;                //单价

@property (nonatomic) int                   nums ;                  //数量

@property (nonatomic) float                 total_prices ;          //总价

@property (nonatomic) int                   commment ;              //评论数量

@property (nonatomic) long long             date ;                  //tick

@property (nonatomic,copy)      NSString    *title ;

@property (nonatomic,copy)      NSString    *images ;

@property (nonatomic,copy)      NSString    *features ;

- (instancetype)initWithDic:(NSDictionary *)dictionary ;

- (instancetype)initWithBagDic:(NSDictionary *)dic ;

@end
