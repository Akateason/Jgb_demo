//
//  ServerRequest.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ServerRequest.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "LSCommonFunc.h"
#import "NoteCantBuy.h"
#import "OrderStatus.h"
#import "BagStatus.h"
#import "TransportStatus.h"
#import "PlatformInfomation.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

#define TIMEOUT     10

@implementation ServerRequest

//配置列表
+ (ResultPasel *)getConfigList
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CONFIG_LIST];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"getConfigList response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
    
}

//+ (ResultPasel *)getSizeType
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_SIZE_GUIGE];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    request.timeOutSeconds = TIMEOUT ;
//    [request setPostValue:@"size" forKey:@"type"] ;
//    [request startSynchronous];
//    
//    NSError *error = [request error];
//    NSString *response;
//    
//    if ( !error )
//    {
//        response = [request responseString]     ;
//        NSLog(@"getSizeType response:%@",response)  ;
//        
//        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
//        NSDictionary *dictionary = [parser objectWithString:response] ;
//        
//        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
//        
//        return result ;
//    }
//    
//    NSLog(@"error:%@",error);
//    
//    return nil ;
//
//}

//版本检测
+ (ResultPasel *)checkVersionWithVersionNum:(float)versionNum
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_VERSION];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];

    request.timeOutSeconds = TIMEOUT                                      ;
    
    [request setPostValue:[NSNumber numberWithFloat:versionNum]       forKey:@"versionSend"]    ;
    
    [request setPostValue:@"ios"                                      forKey:@"type"]           ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"checkVersion response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}

//验证开关
+ (ResultPasel *)checkSwitchWithVersionNum:(float)versionNum
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CHECKSWITCH];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT                                      ;
    
    [request setPostValue:[NSNumber numberWithFloat:versionNum]       forKey:@"versionSend"]    ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"checkSwitch response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


#pragma mark - 仓库
//获取所有仓库
+ (ResultPasel *)getAllWareHouse
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GETALLWAREHOUSE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT                ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"getAllWareHouse response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


#pragma mark - 推送通知
//设备安装      osVersion系统版本号码 ,    deviceUID真机ID , appVersion 软件版本号码
+ (ResultPasel *)letDeviceInstall:(NSString *)deviceUID AndAppVersion:(NSString *)appVersion AndWithOS:(NSNumber *)osVersion
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_DEVICE_INSTALL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT                ;
    
    [request setPostValue:CLIENT_KEY        forKey:@"client_key"]       ;
    [request setPostValue:CLIENT_SECRET     forKey:@"client_secret"]    ;

//    [request setPostValue:@"1"        forKey:@"device_type"]  ;
    
    [request setPostValue:deviceUID     forKey:@"device_token"]   ;
    [request setPostValue:appVersion    forKey:@"app_version"]    ;
    [request setPostValue:osVersion     forKey:@"device_os"]    ;

    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"letDeviceInstall response:%@",response)  ;
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


//设备绑定
+ (ResultPasel *)bindDeviceUID:(NSString *)deviceUID AndAccount:(NSString *)account
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_DEVICE_BIND];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT                ;
    
    [request setPostValue:CLIENT_KEY        forKey:@"client_key"]       ;
    [request setPostValue:CLIENT_SECRET     forKey:@"client_secret"]    ;

//    [request setPostValue:@"ios"    forKey:@"device_type"]  ;
    [request setPostValue:deviceUID forKey:@"device_token"] ;
    [request setPostValue:account   forKey:@"access_token"] ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"bindDeviceUID AndAccount response:%@",response)  ;
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


#pragma mark --

//用户注册
+ (ResultPasel *)registerWithUser:(User *)user
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_USER_REG];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];

    [request setPostValue:CLIENT_KEY        forKey:@"client_key"]       ;
    [request setPostValue:CLIENT_SECRET     forKey:@"client_secret"]    ;
    
    [request setPostValue:user.accountName  forKey:@"account"]          ;
    [request setPostValue:user.password     forKey:@"password"]         ;
    [request setPostValue:user.nickName     forKey:@"uname"]            ;

    request.timeOutSeconds = TIMEOUT    ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"reg response: %@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}




//Oauth2-获取用户authorize
+ (ResultPasel *)getAuthorizeWithUserName:(NSString *)username AndWithPassword:(NSString *)password
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_AUTHORIZE]  ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]]                      ;
    
    [request setPostValue:CLIENT_KEY    forKey:@"client_key"]   ;
    [request setPostValue:username      forKey:@"username"]     ;
    [request setPostValue:password      forKey:@"password"]     ;
    
    request.timeOutSeconds = TIMEOUT                                ;
    
    [request startSynchronous]              ;
    
    NSError *error = [request error]        ;
    
    NSString *response;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"login : %@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
    
}

//Oauth2-获取用户accesstoken
+ (NSString *)getAccessTokenWithTempCode:(NSString *)code
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GET_TOKEN]  ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]]                      ;
    
    [request setPostValue:CLIENT_KEY       forKey:@"client_key"]      ;
    [request setPostValue:CLIENT_SECRET    forKey:@"client_secret"]   ;
    [request setPostValue:code             forKey:@"code"]            ;

    request.timeOutSeconds = TIMEOUT                                      ;
    
    [request startSynchronous]              ;
    
    NSError *error = [request error]        ;
    
    NSString *response                      ;
    
    if (!error)
    {
        response = [request responseString] ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        int code = [[dictionary objectForKey:@"code"] intValue] ;
        
        if ( code == 200 )
        {
            //success
            NSString *code = [[dictionary objectForKey:@"data"] objectForKey:KEY_TOKEN] ;

            return code ;
        }
    }
    else
    {
        NSLog(@"error:%@",error) ;
    }
    
    return nil ;
}


//微博用户信息
+ (NSDictionary *)getWeiboUserInfoWithToken:(NSString *)weiboToken
                             AndWithUid:(NSString *)uid
{
    NSString *str = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@&source=%@",weiboToken,uid,kAppKey_WEBO];
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"weibo jsonStr:%@",jsonStr);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:jsonStr] ;
    
    return dictionary ;
}

//账号-获取用户临时hash H5
+ (ResultPasel *)getTempHashToLoginH5WithUid:(NSString *)uid
                                 AndWithTime:(long long)tick
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GET_HASH];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:CLIENT_KEY        forKey:@"client_key"]     ;
    
    [request setPostValue:CLIENT_SECRET     forKey:@"client_secret"]  ;
    
    [request setPostValue:uid               forKey:@"user_id"] ;
    
    [request setPostValue:[NSNumber numberWithLongLong:tick]
                   forKey:@"time"] ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"getTempHashToLoginH5WithUid response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}




//发送短信
+ (ResultPasel *)sendSMSWithPhoneNum:(NSString *)phoneNumber AndWithTempletCode:(NSString *)templetCode AndWithKeyArray:(NSArray *)keyArray
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_SEND_SMS];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    
    request.timeOutSeconds = TIMEOUT                                      ;
    
    [request setPostValue:CLIENT_KEY        forKey:@"client_key"]     ;

    [request setPostValue:CLIENT_SECRET     forKey:@"client_secret"]  ;
    
    [request setPostValue:phoneNumber       forKey:@"mobile"]         ;
    
    [request setPostValue:templetCode       forKey:@"templet_code"]   ;

    NSString *keyarrJsonStr = @"" ;
    if ( !keyArray )
    {
        keyarrJsonStr = @"{}" ;
    }
    [request setPostValue:keyarrJsonStr forKey:@"keyArray"]           ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"sendSMS response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }

    NSLog(@"error:%@",error);
    
    return nil ;
}


//校验账号
/*
 *  account  手机号/邮箱
 **/
