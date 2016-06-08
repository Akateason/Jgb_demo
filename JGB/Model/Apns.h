//
//  Apns.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-11.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>




typedef enum {
    normalMode = 0 ,
    productMode  ,      //商品详情
    activityMode ,      //活动页

    orderMode,          //订单详情
    catagoryMode ,      //类目     (商品列表)
    searchMode          //搜索关键字(商品列表)
} ModeForAPNS ;


@interface Apns : NSObject

@property (nonatomic) ModeForAPNS apnsMode   ;
@property (nonatomic,copy) NSString *value      ;

- (instancetype)initWithDic:(NSDictionary *)dic ;

+ (Apns *)getApnsWithUserInfoDiction:(NSDictionary *)diction ;

+ (void)goToDestinationFromController:(UIViewController *)controller WithApns:(Apns *)apns ;

@end
