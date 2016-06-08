//
//  LikeProduct.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-19.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goods.h"

@interface LikeProduct : NSObject

@property (nonatomic,assign) int            id_like     ;

@property (nonatomic,copy)   NSString       *pid        ;

@property (nonatomic,assign) int            uid         ;

@property (nonatomic)        long long      date        ;

@property (nonatomic,retain) Goods          *product    ;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary ;

@end
