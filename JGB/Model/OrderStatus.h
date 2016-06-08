//
//  OrderStatus.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderStatus : NSObject

@property (nonatomic)           int             idStatus ;
@property (nonatomic,copy)      NSString        *name    ;

- (instancetype)initWithDic:(NSDictionary *)diction      ;

+ (NSArray *)getOrderStatusList:(NSDictionary *)config ;

@end
