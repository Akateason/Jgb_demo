//
//  AppDelegate.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-1.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)          ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define NOTIFICATION_PAY_SUCCESS                            @"NOTIFICATION_PAY_SUCCESS"


#import "AppDelegate.h"
#import "UIImage+AddFunction.h"
#import "DigitInformation.h"

#import "SearchHistoryTB.h"
#import "BrandTB.h"
#import "CategoryTB.h"
#import "DistrictTB.h"
#import "SellerTB.h"
#import "WarehouseTB.h"

#import "ServerRequest.h"
#import "WeiboUser.h"
#import "WeiXinUser.h"
#import "WeiXinUserToken.h"

#import "User.h"
#import "SBJson.h"
#import "LoginFirstController.h"
#import "DistrictTB.h"
#import "MyFileManager.h"
#import "ShopCarGood.h"
#import <AlipaySDK/AlipaySDK.h>
#import "BindThirdLogin.h"
#import "TalkingData.h"
#import "Apns.h"


@implementation AppDelegate

@synthesize wbtoken ;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//  Override point for customization after application launch.
//    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"paths : %@",paths)  ;
    
    //从通知点进来 .
    if (launchOptions != nil)
    {
        Apns *apns = [Apns getApnsWithUserInfoDiction:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]] ;
        [DigitInformation shareInstance].apns = apns ;
    }
    
//  initial Global Objects
    [self initialGlobalObjects] ;
    
//  share sdk initial
    dispatch_queue_t queue = dispatch_queue_create("sharesdkQueue", NULL) ;
    dispatch_async(queue, ^{
        [self shareSDKinitial]  ;
    }) ;
    
//  TalkingData
    [TalkingData setExceptionReportEnabled:YES] ;
    [TalkingData sessionStarted:kAppID_TALKINGDATA withChannelId:@""] ;
    
//  initial DB
    [self initialDB]            ;
//  set My Style
    [self setMyStyle]           ;
//  check and auto login
    [self loginAndGonfigure]    ;
//  apns reg
    [self sendAPNS:application] ;
    
    return YES                  ;
}

- (void)sendAPNS:(UIApplication *)application
{
    BOOL bIos8 = IS_IOS_VERSION(8.0f) ;
    if (bIos8)
    {
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";  //按钮的标示
        action.title=@"确认";         //按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2" ;
        action2.title=@"取消" ;
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;    //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES ;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init] ;
        categorys.identifier = @"alert";        //这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)] ;
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]] ;
        
        [application registerUserNotificationSettings:notiSettings] ;
    }else{
        [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
}



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //注册远程通知
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //注册成功，将deviceToken保存到应用服务器数据库中
    // get device uid
    NSString *devTok = [NSString stringWithFormat:@"%@",deviceToken];
    NSRange bankRang = NSMakeRange(1, [devTok length] - 2);
    NSString *resultDevice = [devTok substringWithRange:bankRang];
    // version number str
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //  CFShow((__bridge CFTypeRef)(infoDic)) ;
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"] ;
    NSNumber *iosVersion = [NSNumber numberWithFloat:[[[UIDevice currentDevice] systemVersion] floatValue]] ;
    
    ResultPasel *deviceInstallResult = [ServerRequest letDeviceInstall:resultDevice AndAppVersion:currentVersion AndWithOS:iosVersion] ;
    
    if (deviceInstallResult.code == 200)
    {
        [self getTokenIfNeeded] ;
        
        if (G_TOKEN != nil)
        {
            [ServerRequest bindDeviceUID:resultDevice AndAccount:G_TOKEN] ;
        }
    }

    
}




- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//  处理推送消息
    NSLog(@"userinfo:%@",userInfo);
//  NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]) ;
//    Apns *apns = [Apns getApnsWithUserInfoDiction:userInfo] ;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Registfail%@",error) ;
}

