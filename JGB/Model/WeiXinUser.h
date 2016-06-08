//
//  WeiXinUser.h
//  JGB
//
//  Created by JGBMACMINI01 on 15/4/24.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

// 微信第三方登录用户 对象

@interface WeiXinUser : NSObject

@property (nonatomic,copy)   NSString *openid ;
@property (nonatomic,copy)   NSString *nickname ;
@property (nonatomic)        int sex ;
@property (nonatomic,copy)   NSString *headimgurl;

- (instancetype)initWithDic:(NSDictionary *)dic ;

@end
