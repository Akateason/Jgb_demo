//
//  WeiXinUserToken.m
//  JGB
//
//  Created by JGBMACMINI01 on 15/4/24.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "WeiXinUserToken.h"

@implementation WeiXinUserToken

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _accessToken = [dic objectForKey:@"access_token"] ;
        _expiresIn = [[dic objectForKey:@"expires_in"] longValue] ;
        _refreshToken = [dic objectForKey:@"refresh_token"] ;
        _openID = [dic objectForKey:@"openid"] ;
        _scope = [dic objectForKey:@"scope"] ;
        _unionID = [dic objectForKey:@"unionid"] ;
    }
    
    return self;
}

@end
