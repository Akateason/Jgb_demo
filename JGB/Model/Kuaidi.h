//
//  Kuaidi.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KuaidiHistory.h"

@interface Kuaidi : NSObject

@property (nonatomic)       int             idKuaidi    ;
@property (nonatomic,copy)  NSString        *name       ;
@property (nonatomic)       NSString        *number     ;
@property (nonatomic)       int             status      ;
@property (nonatomic)       long long       create_time ;
@property (nonatomic,copy)  NSString        *key        ;


@property (nonatomic,retain)NSArray         *historyArr ;


- (instancetype)initWithDic:(NSDictionary *)diction     ;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary ;

@end