- (void)getTokenIfNeeded
{
    if (!G_TOKEN)
    {
        NSString *homePath = NSHomeDirectory() ;
        NSString *path     = [homePath stringByAppendingPathComponent:PATH_TOKEN_SAVE] ;
        if ([MyFileManager is_file_exist:path])
        {
            NSString *token = [MyFileManager getObjUnarchivePath:path] ;
            G_TOKEN         = token ;
        }
    }
}


#pragma mark --
- (void)setConfigs
{
    dispatch_queue_t queue = dispatch_queue_create("queueConfig", NULL) ;
    
    dispatch_barrier_async(queue, ^{
        [[DigitInformation shareInstance] g_configure] ;
        [[DigitInformation shareInstance] g_wareHouseList] ;
    }) ;
    
}


- (void)loginAndGonfigure
{
    // user info
    [self getMemberInfo];
    
    //  Get Config
    [self setConfigs] ;
    
}


#pragma mark -- check And Auto Login
- (BOOL)getMemberInfo
{
    NSString *homePath = NSHomeDirectory() ;
    NSString *path     = [homePath stringByAppendingPathComponent:PATH_TOKEN_SAVE] ;
    
    if ([MyFileManager is_file_exist:path])
    {
        NSString *token  = [MyFileManager getObjUnarchivePath:path] ;
        G_TOKEN          = token ;
        if (!token) return NO ;
        
        // get user infomation
        [[DigitInformation shareInstance] g_currentUser] ;
    }
    else{
        return NO ;
    }
 
    return YES ;
}


//share SDK initial

- (void)shareSDKinitial
{
    [ShareSDK registerApp:kAppkey_SHARESDK] ;       //参数为ShareSDK官网中添加应用后得到的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:kAppKey_WEBO
                               appSecret:KSecret_WEBO
                             redirectUri:kRedirectURI] ;
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:kAppKey_WEBO
                                appSecret:KSecret_WEBO
                              redirectUri:kRedirectURI
                              weiboSDKCls:[WeiboSDK class]] ;
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:kAppKey_TencentWEBO
                                  appSecret:kSecret_TencentWEBO
                                redirectUri:kRedirectURI
                                   wbApiCls:[WeiboApi class]] ;
    
    //注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:kAppID_QQ                            //kAppKey_TencentWEBO
                           appSecret:kAppKey_QQ                           //kSecret_TencentWEBO
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]] ;
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:kAppID_QQ
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]] ;
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:kAppKey_WEIXIN
                           wechatCls:[WXApi class]] ;
    
    [ShareSDK connectWeChatWithAppId:kAppKey_WEIXIN   //微信APPID
                           appSecret:kSecret_WEIXIN   //微信APPSecret
                           wechatCls:[WXApi class]] ;
    
    //添加豆瓣应用  注册网址 http://developers.douban.com
    [ShareSDK connectDoubanWithAppKey:kAppKey_DOUBAN
                            appSecret:kSecret_DOUBAN
                          redirectUri:kRedirectURI] ;
}


//initial DB
- (void)initialDB
{
    dispatch_queue_t queue = dispatch_queue_create("initDB", NULL) ;
    dispatch_async(queue, ^{
        
        [[DistrictTB      shareInstance] creatTable]            ;
        [[SearchHistoryTB shareInstance] creatTable]            ;
        [[BrandTB         shareInstance] creatTable]            ;
        [[CategoryTB      shareInstance] creatTable]            ;
        [[SellerTB        shareInstance] creatTable]            ;
        [[WarehouseTB     shareInstance] creatTable]            ;
        
    }) ;
}

//set My Style
- (void)setMyStyle
{
    [[UIApplication sharedApplication] keyWindow].tintColor = COLOR_PINK ;

    //1 base white at window not black background
    UIView *baseView = [[UIView alloc] initWithFrame:APPFRAME] ;
    baseView.backgroundColor = [UIColor whiteColor] ;
    [_window addSubview:baseView] ;
    [_window sendSubviewToBack:baseView] ;
    
    //2 nav style
//    UIImage *img = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(320, 64)];
//    [[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]] ;
    [[UINavigationBar appearance] setTintColor:COLOR_PINK]    ;
    //  nav base line
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]] ;
    //  nav word style
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : COLOR_PINK}] ;
    //  status bar style
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;


    
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]    ;
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//    }
//    UIImage *img = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(320, 64)];
//    [[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setBarTintColor:COLOR_PINK];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//  Status bar white
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

