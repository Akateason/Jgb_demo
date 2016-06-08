//
//  DigitInformation.h
//  ParkingSys
//
//  Created by mini1 on 14-4-2.
//  Copyright (c) 2014年 mini1. All rights reserved.
//

#define FLOAT_HUD_MINSHOW       0.0f


#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "PopMenuView.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "Select_val.h"
#import "WordsHeader.h"
#import "CheckPrice.h"
#import "Configure.h"
#import "WareHouse.h"
#import "Apns.h"

#define DB                          [DigitInformation shareInstance].db

#define G_POPMENU                   [DigitInformation shareInstance].g_popMenu
#define G_TOKEN                     [DigitInformation shareInstance].g_TOKEN
#define G_USER_CURRENT              [DigitInformation shareInstance].g_currentUser
#define G_SELECT_VAL                [DigitInformation shareInstance].g_selectVal

#define G_SHOP_CAR_COUNT            [DigitInformation shareInstance].g_shopCarCount
#define G_SHOP_CAR_NUM              [DigitInformation shareInstance].g_shopCarNum

#define G_IMG_MODE                  [DigitInformation shareInstance].g_imgMode
#define G_ONLINE_MODE               [DigitInformation shareInstance].g_onlineMode


#define G_EXCHANGE_RATE                 [DigitInformation shareInstance].g_configure.EXCHANGE_RATE
#define G_FREIGHT_EXCHANGE_RATE         [DigitInformation shareInstance].g_configure.FREIGHT_EXCHANGE_RATE
#define G_ADDON                         [DigitInformation shareInstance].g_configure.ADDON
#define G_freight                       [DigitInformation shareInstance].g_configure.FREIGHT
#define G_AUTHORIZATION_TIME            [DigitInformation shareInstance].g_configure.AUTHORIZATION_TIME
#define G_ORDERSTATUS_DIC               [DigitInformation shareInstance].g_configure.ORDERS_STATUS
#define G_NOTE_CANT_BUY                 [DigitInformation shareInstance].g_configure.PRODUCT_STATUS_INFO
#define G_BAG_STATUS                    [DigitInformation shareInstance].g_configure.BAG_STATUS
#define G_TRANSPORT_STATUS              [DigitInformation shareInstance].g_configure.TRANSPORT_STATUS
#define G_EXPRESSDETAIL_DIC             [DigitInformation shareInstance].g_configure.EXPRESSAGE_DETAILS


#define G_ORDERID_STR               [DigitInformation shareInstance].g_orderIdStr

#define G_BOOL_OPEN_APPSTORE        [DigitInformation shareInstance].g_openAPPStore

#define G_WEIBO_LOGIN_BOOL          [DigitInformation shareInstance].g_weiboLogin

#define G_QQ_LOGIN_BOOL             [DigitInformation shareInstance].g_qqLogin

#define G_WX_LOGIN_BOOL             [DigitInformation shareInstance].g_wxLogin


@protocol DigitInfomationDelegate <NSObject>

- (void)setMyTabBarItemChange ;

@end

@interface DigitInformation : NSObject

+ (DigitInformation *)shareInstance;

@property (nonatomic,retain) id <DigitInfomationDelegate> delegate  ;

//db
@property (atomic,retain)FMDatabase             *db;
//pop menu
@property (nonatomic,retain)PopMenuView         *g_popMenu ;
//ip
@property (nonatomic,copy)NSString              *g_servericeIP ;
//TOKEN
@property (nonatomic,copy)NSString              *g_TOKEN ;
//current User
@property (nonatomic,retain)User                *g_currentUser ;
// Select Value global
@property (nonatomic,retain)Select_val          *g_selectVal ;
// shop car  nums
@property (nonatomic)int                        g_shopCarCount ;   //种类数量
// shop car good
@property (nonatomic)int                        g_shopCarNum ;     //商品数量

#pragma mark --
// img mode     //0 - 智能, 1 - wifi, 2 - 3g
@property (nonatomic)int                        g_imgMode   ;
// online mode  //0-notReachable, 1-wifi, 2-3g
@property (nonatomic)int                        g_onlineMode ;



#pragma mark --
@property (nonatomic,retain)    Configure       *g_configure ;


#pragma mark --
@property (nonatomic,retain)    NSArray         *g_wareHouseList ; //仓库

#pragma mark --
@property (nonatomic,retain)    NSArray         *g_hotSearchList ; //热词

#pragma mark --
@property (nonatomic,retain)    NSArray         *g_payTypeList ; //支付方式

#pragma mark --
// pay order code Str
@property (nonatomic,copy)      NSString        *g_orderIdStr ;

#pragma mark --
@property (nonatomic,retain)    NSArray         *g_topTagslist ;    //首页标签.

#pragma mark --
// 审核开关 , 服务端控制开关
@property (nonatomic)           BOOL            g_openAPPStore ;
// 微博登陆 default is false ,
@property (nonatomic)           BOOL            g_weiboLogin ;
// qq登陆  default is false ,
@property (nonatomic)           BOOL            g_qqLogin   ;
// 微信登陆  default is false ,
@property (nonatomic)           BOOL            g_wxLogin   ;


#pragma mark --
//全局核价 , 用来
@property (nonatomic,retain)    NSArray         *g_checkPriceSellerList ;

#pragma mark --
//获取当前推送结果
@property (nonatomic,retain)    Apns            *apns ;

//hud
@property (nonatomic,retain)    MBProgressHUD   *HUD ;


#pragma mark --
//show normal hud
+ (void)showWordHudWithTitle:(NSString *)title ;

//show hud animated block
+ (void)showHudWhileExecutingBlock:(dispatch_block_t)block AndComplete:(dispatch_block_t)complete AndWithMinSec:(float)sec ;


#pragma mark --
/*  RETURN INT
 ** 0  -  not reachable
 ** 1  -  wifi
 ** 2  -  3g
 */
+ (int) isConnectionAvailable ;


@end
