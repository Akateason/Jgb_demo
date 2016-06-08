//
//  ChinaKuaidi.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChinaData.h"

@interface ChinaKuaidi : NSObject

@property (nonatomic)           int             chinaKuaidiID   ;
@property (nonatomic,copy)      NSString        *name           ;
@property (nonatomic,copy)      NSString        *order          ;
@property (nonatomic)           int             num             ;
@property (nonatomic,copy)      NSString        *updateTime     ;
@property (nonatomic,copy)      NSString        *message        ;
@property (nonatomic,copy)      NSString        *errCode        ;
@property (nonatomic)           int             status          ;

@property (nonatomic,retain)    NSArray         *dataArray      ;

- (instancetype)initWithDictionary:(NSDictionary *)dic          ;

@end