+ (ResultPasel *)checkAccountWithAccount:(NSString *)account
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CHECK_PASSWORD];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    
    request.timeOutSeconds = TIMEOUT                                      ;
    
    [request setPostValue:CLIENT_KEY        forKey:@"client_key"]     ;
    
    [request setPostValue:CLIENT_SECRET     forKey:@"client_secret"]  ;
    
    [request setPostValue:account           forKey:@"account"]       ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"checkAccountWithAccount response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


//修改密码
/*
 *  account  手机/邮箱
 */
+ (ResultPasel *)resetNewPassword:(NSString *)password AndWithAccount:(NSString *)account
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_FIND_PASSWORD];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    
    request.timeOutSeconds = TIMEOUT                                      ;
    
    [request setPostValue:CLIENT_KEY        forKey:@"client_key"]     ;
    
    [request setPostValue:CLIENT_SECRET     forKey:@"client_secret"]  ;
    
    [request setPostValue:account           forKey:@"account"]        ;

    [request setPostValue:password          forKey:@"password"]       ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"resetNewPassword response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}

#pragma mark --
#pragma mark - 微信登陆
+ (NSDictionary *)weixinApiGetAccessTokenWithCode:(NSString *)code
{
    NSString *str = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kAppKey_WEIXIN,kSecret_WEIXIN,code] ;
    NSURL *url = [NSURL URLWithString:str] ;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"weixin get accesstoken jsonStr:%@",jsonStr);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:jsonStr] ;
    
    return dictionary ;
}

+ (NSDictionary *)weixinGetUserInfoWithAccessToken:(NSString *)accessToken AndWithOpenID:(NSString *)openID
{
    NSString *str = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openID];
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"weixin get userInfo jsonStr:%@",jsonStr);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:jsonStr] ;
    
    return dictionary ;
}


#pragma mark - 第三方登录, 绑定
/*****************************************************
 第三方登录-校验绑定状态
 *@param :
 client_key             String	Y	分配给客户端的key
 client_secret          String	Y	分配给客户端的秘钥
 connect_type           String	Y	第三方类型qq,weibo,
 connect_user           String	Y	第三方用户
 connect_access_token	String	Y	第三方用户授权令牌
 
 *@return :
 client_key             String      分配给客户端的key
 user_id                Integer     用户id
 access_token           String      用户访问授权
 ******************************************************/
+ (ResultPasel *)thirdLoginCheckConnectWithThirdLoginObj:(BindThirdLogin *)loginObj
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PASS_CHECKCONECT];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    request.timeOutSeconds      = TIMEOUT ;
    
    [request setPostValue:CLIENT_KEY                forKey:@"client_key"]           ;
    [request setPostValue:CLIENT_SECRET             forKey:@"client_secret"]        ;
    [request setPostValue:loginObj.type             forKey:@"connect_type"]         ;
    [request setPostValue:loginObj.user             forKey:@"connect_user"]         ;
    [request setPostValue:loginObj.token_Third      forKey:@"connect_access_token"] ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"thirdLoginCheckConnect response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}



/*****************************************************
 第三方登录-检查是否绑定第三方账号
 *@param :
 client_key	String	Y	分配给客户端的key
 client_secret	String	Y	分配给客户端的秘钥
 connect_type	String	Y	第三方类型
 account	String	Y	站内账号
 password	String	Y	站内密码
 *****************************************************/
+ (ResultPasel *)thirdLoginCheckBindWithThirdLoginObj:(BindThirdLogin *)loginObj AndAccount:(NSString *)account AndWithPassword:(NSString *)password
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PASS_CHECKBIND];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    request.timeOutSeconds      = TIMEOUT ;
    
    [request setPostValue:CLIENT_KEY            forKey:@"client_key"]           ;
    [request setPostValue:CLIENT_SECRET         forKey:@"client_secret"]        ;
    
    [request setPostValue:loginObj.type         forKey:@"connect_type"]         ;
    [request setPostValue:account               forKey:@"account"]              ;
    [request setPostValue:password              forKey:@"password"]             ;
    
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"thirdLogin check bind response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


/*****************************************************
 第三方登录-创建账号
 *@param :
 client_key             String	Y	分配给客户端的key
 client_secret          String	Y	分配给客户端的秘钥
 connect_type           String	Y	第三方类型
 connect_user           String	Y	第三方用户
 connect_access_token	String	Y	第三方用户授权令牌
 user_name              String	Y	用户昵称
 user_sex               String	N	用户性别 1男 2女 0保密，为空1
 connect_refresh_token	String	N	自动授权token
 connect_remind_in      String	N	授权提醒时间
 connect_expires_in     String	N	授权结束时间
 
 *@return :
 client_key         String	分配给客户端的key
 user_id            Integer	用户id
 access_token       String	用户访问授权
 *****************************************************/
+ (ResultPasel *)thirdLoginCreateConnectWithThirdLoginObj:(BindThirdLogin *)loginObj
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PASS_CREATE] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    request.timeOutSeconds      = TIMEOUT ;
    
    [request setPostValue:CLIENT_KEY              forKey:@"client_key"]            ;
    [request setPostValue:CLIENT_SECRET           forKey:@"client_secret"]         ;
    
    [request setPostValue:loginObj.type           forKey:@"connect_type"]          ;
    [request setPostValue:loginObj.user           forKey:@"connect_user"]          ;
    [request setPostValue:loginObj.token_Third    forKey:@"connect_access_token"]  ;
    [request setPostValue:loginObj.userName       forKey:@"user_name"]             ;
    NSNumber *secNum = [NSNumber numberWithInt:loginObj.userSex] ;
    [request setPostValue:secNum                  forKey:@"user_sex"]              ;
    
    if (loginObj.refreshToken) {
        [request setPostValue:loginObj.refreshToken   forKey:@"connect_refresh_token"] ;
    }
    
    [request setPostValue:loginObj.remindIn       forKey:@"connect_remind_in"]     ;
    [request setPostValue:loginObj.expireIn       forKey:@"connect_expires_in"]    ;
    
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"thirdLoginCreateConnect response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


/*****************************************************
 第三方登录-注册账号
 *@param :
 client_key             String	Y	分配给客户端的key
 client_secret          String	Y	分配给客户端的秘钥
 connect_type           String	Y	第三方类型
 connect_user           String	Y	第三方用户
 connect_access_token	String	Y	第三方用户授权令牌
 phone                  String	Y	手机号码/account
 password               String	Y	用户密码
 user_name              String	Y	用户昵称
 user_sex               String	N	用户性别 1男 2女 0保密，为空1
 connect_refresh_token	String	N	自动授权token
 connect_remind_in      String	N	授权提醒时间
 connect_expires_in     String	N	授权结束时间
 
 *@return
 client_key             String	分配给客户端的key
 user_id                Integer	用户id
 access_token           String	用户访问授权
 *****************************************************/
+ (ResultPasel *)thirdLoginRegisterConnectWithThirdLoginObj:(BindThirdLogin *)loginObj
                                               AndWithPhone:(NSString *)phoneNumber
                                            AndWithPassword:(NSString *)password
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PASS_REGISTER] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    request.timeOutSeconds      = TIMEOUT ;
    
    [request setPostValue:CLIENT_KEY            forKey:@"client_key"]            ;
    [request setPostValue:CLIENT_SECRET         forKey:@"client_secret"]         ;
    
    [request setPostValue:loginObj.type           forKey:@"connect_type"]          ;
    [request setPostValue:loginObj.user           forKey:@"connect_user"]          ;
    [request setPostValue:loginObj.token_Third    forKey:@"connect_access_token"]  ;
    
    [request setPostValue:phoneNumber           forKey:@"phone"]                 ;
    [request setPostValue:password              forKey:@"password"]              ;
    
    [request setPostValue:loginObj.userName              forKey:@"user_name"]             ;
    NSNumber *secNum = [NSNumber numberWithInt:loginObj.userSex] ;
    [request setPostValue:secNum                forKey:@"user_sex"]              ;
    
    if (loginObj.refreshToken)
    {
        [request setPostValue:loginObj.refreshToken          forKey:@"connect_refresh_token"] ;
    }
    
    [request setPostValue:loginObj.remindIn              forKey:@"connect_remind_in"]     ;
    [request setPostValue:loginObj.expireIn             forKey:@"connect_expires_in"]    ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"thirdLoginRegister response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}



