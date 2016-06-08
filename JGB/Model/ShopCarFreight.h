//
//  ShopCarFreight.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-8.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

//购物车运费

@interface ShopCarFreight : NSObject

@property (nonatomic) float   inter_freight ;

@property (nonatomic) float   usa_freight   ;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary ;

@end
