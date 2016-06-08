//
//  KuaidiHistory.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChinaData.h"

@interface KuaidiHistory : NSObject

@property (nonatomic)       int         idHistory   ;
@property (nonatomic)       int         idKuaidi    ;
@property (nonatomic,copy)  NSString    *content    ;
@property (nonatomic)       int         status      ;
@property (nonatomic)       long long   create_time ;

- (instancetype)initWithDiction:(NSDictionary *)dictionary  ;

- (instancetype)initWithChinaData:(ChinaData *)data         ;



@end
