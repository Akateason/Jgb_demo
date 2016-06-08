//
//  PayType.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-11.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayType : NSObject

@property (nonatomic,copy) NSString     *name   ;
@property (nonatomic,copy) NSString     *key    ;
@property (nonatomic,copy) NSString     *images ;

- (instancetype)initWithDiction:(NSDictionary *)dic ;

+ (PayType *)getPaytypeWithKey:(NSString *)key ;

@end