/*****************************************************
 第三方登录-绑定账号
 *@param :
 client_key             String	Y	分配给客户端的key
 client_secret          String	Y	分配给客户端的秘钥
 connect_type           String	Y	第三方类型
 connect_user           String	Y	第三方用户
 connect_access_token	String	Y	第三方用户授权令牌
 account                String	Y	账号
 password               String	N	密码
 connect_refresh_token	String	N	自动授权token
 connect_remind_in      String	N	授权提醒时间
 connect_expires_in     String	N	授权结束时间
 
 *@return :
 client_key	String	分配给客户端的key
 user_id	Integer	用户id
 access_token	String	用户访问授权
 *****************************************************/
+ (ResultPasel *)thirdLoginBindWithThirdLoginObj:(BindThirdLogin *)loginObj
                                  AndWithAccount:(NSString *)account
                                 AndWithPassword:(NSString *)password
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PASS_BIND] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    request.timeOutSeconds      = TIMEOUT ;
    
    [request setPostValue:CLIENT_KEY            forKey:@"client_key"]            ;
    [request setPostValue:CLIENT_SECRET         forKey:@"client_secret"]         ;
    
    [request setPostValue:loginObj.type           forKey:@"connect_type"]          ;
    [request setPostValue:loginObj.user           forKey:@"connect_user"]          ;
    [request setPostValue:loginObj.token_Third    forKey:@"connect_access_token"]  ;
    [request setPostValue:account                 forKey:@"account"]               ;
    [request setPostValue:password                forKey:@"password"]              ;
    
    if (loginObj.refreshToken)
    {
        [request setPostValue:loginObj.refreshToken          forKey:@"connect_refresh_token"] ;
    }
    
    [request setPostValue:loginObj.remindIn       forKey:@"connect_remind_in"]     ;
    [request setPostValue:loginObj.expireIn       forKey:@"connect_expires_in"]    ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"thirdLoginBind response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


//get 个人中心-我的资料
+ (ResultPasel *)getMyUserInfo
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ACCOUNT_SHOW]   ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    request.timeOutSeconds = TIMEOUT    ;
    
    [request setPostValue:G_TOKEN forKey:KEY_TOKEN];
    
    [request setValidatesSecureCertificate:NO] ; 

    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"getMemberCenterMyInfo response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}

//change 个人中心-用户信息修改
+ (NSString *)changeUserInfoWith:(User *)user
{
    ///Account/modifyperson
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_UPDATE_UINFO];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN                                   forKey:KEY_TOKEN];
    [request setPostValue:user.nickName                             forKey:@"uname"] ;
    [request setPostValue:user.realName                             forKey:@"truename"] ;
    [request setPostValue:[NSNumber numberWithInt:user.sex]         forKey:@"sex"] ;
    [request setPostValue:[NSNumber numberWithLongLong:user.birth]  forKey:@"birthday"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        NSLog(@"change response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }

    return response ;
}

//获取上传头像token
+ (NSString *)getUploadPictureWithPictureName:(NSString *)picName AndWithBuckect:(NSString *)bucket
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GEI_IMGTOKEN];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN       forKey:KEY_TOKEN] ;
    [request setPostValue:bucket        forKey:@"bucket"]       ;
    [request setPostValue:picName       forKey:@"picture_url"]  ;
    
    [request startSynchronous]      ;

    NSError *error = [request error];
    NSString *response  ;
    if (!error)
    {
        response = [request responseString]     ;
        NSLog(@"change response:%@",response)   ;
    }
    else
    {
        NSLog(@"error:%@",error)                ;
    }
    
    return response ;
}


//公共-行政区域列表
+ (NSDictionary *)getAllArea
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GET_AREALIST];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT                                ;
    
    [request startSynchronous]                                  ;
    
    NSError *error = [request error];
    NSString *response                                          ;
    if (!error)
    {
        response = [request responseString]                     ;
        NSLog(@"get Area :%@",response)                         ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        int code = [[dictionary objectForKey:@"code"] intValue] ;
        if (code == 200)
        {
            //success
            NSDictionary *areaList = [dictionary objectForKey:@"data"] ;
            return areaList ;
        }
    }
    else
    {
        NSLog(@"error:%@",error)                ;
    }
    
    return nil ;
}


//我的优惠券
+ (ResultPasel *)getMyCoupsonListWithPage:(int)page AndWithSize:(int)size
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_MY_COUPSONS];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    
    request.timeOutSeconds = TIMEOUT                                                    ;
    
    [request setPostValue:G_TOKEN                           forKey:KEY_TOKEN]       ;
    
    [request setPostValue:[NSNumber numberWithInt:page]     forKey:@"page"]         ;
    
    [request setPostValue:[NSNumber numberWithInt:size]     forKey:@"size"]         ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        NSLog(@"getMyCoupsonList response:%@",response)  ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


//我的积分
+ (ResultPasel *)getMyPointsWithPage:(int)page AndWithSize:(int)size
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_MY_POINTS];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    
    request.timeOutSeconds = TIMEOUT                                                    ;
    
    [request setPostValue:G_TOKEN                           forKey:KEY_TOKEN]       ;
    
    [request setPostValue:[NSNumber numberWithInt:page]     forKey:@"page"]         ;
    
    [request setPostValue:[NSNumber numberWithInt:size]     forKey:@"size"]        ;
    
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    
    NSString *response                          ;
    
    if ( !error )
    {
        response = [request responseString]     ;
        
        NSLog(@"getMyPoints response:%@",response)  ;
        
        SBJsonParser *parser        = [[SBJsonParser alloc] init]               ;
        
        NSDictionary *dictionary    = [parser objectWithString:response]        ;
        
        ResultPasel *result         = [[ResultPasel alloc] initWithDictionary:dictionary] ;
        
        return result ;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


//新增收货地址
+ (BOOL)addAddressWithAddress:(ReceiveAddress *)address
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ADD_ADDR];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT                                ;
    
    [request setPostValue:G_TOKEN               forKey:KEY_TOKEN] ;
    [request setPostValue:address.uname         forKey:@"uname"]        ;
    [request setPostValue:[NSNumber numberWithInt:address.province] forKey:@"province"] ;
    [request setPostValue:[NSNumber numberWithInt:address.city]     forKey:@"city"] ;
    [request setPostValue:[NSNumber numberWithInt:address.area]     forKey:@"area"] ;
    [request setPostValue:address.address       forKey:@"address"] ;
    [request setPostValue:[NSNumber numberWithInt:address.areacode] forKey:@"areacode"] ;
    [request setPostValue:address.phone         forKey:@"phone"] ;
    [request setPostValue:address.idcard        forKey:@"idcard"] ;
    [request setPostValue:[NSNumber numberWithInt:address.isDefault] forKey:@"isdefault"] ;
    [request setPostValue:address.email         forKey:@"email"] ;
    
    [request startSynchronous]                                  ;
    
    NSError *error = [request error];
    NSString *response                                          ;
    if (!error)
    {
        response = [request responseString]                     ;
        NSLog(@"addAddressWithAddress :%@",response)                         ;
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        int code = [[dictionary objectForKey:@"code"] intValue] ;
        if (code == 200)
        {
            return YES ;
        }
    }
    else
    {
        NSLog(@"error:%@",error)                ;
        return NO ;
    }
    
    return NO ;
}

