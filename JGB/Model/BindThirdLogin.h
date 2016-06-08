//
//  BindThirdLogin.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-22.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboUser.h"
#import "WeiXinUser.h"
#import "WeiXinUserToken.h"

/*
 *  第三方登录, 绑定
 */
@interface BindThirdLogin : NSObject

@property (nonatomic,copy)      NSString   *userName    ;
@property (nonatomic)           int        userSex      ;  //default is 1 男. 2女

@property (nonatomic,copy)      NSString   *user        ;   //第三方useridstr
@property (nonatomic,copy)      NSString   *token_Third ;   //第三方token

@property (nonatomic,copy)      NSString   *type        ;   // 第三方类型, sina, qq, weixin

@property (nonatomic,copy)      NSString   *remindIn    ;
@property (nonatomic,copy)      NSString   *expireIn    ;

@property (nonatomic,copy)      NSString   *refreshToken ;  //qq独有

//  initail
- (instancetype)initWithUserID:(NSString *)userIDStr
                  AndWithToken:(NSString *)token
               AndWithUserName:(NSString *)uName
                    AndWithSex:(int)uSex
                   AndWithType:(NSString *)type
               AndWithRemindIn:(NSString *)remindIn
               AndWithExpireIn:(NSString *)expireIn     ;

//  initail with weibo User 
- (instancetype)initWithWeiboUser:(WeiboUser *)weiboUser
               AndWithAccessToken:(NSString *)token
                  AndWithRemindIn:(NSString *)remindIn
                  AndWithExpireIn:(NSString *)expireIn  ;

//  initail with qq User
- (instancetype)initWithQQUserName:(NSString *)username
                  AndWithQQUserSex:(int)usersex
                     AndWithQQUser:(NSString *)user
                AndWithAccessToken:(NSString *)token
                   AndWithExpireIn:(NSString *)expireIn ;


//  initail with weixin User
- (instancetype)initWithWeiXinInfo:(WeiXinUserToken *)weixinUserToken
                 AndWithWeiXinUser:(WeiXinUser *)weixinUser ;

@end