//  title
//    UIColor *titleColor = [UIColor whiteColor];//[UIColor blackColor] ;
//  title shadow
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor  = COLOR_LIGHT_GRAY;//[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//    shadow.shadowOffset = CGSizeMake(2, 2);
//  dic
//    NSDictionary *titltDic = [NSDictionary dictionaryWithObjectsAndKeys:titleColor, NSForegroundColorAttributeName,shadow, NSShadowAttributeName,[UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName, nil];
//    [[UINavigationBar appearance] setTitleTextAttributes: titltDic];
//
//    [[UITabBar appearance] setTintColor:COLOR_UI_GREEN];
//    UIImage *imgtab = [UIImage imageWithColor:COLOR_BACK size:CGSizeMake(320, 48)];
//    [[UITabBar appearance] setBackgroundImage:imgtab];
//    create DB in back ground
//    [self performSelectorInBackground:@selector(createDB) withObject:nil];
    
}

//initial Global Objects
- (void)initialGlobalObjects
{
    G_TOKEN             = @""                                   ;
    G_SELECT_VAL        = [[Select_val alloc] init]             ;
    G_SHOP_CAR_COUNT    = 0                                     ;
    G_SHOP_CAR_NUM      = 0                                     ;
    G_ORDERID_STR       = @""                                   ;
    
    dispatch_queue_t queue = dispatch_queue_create("getImgModeQueue", NULL)                         ;
    dispatch_async(queue, ^{
        
        NSString *homePath      = NSHomeDirectory()                                                 ;
        NSString *imgModepath   = [homePath stringByAppendingPathComponent:PATH_SETTING_IMG_SIZE]   ;
        
        G_IMG_MODE = [MyFileManager is_file_exist:imgModepath] ? [(NSNumber *)[MyFileManager getObjUnarchivePath:imgModepath] intValue] : 0   ;
        NSLog(@"G_IMG_MODE : %d",G_IMG_MODE)        ;
        
        G_ONLINE_MODE = [DigitInformation isConnectionAvailable] ;
        NSLog(@"G_ONLINE_MODE : %d",G_ONLINE_MODE)  ;
        
    }) ;
    
}

#pragma mark --
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    // set badge = 0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0 ;
    
    
    if ( ([G_TOKEN isEqualToString:@""]) || (G_USER_CURRENT == nil) ) return ;
    // shop car num
    [ShopCarGood getShopCartCount] ;

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark --
#pragma mark - weibo call back
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        NSLog(@"didReceiveWeiboRequest") ;
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
// 获取微博个人信息
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        
        NSLog(@"认证结果message : %@",message) ;
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        
        NSLog(@"wbtoken : %@",wbtoken) ;
        
        NSDictionary *userInfoDic = [ServerRequest getWeiboUserInfoWithToken:wbtoken AndWithUid:[(WBAuthorizeResponse *)response userID]] ;
        WeiboUser *weiboUser      = [[WeiboUser alloc] initWithDic:userInfoDic] ;
        
        NSString *remindIn = [response.userInfo objectForKey:@"remind_in"]  ;
        NSString *expireIn = [response.userInfo objectForKey:@"expires_in"] ;
        
        //
        BindThirdLogin *bindLogin = [[BindThirdLogin alloc] initWithWeiboUser:weiboUser AndWithAccessToken:[(WBAuthorizeResponse *)response accessToken] AndWithRemindIn:remindIn AndWithExpireIn:expireIn] ;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WEIBO_CALLBACK object:bindLogin] ;
        
        G_WEIBO_LOGIN_BOOL = NO ;
    }
}

