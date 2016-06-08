//
//  AppDelegate.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-1.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentWeiboConnection/TencentWeiboConnection.h>
#import "WeiboSDK.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import <RennSDK/RennSDK.h>
#import <RenRenConnection/RenRenConnection.h>
#import <ShareSDK/ShareSDK.h>
#import "PlatformInfomation.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *wbtoken;

@end

