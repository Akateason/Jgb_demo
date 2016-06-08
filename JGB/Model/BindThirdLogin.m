//
//  BindThirdLogin.m
//  JGB
//
//  Created by ; on 15-1-22.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "BindThirdLogin.h"

@implementation BindThirdLogin

- (instancetype)initWithUserID:(NSString *)userIDStr
                  AndWithToken:(NSString *)token
               AndWithUserName:(NSString *)uName
                    AndWithSex:(int)uSex
                   AndWithType:(NSString *)type
               AndWithRemindIn:(NSString *)remindIn
               AndWithExpireIn:(NSString *)expireIn
           AndWithRefreshToken:(NSString *)refreshToken

{
    self = [super init];
    if (self)
    {
        _user         = userIDStr ;
        _token_Third  = token ;
        _userName     = uName ;
        _userSex      = (!uSex) ? 1 : uSex ;
        _type         = type ;
        _remindIn     = remindIn ;
        _expireIn     = expireIn ;
        _refreshToken = refreshToken ;
    }
    
    return self;
}

- (instancetype)initWithWeiboUser:(WeiboUser *)weiboUser
               AndWithAccessToken:(NSString *)token
                  AndWithRemindIn:(NSString *)remindIn
                  AndWithExpireIn:(NSString *)expireIn
{
    self = [super init];
    if (self)
    {
        _user         = weiboUser.idstr ;
        _token_Third  = token ;
        _userName     = weiboUser.userName ;
        _userSex      = weiboUser.gender ;
        _type         = @"sina" ;
        _remindIn     = remindIn ;
        _expireIn     = expireIn ;
        _refreshToken = nil     ;
    }
    
    return self;
}

- (instancetype)initWithQQUserName:(NSString *)username
                  AndWithQQUserSex:(int)usersex
                     AndWithQQUser:(NSString *)user
                AndWithAccessToken:(NSString *)token
                   AndWithExpireIn:(NSString *)expireIn
{
    self = [super init];
    if (self)
    {
        _user         = user ;
        _token_Third  = token ;
        _userName     = username ;
        _userSex      = usersex ;
        _type         = @"qq" ;
        _expireIn     = expireIn ;
        _remindIn     = nil ;
        _refreshToken = nil     ;
    }
    
    return self;
}


- (instancetype)initWithWeiXinInfo:(WeiXinUserToken *)weixinUserToken
                 AndWithWeiXinUser:(WeiXinUser *)weixinUser
{
    self = [super init];
    if (self) {
        _user = weixinUserToken.unionID ;
        _token_Third = weixinUserToken.accessToken ;
        _userName = weixinUser.nickname ;
        _userSex = weixinUser.sex ;
        _type = @"weixin" ;
        _expireIn = [NSString stringWithFormat:@"%ld",weixinUserToken.expiresIn] ;
        _remindIn = nil ;
        _refreshToken = weixinUserToken.refreshToken ;
    }
    return self;
}

@end