#pragma mark --
#pragma mark - WeiXin Delegate
/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq*)req
{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp
{

    if ([resp isKindOfClass:[SendAuthResp class]])
    {
        // get code
        NSString *code = ((SendAuthResp *)resp).code ;
        // get access token
        NSDictionary *userDic = [ServerRequest weixinApiGetAccessTokenWithCode:code] ;
        WeiXinUserToken *weixinTokenInfo = [[WeiXinUserToken alloc] initWithDic:userDic] ;
        // get user info of weixin
        NSDictionary *userTempDic = [ServerRequest weixinGetUserInfoWithAccessToken:weixinTokenInfo.accessToken AndWithOpenID:weixinTokenInfo.openID] ;
        WeiXinUser *wexinUser = [[WeiXinUser alloc] initWithDic:userTempDic] ;
        
        BindThirdLogin *bindLogin = [[BindThirdLogin alloc] initWithWeiXinInfo:weixinTokenInfo AndWithWeiXinUser:wexinUser] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WEIBO_CALLBACK object:bindLogin] ;
        
        G_WX_LOGIN_BOOL = NO ;
    }
    
}



#pragma mark --
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *strFromUrl = url.absoluteString ;
    NSLog(@"strFromUrl : %@", strFromUrl) ;
    
    if ([strFromUrl hasPrefix:@"wb"])
    {
        if (G_WEIBO_LOGIN_BOOL)
        {
            return [WeiboSDK handleOpenURL:url delegate:self] ;
        }
        else
        {
            return [ShareSDK handleOpenURL:url
                         sourceApplication:sourceApplication
                                annotation:annotation
                                wxDelegate:self] ;
        }
    }
    else if ([strFromUrl hasPrefix:@"tencent"])
    {
        if (G_QQ_LOGIN_BOOL)
        {
            return [TencentOAuth HandleOpenURL:url] ;
        }
        else
        {
            return [ShareSDK handleOpenURL:url
                         sourceApplication:sourceApplication
                                annotation:annotation
                                wxDelegate:self];

        }
    }
    else if ([strFromUrl hasPrefix:@"qq"])
    {
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    else if ([strFromUrl hasPrefix:@"alipayJGB"])
    {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"alipayJGB result = %@", resultDic);
             int resultStatus = 0 ;
             resultStatus = [[resultDic objectForKey:@"resultStatus"] intValue] ;
             if (resultStatus == 9000)
             {
                 //支付成功
                 NSLog(@"支付成功") ;
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAY_SUCCESS object:nil] ;
             }
             else
             {
                 //支付失败
                 NSLog(@"支付失败") ;
                 [DigitInformation showWordHudWithTitle:WD_PAY_FAILURE] ;
             }
         }];
    }
    else if ([strFromUrl hasPrefix:@"wx"])
    {
        if (G_WX_LOGIN_BOOL) {
            return [WXApi handleOpenURL:url delegate:self] ;
        } else {
            return [ShareSDK handleOpenURL:url
                         sourceApplication:sourceApplication
                                annotation:annotation
                                wxDelegate:self];
        }
    }
    
    return NO ;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *strFromUrl = url.absoluteString ;

    if ([strFromUrl hasPrefix:@"tencent"])
    {
        if (G_QQ_LOGIN_BOOL)
        {
            return [TencentOAuth HandleOpenURL:url];
        }
        else
        {
            return [ShareSDK handleOpenURL:url
                                wxDelegate:self];
        }
    }
    else if ([strFromUrl hasPrefix:@"qq"])
    {
        return [ShareSDK handleOpenURL:url
                            wxDelegate:self];
    }
    else if ([strFromUrl hasPrefix:@"wx"])
    {
        if (G_WX_LOGIN_BOOL) {
            return [WXApi handleOpenURL:url delegate:self] ;
        } else {
            return [ShareSDK handleOpenURL:url
                                wxDelegate:self];
        }
    }
    else if ([strFromUrl hasPrefix:@"wb"])
    {
        if (G_WEIBO_LOGIN_BOOL)
        {
            return [WeiboSDK handleOpenURL:url delegate:self] ;
        }
        else
        {
            return [ShareSDK handleOpenURL:url wxDelegate:self] ;
        }
    }
    
    return NO ;
}


@end

