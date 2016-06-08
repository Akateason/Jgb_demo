//
//  WeiboUser.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

// 微博第三方登录用户 对象

@interface WeiboUser : NSObject

@property (nonatomic,copy) NSString *idstr          ;       //微博用户id
@property (nonatomic,copy) NSString *userName       ;       //用户名
@property (nonatomic,copy) NSString *location       ;       //上海 浦东
@property (nonatomic,copy) NSString *avatar_large   ;       //头像大图
@property (nonatomic)      int       gender         ;       // 0无, 1 男, 2 女

- (instancetype)initWithDic:(NSDictionary *)dic     ;


@end
