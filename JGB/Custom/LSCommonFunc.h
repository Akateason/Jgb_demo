//
//  LSCommonFunc.h
//  DigitMart
//
//  Created by  on 12/12/18.
//  Copyright (c) 2012年 Legensity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PopMenuView.h"

#import "MemberCenterController.h"//会员中心
#import "OrderViewController.h"   //我的订单
#import "ShopCarViewController.h" //购物车
#import "IndexViewController.h"   //返回首页
#import "LoginFirstController.h"  //登录
#import "NavSearchController.h"

@interface LSCommonFunc : NSObject

#pragma mark -- save and login 
+ (void)saveAndLoginWithResultDataDiction:(NSDictionary *)dataDic
                    AndWithViewController:(UIViewController *)contoller
                          AndWithFailInfo:(NSString *)failInfo  ;


#pragma mark -- login H5
+ (NSString *)getUrlWhenLoginH5WithTick:(long long)tick AndWithOrgUrl:(NSString *)orgUrl ;


#pragma mark -- isFirstLaunch
//get是否第一次启动app
+ (BOOL)isNotFirstLaunch ;

//set第一次启动app
+ (void)setNotFirstLaunchWithBool:(BOOL)bSwitch ;

#pragma mark -- isFirstGoInProductDetail
+ (BOOL)isNotFirstGoInProductDetail ;
+ (void)setNotFirstGoInProductDetail:(BOOL)bFirst ;

#pragma mark - NSCalendar
//拿 当前 年月日
+ (int)getYear;

+ (int)getMonth;

+ (int)getDay;


#pragma mark - CLLocation  get current location
//拿 当前 经纬度 位置
+ (CLLocationCoordinate2D)getLocation ;


#pragma mark - dealNavigationPushOrPopWithViewControllers
/*
 *vc  : 表示当前是哪一个vc
 *tag : 表示想push到哪一个ctrl
 */
+ (void)dealNavigationPushOrPopWithViewControllers:(UIViewController *)vc
                                        AndWithTag:(int)tag;


#pragma mark -- 男女切换  0无, 1 男 , 2 女
//男女切换
+ (NSString *)boyGirlNum2Str:(int)num ;
+ (int)boyGirlStr2Num:(NSString *)str ;



#pragma mark -- 数组切换字符串
//数组切换字符串
+ (NSString *)getCommaStringWithArray:(NSArray *)array ;

#pragma mark -- modal搜索页
+ (void)popModalSearchViewWithCurrentController:(UIViewController *)controller ;

#pragma mark -- 去掉小数点后面的0
+ (NSString *)changeFloat:(NSString *)stringFloat ;


#pragma mark -- 关闭应用
+ (void)shutDownAppWithCtrller:(UIViewController *)ctrller ;


@end
