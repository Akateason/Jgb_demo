//
//  WareHouse.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-6.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WareHouse : NSObject

@property (nonatomic)           int         idWarehouse ;
@property (nonatomic,copy)      NSString    *name ;
@property (nonatomic,copy)      NSString    *url ;
@property (nonatomic,copy)      NSString    *content ;

- (instancetype)initWithDic:(NSDictionary *)dic AndWithID:(int)idWH ;

+ (NSArray *)getAllWarehouseFromDB ;

+ (WareHouse *)getWarehouseWithID:(int)idWarehouse ;

@end