//修改收货地址
+ (BOOL)editAddressWithAddress:(ReceiveAddress *)address
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_UPDATE_ADDR];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];

    request.timeOutSeconds = TIMEOUT                                ;
    
    [request setPostValue:G_TOKEN                                       forKey:KEY_TOKEN] ;
    [request setPostValue:address.uname                                 forKey:@"uname"] ;
    [request setPostValue:[NSNumber numberWithInt:address.province]     forKey:@"province"] ;
    [request setPostValue:[NSNumber numberWithInt:address.city]         forKey:@"city"] ;
    [request setPostValue:[NSNumber numberWithInt:address.area]         forKey:@"area"] ;
    [request setPostValue:address.address                               forKey:@"address"] ;
    [request setPostValue:[NSNumber numberWithInt:address.areacode]     forKey:@"areacode"] ;
    [request setPostValue:address.phone                                 forKey:@"phone"] ;
    [request setPostValue:address.idcard                                forKey:@"idcard"] ;
    [request setPostValue:[NSNumber numberWithInt:address.isDefault]    forKey:@"isdefault"] ;
    [request setPostValue:address.email                                 forKey:@"email"] ;
    [request setPostValue:[NSNumber numberWithInt:address.addressId]    forKey:@"id"] ;
    [request setPostValue:address.tel                                   forKey:@"tel"] ;
    
    [request startSynchronous]                                  ;
    
    NSError *error = [request error];
    NSString *response                                          ;
    if (!error)
    {
        response = [request responseString]                     ;
        NSLog(@"editAddressWithAddress :%@",response)                         ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        int code = [[dictionary objectForKey:@"code"] intValue] ;
        if (code == 200)
        {
            return YES ;
        }
    }
    else
    {
        NSLog(@"error:%@",error)                ;
        return NO ;
    }

    return NO ;
}



//拿收货地址列表
+ (NSArray *)getMyAddressList
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GET_ADDR_LIST];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT                                ;
    [request setPostValue:G_TOKEN forKey:KEY_TOKEN]             ;
    
    [request startSynchronous]                                  ;
    
    NSError *error = [request error];
    NSString *response                                          ;
    if (!error)
    {
        response = [request responseString]                     ;
        NSLog(@"getMyAddressList :%@",response)                         ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        int code = [[dictionary objectForKey:@"code"] intValue] ;
        if (code == 200)
        {
            //success
            NSArray *addrList = [dictionary objectForKey:@"data"] ;
            
            return addrList ;
        }
    }
    else
    {
        NSLog(@"error:%@",error) ;
        
        return nil ;
    }
   return nil ;
}

//删除收货地址
+ (BOOL)deleteAddressWithID:(int)addressID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_DEL_ADDR];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT                                ;
    [request setPostValue:G_TOKEN forKey:KEY_TOKEN]             ;
    [request setPostValue:[NSNumber numberWithInt:addressID] forKey:@"id"] ;
    
    [request startSynchronous]                                  ;
    
    NSError *error = [request error];
    NSString *response                                          ;
    if (!error)
    {
        response = [request responseString]                     ;
        NSLog(@"deleteAddressWithID :%@",response)                         ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dictionary = [parser objectWithString:response] ;
        int code = [[dictionary objectForKey:@"code"] intValue] ;
        if (code == 200)
        {
            //success
            return YES ;
        }
    }
    else
    {
        NSLog(@"error:%@",error) ;
        
        return NO ;
    }
    return NO ;
}

#pragma mark - 身份证
//身份证-查询单个
+ (ResultPasel *)getIdCardWithIdCardNO:(NSString *)idcard
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_SELECT_IDCARD] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:idcard forKey:@"number"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"getIdCardWithIdCard response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}


//身份证-更新
/*
 加密方式：
 Key：E(LBaGt]IW
 Md5（身份证号码+key+时间）
 */
+ (ResultPasel *)addIdCard:(NSString *)idcardNO AndWithFront:(NSString *)front AndWithBack:(NSString *)back
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ADD_IDCARD] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:idcardNO  forKey:@"number"] ;
    [request setPostValue:front     forKey:@"front"] ;
    [request setPostValue:back      forKey:@"back"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"addIdCard response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}



#pragma mark - 首页
//首页 促销信息
+ (ResultPasel *)getIndexListWithTagID:(int)tag_id
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_INDEXINFO];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;

    if (tag_id)
    {
        [request setPostValue:[NSNumber numberWithInt:tag_id] forKey:@"tag_id"]     ;
    }

    [request setPostValue:CLIENT_KEY            forKey:@"client_key"]            ;
    [request setPostValue:CLIENT_SECRET         forKey:@"client_secret"]         ;
    
    [request startSynchronous];

    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"getIndexList response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}


//获取活动
+ (ResultPasel *)getActivityWithPage:(int)page AndWithTagID:(int)tagID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GET_AREAIMGS];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds      = TIMEOUT ;
    
    [request setPostValue:[NSNumber numberWithInt:page]     forKey:@"page"]     ;
    [request setPostValue:CLIENT_KEY                        forKey:@"client_key"]            ;
    [request setPostValue:CLIENT_SECRET                     forKey:@"client_secret"]         ;

    if (tagID)
    {
        [request setPostValue:[NSNumber numberWithInt:tagID] forKey:@"tag_id"]   ;
    }
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"getActivityWithPageAndWithTagID response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}

//首页tags
+ (ResultPasel *)getTopicTags
{
    NSString *urlStr            = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GET_TOPICTAGS] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    request.timeOutSeconds      = TIMEOUT ;
    
    [request startSynchronous] ;
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString] ;
        
        NSLog(@"getTopicTags response:%@",response) ;
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result ;          //success
    }
    
    NSLog(@"error:%@",error) ;
    
    return nil ;                 //failure
}


#pragma mark - 商品
//商品分类
+ (NSArray *)getGoodsCatagoriesWithUpid:(int)upid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PRO_CATE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;

    [request setPostValue:[NSNumber numberWithInt:upid] forKey:@"pid"] ;
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
    }else {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:response] ;
    int code = [[dictionary objectForKey:@"code"] intValue] ;
    if (code == 200)
    {
        NSArray *array = [dictionary objectForKey:@"data"] ;
        return array ;
    }
    
    return nil ;
}



//拿商品分类表
+ (NSArray *)getAllCataTB
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PRO_ALLCATE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    
    [request setValidatesSecureCertificate:NO]  ;
    [request startSynchronous]                  ;
    
    NSError *error = [request error]            ;
    NSString *response;
    if (!error) {
        response = [request responseString];
    }else {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:response] ;
    int code = [[dictionary objectForKey:@"code"] intValue] ;
    if (code == 200) {
        NSArray *array = [dictionary objectForKey:@"data"] ;
        return array ;
    }
    
    return nil ;
}



//商品列表  如果数字传负数代表不传 字符串nil代表不传
/*
 *  page	int	N               页码 默认1
 *  size	Int	N               每页返回数量 默认20
 *  seller_id	int	n           卖家id
 *  title	string	N           商品标题关键字
 *  brand	string	N           品牌关键字
 *  category	string	N		查询条件：分类id 多个分类id用“,”分割101,10111 默认无
 *  low_price	float	N		价格区间最低价格
 *  hig_price	float	N		价格区间最高价格
 *  order_val	INT	N           排序的值 1价格 2评论
 *  order_way	int	N           排序的方法 1 升序 2降序
 *  session_code	string		用户的Token
 *  is_cn       int             是否中文 1 , 0
 *  is_cx       int             是否促销 1 , 0
 **/
