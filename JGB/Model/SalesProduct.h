//
//  SalesProduct.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

//  促销商品 (同商品goods)他么冗余的数据

@interface SalesProduct : NSObject

@property (nonatomic)       int      pid            ;//促销商品id
@property (nonatomic)       int      actid          ;//促销活动id
@property (nonatomic)       int      areaid         ;//促销区域id
@property (nonatomic,copy)  NSString *productid     ;//商品code
@property (nonatomic,copy)  NSString *product_name  ;//产品名称
@property (nonatomic,copy)  NSString *product_image ;//产品图片
@property (nonatomic,copy)  NSString *productpic    ;//产品引用图片(后台可以添加)


@property (nonatomic)       float freight           ;//运费
@property (nonatomic)       float rmb_price         ;//人民币原价
@property (nonatomic)       float discount_price    ;//优惠差价
@property (nonatomic)       float list_actual_price ;//市场价
@property (nonatomic)       float actual_price      ;//销售价(含运费)

//  list_actual_price = actual_price + discount_price
//       actual_price = rmb_price + 运费

- (instancetype)initWithDic:(NSDictionary *)dic     ;

@end
