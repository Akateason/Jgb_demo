//
//  LoginFirstController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
//#import <libDoubanAPIEngine/DOUService.h>
#import "MyTextField.h"


#define NOTIFICATION_WEIBO_CALLBACK     @"NOTIFICATION_WEIBO_CALLBACK"

#define NOTIFICATION_REFRESH_WEBVIEW    @"NOTIFICATION_REFRESH_WEBVIEW"


#define TAG_WEIXIN_LOG    7741
#define TAG_QQ_LOG        7742
#define TAG_WEIBO_LOG     7743

@interface LoginFirstController : RootCtrl<WBHttpRequestDelegate,TencentSessionDelegate>

@property (nonatomic) BOOL bFromWebCtrller ;

@end