+ (NSString *)getGoodsListWithCurrentSort:(CurrentSort *)currentSort
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PRO_LIST];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]]       ;
    request.timeOutSeconds = TIMEOUT                                                                         ;
    
    [request setPostValue:[NSNumber numberWithInt:currentSort.page]         forKey:@"page"]              ;
    [request setPostValue:[NSNumber numberWithInt:currentSort.size]         forKey:@"size"]              ;
    
    if (currentSort.sellerID != nil) {
        [request setPostValue:currentSort.sellerID                              forKey:@"seller_id"]     ;
    }
    if (currentSort.title != nil) {
        [request setPostValue:currentSort.title                                 forKey:@"title"]         ;
    }
    if (currentSort.brand != nil) {
        [request setPostValue:currentSort.brand                                 forKey:@"brand"]         ;
    }
    if (currentSort.catagory != nil) {
        [request setPostValue:currentSort.catagory                              forKey:@"category"]      ;
    }
    if (currentSort.lowPrice >= 0) {
        [request setPostValue:[NSNumber numberWithInt:currentSort.lowPrice]     forKey:@"low_price"]     ;
    }
    if (currentSort.highPrice >= 0) {
        [request setPostValue:[NSNumber numberWithInt:currentSort.highPrice]    forKey:@"hig_price"]     ;
    }
    if (currentSort.orderVal >= 0) {
        [request setPostValue:[NSNumber numberWithInt:currentSort.orderVal]     forKey:@"order_val"]     ;
    }
    if (currentSort.orderWay >= 0) {
        [request setPostValue:[NSNumber numberWithInt:currentSort.orderWay]     forKey:@"order_way"]     ;
    }
    if (currentSort.is_cn >= 0) {
        [request setPostValue:[NSNumber numberWithInt:currentSort.is_cn]        forKey:@"is_cn"]         ;
    }
    if (currentSort.is_cx >= 0) {
        [request setPostValue:[NSNumber numberWithInt:currentSort.is_cx]        forKey:@"is_cx"]         ;
    }
    if (currentSort.wareHouse_ID > 0) {
        [request setPostValue:[NSNumber numberWithInt:currentSort.wareHouse_ID]        forKey:@"warehouse_id"]    ;
    }
    
    [request startSynchronous];
    
    NSError     *error      = [request error]   ;
    NSString    *response                       ;
    
    if (!error) {
        response = [request responseString];
        NSLog(@"lst response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }
    
    return response ;
}



//商品详情
+ (NSString *)getGoodsDetailWithGoodsCode:(NSString *)goodsCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PRO_DETAIL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;

    [request setPostValue:goodsCode     forKey:@"code"] ;
    
    [request startSynchronous] ;
    
    NSError *error = [request error];
    NSString *response;
    if (!error)
    {
        response = [request responseString];
        NSLog(@"good detail response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }
    
    return response ;
}


//按首字母拿品牌
+ (NSDictionary *)getBrandListWithFirstLetter:(NSString *)letter AndWithCategoryNum:(int)cate
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GET_BRAND] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;

    [request setPostValue:letter                            forKey:@"first"]        ;
    [request setPostValue:[NSNumber numberWithInt:cate]     forKey:@"cid"]          ;

    [request startSynchronous] ;
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        NSLog(@"brand response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }
    
    
    SBJsonParser *parser        = [[SBJsonParser alloc] init]           ;
    NSDictionary *dictionary    = [parser objectWithString:response]    ;
    
    return dictionary ;
}


//按 分类 拿 品牌
+ (NSDictionary *)getBrandListWithCateNum:(int)cate
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GET_ALLBRAND] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:[NSNumber numberWithInt:cate]     forKey:@"cid"]  ;
    
    [request startSynchronous] ;
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        NSLog(@"brand response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }
    
    
    SBJsonParser *parser    = [[SBJsonParser alloc] init]           ;
    NSDictionary *dic          = [parser objectWithString:response]    ;
 
    NSLog(@"info : %@",[dic objectForKey:@"info"]) ;
    
    if ([[dic objectForKey:@"code"] intValue] == 200) {
        NSDictionary *data = [dic objectForKey:@"data"] ;
        return data ;
    }
    
    return nil ;
}

// 拿所有商家信息
+ (NSDictionary *)getSellerList
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ALL_SELLER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error)
    {
        response = [request responseString];
        NSLog(@"getSellerList response:%@",response);
    }
    else
    {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:response] ;
    int code = [[dictionary objectForKey:@"code"] intValue] ;
    
    if (code == 200)
    {
        //success
        NSDictionary *dataDic = [dictionary objectForKey:@"data"] ;
        return dataDic ;
    }else {
        //failure
        NSString *info = [dictionary objectForKey:@"info"] ;
        NSLog(@"info : %@",info) ;
    }
    
    return nil ;
}

//商品-评价列表
+ (ResultPasel *)getProductCommentListWithProCode:(NSString *)proCode  AndWithPage:(int)page AndWithSize:(int)size AndWithScore:(NSArray *)scoreArray
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_PRO_COM_LIST] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:proCode                       forKey:@"code"] ;
    
    [request setPostValue:[NSNumber numberWithInt:page] forKey:@"page"] ;
    
    [request setPostValue:[NSNumber numberWithInt:size] forKey:@"size"] ;
    
    if (scoreArray != nil)
    {
        NSString *scoreStr = [LSCommonFunc getCommaStringWithArray:scoreArray] ;
        [request setPostValue:scoreStr                      forKey:@"score"] ;
    }

    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"getProductCommentList response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}


//热词搜索
+ (ResultPasel *)getHotSearchList
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_HOT_SEARCH] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"getHotSearchList response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}


#pragma mark -- SHOP CARS

//购物车-总数统计
+(NSDictionary *)getCartCount
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CART_COUNT];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN forKey:KEY_TOKEN] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error)
    {
        response = [request responseString];
        NSLog(@"getCartCount response:%@",response);
    }
    else
    {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:response] ;
    int code = [[dictionary objectForKey:@"code"] intValue] ;
    
    if (code == 200)
    {
        //success
        NSDictionary *dataDic = [dictionary objectForKey:@"data"] ;
        
        return dataDic ;
    }
    else
    {
        //fail
        NSString *info = [dictionary objectForKey:@"info"] ;
        NSLog(@"info : %@",info) ;
        return nil ;
    }

    return nil ;
}





//获取购物车列表
+ (NSDictionary *)showShopCars
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CART_LIST];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    NSLog(@"G_TOKEN : %@",G_TOKEN) ;        // 不登陆不能看购物车
    [request setPostValue:G_TOKEN forKey:KEY_TOKEN];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        NSLog(@"showShopCars response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:response] ;
    int code = [[dictionary objectForKey:@"code"] intValue] ;
    
    if (code == 200) {
        //success
        NSDictionary *dataDic = [dictionary objectForKey:@"data"] ;
        
        return dataDic ;
    }else {
        //fail
        NSString *info = [dictionary objectForKey:@"info"] ;
        NSLog(@"info : %@",info) ;
    }
    
    return nil ;
}

