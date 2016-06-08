//
//  ShopCarGood.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-24.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goods.h"
#import "CheckPrice.h"
#import "TabBarController.h"


@protocol ShopCarGoodDelegate <NSObject>

- (void)goToCheckOutViewCallBackWithDic:(NSDictionary *)dictionary ;

- (void)addToShopCarSuccessCallBack ;

@end

@interface ShopCarGood : NSObject

@property (nonatomic,retain) id <ShopCarGoodDelegate> delegate ;

//

@property (nonatomic,assign) int        cid             ;       //购物车id
@property (nonatomic,assign) int        bid             ;       //卖家id
@property (nonatomic,copy) NSString     *pid            ;       //商品id

@property (nonatomic,assign) float      price           ;

@property (nonatomic,assign) float      weight          ;       //重量
@property (nonatomic,assign) float      total_prices    ;       //总价格
@property (nonatomic,assign) float      total_weight    ;       //总重量
@property (nonatomic,assign) long long  date            ;       //tick


@property (nonatomic,retain) Goods      *good           ;
@property (nonatomic,retain) CheckPrice *checkPrice     ;

@property (nonatomic,assign) int        nums            ;       //数量 购买数量


@property (nonatomic,retain) NSDictionary    *guige     ;       //规格
@property (nonatomic,copy)   NSString        *feature   ;
@property (nonatomic,copy)   NSString        *title     ;
@property (nonatomic,copy)   NSString        *images    ;
@property (nonatomic,copy)   NSString        *sku       ;
//核价
@property (nonatomic)       long long        ts         ;
@property (nonatomic)       BOOL             buyStatus  ;

//比特币
@property (nonatomic)       BOOL             is_bitcoin ;
//jcode
@property (nonatomic,copy)   NSString        *jcode     ;


/*
 ** 商品类
 1.购物车 list中的处理
 */
@property (nonatomic,assign) BOOL   isSelectedInShopCar ;       //是否在购物车中被选中
@property (nonatomic)        bool   isLoseEfficient ;           //是否失效


+ (ShopCarGood *)shareInstance ;

- (instancetype)initWithDiction:(NSDictionary *)dic     ;


+ (void)getShopCartCount ;

//立即购买
- (void)imidiatelyBuyNowWithGood:(Goods *)good AndWithNums:(int)number      ;
//加入购物车
- (void)addToShopCarWithGoods:(Goods *)good AndWithNumber:(int)buyNumber    ;


// 获取购物车list , 参数, 全部或者选中的
+ (NSMutableArray *)getShopCartListWithAllOrSelected:(BOOL)bAllOrSelected
                                    AndWithDataSouce:(NSMutableDictionary *)dicDataSource
                                     AndWithKeyArray:(NSMutableArray *)keyArray ;


@end