//添加购物车
+ (ResultPasel *)add2ShopCarWithProductID:(NSString *)pid AndWithNums:(int)nums
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CART_ADD];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;

    [request setPostValue:G_TOKEN                       forKey:KEY_TOKEN];
    [request setPostValue:pid forKey:@"pid"]   ;
    [request setPostValue:[NSNumber numberWithInt:nums] forKey:@"nums"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;

    if (!error)
    {
        response = [request responseString];
        NSLog(@"add2ShopCarWithProductID response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}


//修改购物车
+ (BOOL)changeShopCarWithCid:(int)cid AndWithNums:(int)nums
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CART_UPDATE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN                       forKey:KEY_TOKEN]       ;
    [request setPostValue:[NSNumber numberWithInt:cid]  forKey:@"cid"]          ;
    [request setPostValue:[NSNumber numberWithInt:nums] forKey:@"nums"]         ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        NSLog(@"updatecart response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init]              ;
    NSDictionary *dictionary = [parser objectWithString:response]   ;
    
    int code = [[dictionary objectForKey:@"code"] intValue]         ;
    
    if (code == 200) {
        //success
        return YES ;
    }else {
        //fail
        return NO  ;
    }
}


//删除购物车
+ (BOOL)deleteShopCarWithCid:(int)cid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CART_DEL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN                       forKey:KEY_TOKEN]       ;
    [request setPostValue:[NSNumber numberWithInt:cid]  forKey:@"cid"]          ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        NSLog(@"cartdel response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init]              ;
    NSDictionary *dictionary = [parser objectWithString:response]   ;
    
    int code = [[dictionary objectForKey:@"code"] intValue]         ;
    
    if (code == 200) {
        //success
        return YES ;
    }else {
        //fail
        return NO  ;
    }
}


//运费计算
+ (ResultPasel *)calculateFreightWithCidLists:(NSArray *)cidLists
{
    NSString *urlStr            = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CART_FREIGHT];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds      = TIMEOUT       ;
    
    NSString *commaCidListStr   = @""       ;
    int index                   = 0         ;
    
    for (NSNumber *cidStr in cidLists)
    {
        if (index == cidLists.count - 1)
        {
            NSString *strCid = [NSString stringWithFormat:@"%@",cidStr]         ;
            commaCidListStr  = [commaCidListStr stringByAppendingString:strCid] ;
        }
        else
        {
            NSString *cidStrComma = [NSString stringWithFormat:@"%@,",cidStr] ;
            commaCidListStr = [commaCidListStr stringByAppendingString:cidStrComma] ;
        }
        
        index ++ ;
    }
    
    [request setPostValue:commaCidListStr forKey:@"cid"]            ;
    [request setPostValue:G_TOKEN         forKey:KEY_TOKEN]         ;
    
    [request startSynchronous];

    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"calculateFreightWithCidLists response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}




#pragma mark - 核价
//核价
+ (NSArray *)checkPriceWithList:(NSArray *)productList
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_CHECKPRICE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    
    NSString *commaProListStr = @""     ;
    int index = 0   ;
    for (NSNumber *pidStr in productList)
    {
        if (index == productList.count - 1)
        {
            NSString *strPid = [NSString stringWithFormat:@"%@",pidStr]         ;
            commaProListStr  = [commaProListStr stringByAppendingString:strPid] ;
        }
        else
        {
            NSString *pidStrComma = [NSString stringWithFormat:@"%@,",pidStr] ;
            commaProListStr = [commaProListStr stringByAppendingString:pidStrComma] ;
        }
        
        index ++ ;
    }
    
    [request setPostValue:commaProListStr forKey:@"product_ids"]      ;
    
    [request startSynchronous];

    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        NSLog(@"checkPrice response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init]              ;
    NSDictionary *dictionary = [parser objectWithString:response]   ;
    
    int code = [[dictionary objectForKey:@"code"] intValue]         ;
    
    if (code == 200) {
        //success
        NSArray *dataList = [dictionary objectForKey:@"data"] ;
        return dataList ;
    }else {
        //fai
        return nil  ;
    }

    return nil ;
}

//需要核价的商家
+ (ResultPasel *)getCheckPriceSeller
{
    NSString *str = [NSString stringWithFormat:@"%@/Product/getCheckPriceSeller",[DigitInformation shareInstance].g_servericeIP] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];

    request.timeOutSeconds = TIMEOUT ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"getCheckPriceSeller :%@",response);

        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dic = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    return nil ;
}


#pragma mark - 确认订单
//获取确认订单
+ (NSDictionary *)getCheckOutListWithCidList:(NSArray *)cidList
{    
    // /Pro/confirmOrder
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ORDER_CHECKOUT];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    
    //cartid
    NSString *commaCidListStr = @""     ;
    int index = 0   ;
    for (NSNumber *cidStr in cidList)
    {
        if (index == cidList.count - 1)
        {
            NSString *strCid = [NSString stringWithFormat:@"%@",cidStr]         ;
            commaCidListStr  = [commaCidListStr stringByAppendingString:strCid] ;
        }
        else
        {
            NSString *cidStrComma = [NSString stringWithFormat:@"%@,",cidStr] ;
            commaCidListStr = [commaCidListStr stringByAppendingString:cidStrComma] ;
        }
        
        index ++ ;
    }
    NSLog(@"commaCidListStr : %@",commaCidListStr) ;

    [request setPostValue:commaCidListStr forKey:@"cartId"]      ;
    //token
    [request setPostValue:G_TOKEN       forKey:KEY_TOKEN]        ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        NSLog(@"confirmOrder response:%@",response);
    }else {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init]              ;
    NSDictionary *dictionary = [parser objectWithString:response]   ;
    
    return dictionary ;
}


//创建订单
/*
 * @parame :    cartIDList  购物车列表
 *              addressID   地址id
 *              payType     支付方式
 *              couponID    优惠券id
 *              cousoncode  优惠码
 *              point       积分
 *
 */
+ (NSDictionary *)addOrderWithCartIDList:(NSArray *)cartIDList
                        AndWithAddressID:(NSString *)addressID
                          AndWithPayType:(NSString *)payType
                         AndWithCouponID:(NSString *)couponID
                       AndWithCouponCode:(NSString *)coupsonCode
                           AndWithCredit:(int)points
{

// /Pro/confirmOrder
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ORDER_CREATE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]]      ;
    request.timeOutSeconds = TIMEOUT           ;
    
//  cartID
    NSString *commaCidListStr = @""        ;
    int index = 0   ;
    for (NSNumber *cidStr in cartIDList)
    {
        if (index == cartIDList.count - 1)
        {
            NSString *strCid = [NSString stringWithFormat:@"%@",cidStr]         ;
            commaCidListStr  = [commaCidListStr stringByAppendingString:strCid] ;
        }
        else
        {
            NSString *cidStrComma = [NSString stringWithFormat:@"%@,",cidStr] ;
            commaCidListStr = [commaCidListStr stringByAppendingString:cidStrComma] ;
        }
        
        index ++ ;
    }
    NSLog(@"commaCidListStr : %@",commaCidListStr) ;
    
    [request setPostValue:G_TOKEN                           forKey:KEY_TOKEN]         ;
    [request setPostValue:addressID                         forKey:@"addressId"]      ;
    [request setPostValue:commaCidListStr                   forKey:@"cartIds"]        ;
    [request setPostValue:payType                           forKey:@"payType"]        ;
    
    //20150103 ADD
    BOOL bID    = ![couponID isEqualToString:@""] ;
    BOOL bCode  = ![coupsonCode isEqualToString:@""] ;
    
    if (bID && !bCode)
    {
        [request setPostValue:couponID                      forKey:@"couponId"]       ;
    }
    
    if (!bID && bCode)
    {
        [request setPostValue:coupsonCode                   forKey:@"couponCode"]     ;
    }
    
    if (points)
    {
        [request setPostValue:[NSNumber numberWithInt:points]   forKey:@"credit"]         ;
    }
    //20150103 END
    
    [request setPostValue:[NSNumber numberWithInt:1]        forKey:@"clearCart"]      ;  //清空购物车
    
    [request startSynchronous];

    NSError *error = [request error];
    NSString *response;
    if (!error)
    {
        response = [request responseString];
        NSLog(@"add Order response:%@",response);
    }
    else
    {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init]              ;
    NSDictionary *dictionary = [parser objectWithString:response]   ;
    
    return dictionary ;
}

//订单详情
+ (NSDictionary *)getOrderDetailWithOrderID:(NSString *)orderID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ORDER_DETAIL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]]      ;
    request.timeOutSeconds = TIMEOUT    ;
    
    [request setPostValue:G_TOKEN         forKey:KEY_TOKEN]         ;
    [request setPostValue:orderID         forKey:@"orders_code"]    ;
    
    [request startSynchronous]          ;
    
    NSError *error = [request error]    ;
    NSString *response;
    if (!error)
    {
        response = [request responseString] ;
        NSLog(@"getOrderDetail response:%@",response) ;
    }
    else
    {
        NSLog(@"error:%@",error) ;
    }
    SBJsonParser *parser = [[SBJsonParser alloc] init]              ;
    NSDictionary *dictionary = [parser objectWithString:response]   ;
    
    return dictionary ;
}


/***订单列表
 * page         页码
 * number       每页数量
 * status       状态条件, 0表示全部
 */
+ (NSDictionary *)getOrderListsWithPage:(int)page
                          AndWithNumber:(int)number
                          AndWithStatus:(int)status
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ORDER_LIST];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]]      ;
    request.timeOutSeconds = TIMEOUT           ;
    
    [request setPostValue:G_TOKEN                                   forKey:KEY_TOKEN] ;
    [request setPostValue:[NSString stringWithFormat:@"%d",page]    forKey:@"page"]         ;
    [request setPostValue:[NSString stringWithFormat:@"%d",number]  forKey:@"number"]       ;
    [request setPostValue:[NSString stringWithFormat:@"%d",status]  forKey:@"status"]       ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error)
    {
        response = [request responseString];
        NSLog(@"getOrderLists response:%@",response);
    }
    else
    {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init]              ;
    NSDictionary *dictionary = [parser objectWithString:response]   ;
    
    return dictionary ;
}


/*  使用积分
 *  @param : credit      积分
 *  @return : price      减免金额
 */
+ (ResultPasel *)usePointInOrderConfrimWithCredit:(int)credit
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ORDER_CREDIT];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN forKey:KEY_TOKEN] ;
    [request setPostValue:[NSNumber numberWithInt:credit] forKey:@"credit"] ;
    
    [request startSynchronous];
    
    NSError     *error = [request error];
    NSString    *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"usePointInOrderConfrim response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dic = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}

/*  使用优惠码
 *  @param  :  coupsonCode  优惠码
 *             cids         购物车ids , 逗号分隔 , 字符串
 *  @return :  price        减免金额
 */
+ (ResultPasel *)useCoupsonCodeInOrderConfrimWithCoupsonCode:(NSString *)coupsonCode AndWithCidsList:(NSArray *)cidlist
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ORDER_COUPCODE];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN forKey:KEY_TOKEN] ;
    
    //  couson code
    [request setPostValue:coupsonCode                           forKey:@"couponCode"] ;
    
    //  cartID
    NSString *commaCidListStr = @""        ;
    int index = 0   ;
    for (NSNumber *cidStr in cidlist)
    {
        if (index == cidlist.count - 1)
        {
            NSString *strCid = [NSString stringWithFormat:@"%@",cidStr]         ;
            commaCidListStr  = [commaCidListStr stringByAppendingString:strCid] ;
        }
        else
        {
            NSString *cidStrComma = [NSString stringWithFormat:@"%@,",cidStr] ;
            commaCidListStr = [commaCidListStr stringByAppendingString:cidStrComma] ;
        }
        
        index ++ ;
    }
    NSLog(@"commaCidListStr : %@",commaCidListStr) ;
    
    [request setPostValue:commaCidListStr forKey:@"cids"] ;
    
    [request startSynchronous];
    
    NSError     *error = [request error];
    NSString    *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"useCoupsonCodeInOrderConfrim response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dic = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}

//取消订单
+ (ResultPasel *)orderCancelWithOrderIDStr:(NSString *)orderIDStr
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_ORDER_CANCEL] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN       forKey:KEY_TOKEN] ;
    [request setPostValue:orderIDStr    forKey:@"orders_code"] ;

    [request startSynchronous];
    
    NSError     *error = [request error];
    NSString    *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"orderCancel response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dic = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}





#pragma mark - 包裹
//包裹列表
+ (ResultPasel *)getBagListWithParcelID:(int)parcelID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_BAG_LIST] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN forKey:KEY_TOKEN] ;
    [request setPostValue:[NSNumber numberWithInt:parcelID] forKey:@"parcel_id"] ;
   
    [request startSynchronous];
    NSError     *error = [request error];
    NSString    *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"getBagList response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dic = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);

    return nil ;
}

//包裹详情
+ (ResultPasel *)getBagDetailWithParcelID:(int)parcelID AndWithBagID:(int)bagID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_BAG_DETAIL] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN                           forKey:KEY_TOKEN] ;
    [request setPostValue:[NSNumber numberWithInt:parcelID] forKey:@"parcel_id"] ;
    [request setPostValue:[NSNumber numberWithInt:bagID]    forKey:@"bag_id"] ;
    
    [request startSynchronous];
    NSError     *error = [request error];
    NSString    *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"getBagDetail response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dic = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}

//包裹签收
+ (ResultPasel *)receiveBagWithBagID:(int)bagID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_BAG_SIGN] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    [request setPostValue:G_TOKEN                        forKey:KEY_TOKEN] ;
    [request setPostValue:[NSNumber numberWithInt:bagID] forKey:@"bag_id"] ;
    
    [request startSynchronous];
    
    NSError     *error = [request error];
    NSString    *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"receiveBag response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        NSDictionary *dic = [parser objectWithString:response] ;
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}



#pragma mark -- settings
//用户反馈
+ (int)sendUserFeedBackWithEmail:(NSString *)email
            AndWithTitle:(NSString *)title
          AndWithContent:(NSString *)content
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_USERFEEDBACK];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.timeOutSeconds = TIMEOUT ;
    
    BOOL b = ! ( (G_TOKEN == nil ) || [G_TOKEN isEqualToString:@""] ) ;
    if(b) [request setPostValue:G_TOKEN forKey:KEY_TOKEN]               ;
    
    [request setPostValue:title         forKey:@"title"]    ;
    [request setPostValue:content       forKey:@"content"]  ;
    [request setPostValue:email         forKey:@"email"]    ;
   
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response ;
    if (!error)
    {
        response = [request responseString];
        NSLog(@"sendUserFeedBackWithEmail response:%@",response);
    }
    else
    {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:response] ;
    int code = [[dictionary objectForKey:@"code"] intValue] ;
    
    return code ;
}


#pragma mark - 快递
//快递查询
+ (NSDictionary *)getExpressInfoWithExpressID:(int)expressID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_EXPRESS_QUERY];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;

    [request setPostValue:[NSNumber numberWithInt:expressID] forKey:@"id"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];

    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"getExpressInfoWithExpressID response:%@",response);
    }
    else
    {
        NSLog(@"error:%@",error);
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    
    NSDictionary *dictionary = [parser objectWithString:response] ;

    return dictionary ;
}


+ (NSDictionary *)getChinaExpressInfoWithKuaidiNumber:(NSString *)kuaidiNum AndWithKuaidiName:(NSString *)kuaidiName
{
    NSString *key = @"1c939d0b923e42e5802a6824ede5b7c1" ;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.aikuaidi.cn/rest/?key=%@&order=%@&id=%@&ord=desc&show=json",key,kuaidiNum,kuaidiName] ;

    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"getChinaExpressInfo : %@",jsonStr) ;
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dictionary = [parser objectWithString:jsonStr] ;
    
    return dictionary ;
}



#pragma mark - 喜欢
//喜欢列表
+ (ResultPasel *)getLikeListWithPage:(int)page AndWithSize:(int)size
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_LIKE_LIST];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:[NSNumber numberWithInt:page] forKey:@"page"] ;
    [request setPostValue:[NSNumber numberWithInt:size] forKey:@"size"] ;
    [request setPostValue:G_TOKEN                       forKey:KEY_TOKEN] ;

    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"getLikeListWithPage response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
  
    NSLog(@"error:%@",error);

    return nil ;
}

//喜欢 创建
+ (ResultPasel *)likeCreateWithProductCode:(NSString *)proCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_LIKE_CREAT];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:proCode                       forKey:@"product_code"] ;

    [request setPostValue:G_TOKEN                       forKey:KEY_TOKEN]       ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"likeCreateWithProductCode response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}

//喜欢 删除
+ (ResultPasel *)likeRemoveWithProductCode:(NSString *)proCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_LIKE_DEL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:proCode                       forKey:@"product_code"] ;
    
    [request setPostValue:G_TOKEN                       forKey:KEY_TOKEN]       ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        NSLog(@"likeRemoveWithProductCode response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return  result;
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;
}

//喜欢 查询
+ (BOOL)likeCheckedAlreadyWithProductCode:(NSString *)proCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_LIKE_CHECK];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:proCode                       forKey:@"product_code"] ;
    
    [request setPostValue:G_TOKEN                       forKey:KEY_TOKEN]       ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString] ;
        
        NSLog(@"likeCheckedAlreadyWithProductCode response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        int code = [[dic objectForKey:@"code"] intValue] ;
        
        if (code == 200)
        {
            return YES ;
        }
        return NO ;
    }
    
    NSLog(@"error:%@",error);
    
    return NO ;
}


#pragma mark - 评价
//评价 创建
/*
 *******************************************************
 ** 参数名                 类型   必需	说明              **
 ** token                String	Y	用户的Token
 ** score                Int     Y	评分
 ** image                String	Y	晒图，多个图片用“,”分割
 ** comment              String	Y	评论内容
 ** orders_product_id	Int     Y	订单商品id
 ** product_code         String	Y	商品编号
 *******************************************************
***/
+ (ResultPasel *)commentCreateWithScore:(int)score AndWithImgList:(NSArray *)imgList AndWithComment:(NSString *)commentStr AndWithOrdersProductID:(int)orderProID AndWithProductCode:(NSString *)productCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_COMMENT_CREATE] ;
   
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:G_TOKEN                        forKey:KEY_TOKEN] ;
    
    [request setPostValue:[NSNumber numberWithInt:score] forKey:@"score"] ;
    
    [request setPostValue:imgList                        forKey:@"image"];
    
    [request setPostValue:commentStr                     forKey:@"comment"];
    NSNumber *opId = [NSNumber numberWithInt:orderProID] ;
    [request setPostValue:opId                           forKey:@"orders_product_id"] ;
    
    [request setPostValue:productCode                    forKey:@"product_code"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"commentCreate response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;   //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}


//评价-列表-全部【包含有评价和没有评价】
/*
 *******************************************************
 *参数名	类型          必需	说明
 *token	String      Y       用户的Token
 *page	Int         N       页码，从第一页开始计算
 *size	Int         N       每页显示多少条
 *******************************************************
 */
+ (ResultPasel *)getMyAllCommentListWithPage:(int)page AndWithSize:(int)size
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_COMMENT_ALL_LIST] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:G_TOKEN                        forKey:KEY_TOKEN] ;
    
    [request setPostValue:[NSNumber numberWithInt:page]  forKey:@"page"] ;
    
    [request setPostValue:[NSNumber numberWithInt:size]  forKey:@"size"] ;

    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"getMyAllComment response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}


//评价-列表-已经评价
/*
 ************************************
 *参数名	类型        必需     说明
 *token	String      Y       用户的Token
 *page	Int         N       页码，从第一页开始计算
 *size	Int         N       每页显示多少条
 ************************************
 */
+ (ResultPasel *)getMyAlreadyCommentWithPage:(int)page AndWithSize:(int)size
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_COMMENT_ALREADY_LIST] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:G_TOKEN                        forKey:KEY_TOKEN] ;
    
    [request setPostValue:[NSNumber numberWithInt:page]  forKey:@"page"] ;
    
    [request setPostValue:[NSNumber numberWithInt:size]  forKey:@"size"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"getMyAlreadyComment response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}



//评价-单个评价【包含带分页的回复信息】
/*
 ************************************
 *参数名	类型          必需	说明
 *token	String      Y       用户的Token
 *id	Int         Y       评论id
 *page	Int         N       页码，从第一页开始计算
 *size	Int         N       每页显示多少条
 ************************************
 */
+ (ResultPasel *)getSingleCommentWithCommentID:(int)commentID AndWithPage:(int)page AndWithSize:(int)size
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_COMMENT_SINGLE] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:G_TOKEN                        forKey:KEY_TOKEN] ;
    
    [request setPostValue:[NSNumber numberWithInt:commentID] forKey:@"id"] ;
    
    [request setPostValue:[NSNumber numberWithInt:page]  forKey:@"page"] ;
    
    [request setPostValue:[NSNumber numberWithInt:size]  forKey:@"size"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"getSingleComment response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}



//评价-回复评价
/*
 ************************************
 *参数名           类型      必需	说明
 *token         String      Y	用户的Token
 *content       String      Y	回复内容
 *comment_id	Int         Y	回复的评论id
 *reply_id      Int         Y	回复的回复id【子回复】
 ************************************
 */
+ (ResultPasel *)answerCommentWithContent:(NSString *)content AndWithCommentID:(int)commentID AndWithReplyID:(int)replyID
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_COMMENT_ANSWER] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:G_TOKEN                        forKey:KEY_TOKEN] ;
    
    [request setPostValue:content                        forKey:@"content"] ;

    [request setPostValue:[NSNumber numberWithInt:commentID] forKey:@"comment_id"] ;
    
    [request setPostValue:[NSNumber numberWithInt:replyID]  forKey:@"reply_id"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"answerComment response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}



#pragma mark - 收银台
//查询支付流水
/*
 *参数名         类型	必需		说明
 *token         String	Y		用户的Token
 *orders_code	String	Y		订单编号
 **/
+ (ResultPasel *)cashierGetPaymentWithOrderCode:(NSString *)orderCode
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_GET_PAYMENT] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;
    
    [request setPostValue:G_TOKEN                        forKey:KEY_TOKEN] ;
    
    [request setPostValue:orderCode                      forKey:@"orders_code"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"cashierGetPayment response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}


#pragma mark - 帮助中心
//帮助中心
+ (ResultPasel *)getHelpCenterWithType:(NSString *)type
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[DigitInformation shareInstance].g_servericeIP,URL_HELP_CENTER] ;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    request.timeOutSeconds = TIMEOUT ;

    [request setPostValue:type forKey:@"type"] ;
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSString *response ;
    
    if (!error)
    {
        response = [request responseString];
        
        NSLog(@"getHelpCenter response:%@",response);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        
        NSDictionary *dic = [parser objectWithString:response] ;
        
        ResultPasel *result = [[ResultPasel alloc] initWithDictionary:dic] ;
        
        return result  ;         //success
    }
    
    NSLog(@"error:%@",error);
    
    return nil ;                 //failure
}


@end
