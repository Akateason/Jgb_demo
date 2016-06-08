//
//  CheckPrice.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Promotiom.h"
#import "DigitInformation.h"


#define MAX_OVERFLOW  30.0f
#define MIN_SENDFLEX  2.0f

// 核价

@interface CheckPrice : NSObject




@property (nonatomic)           int           sellerID      ;

@property (nonatomic,copy)      NSString      *pid          ;

@property (nonatomic)           BOOL          buyStatus     ;

@property (nonatomic)           long long     ts            ;
@property (nonatomic)           int           stock         ;
@property (nonatomic,retain)    NSArray       *type         ;
@property (nonatomic)           float         actual_price  ;

@property (nonatomic,retain)    Promotiom     *promotiom    ;       //优惠
@property (nonatomic,retain)    NSArray       *galleries    ;
@property (nonatomic,retain)    NSDictionary  *attr         ;       //当前的属性啊
@property (nonatomic,copy)      NSString      *title        ;       //title

@property (nonatomic,assign)    float         usaPrice      ;       //美元价格
@property (nonatomic,assign)    float         rmbPrice      ;       //人民币价格

//  new property
@property (nonatomic,copy)      NSArray       *noteinfo     ;       //不能买的情况




//  init
- (instancetype)initWithDic:(NSDictionary *)diction         ;






//  单词核价
+ (NSArray *)onceCheckWithList:(NSArray *)productList       ;

//  global 核价    多次
+ (NSArray *)funcCheckPriceWithList:(NSArray *)productList  ;

//  购物车 钩子是否能勾上
- (BOOL)checkBoxCanSelected ;        //WithAuthorizationtime:(int)authorizationTime ;

//  是否需要核价  yes 需要, no 不需要
+ (BOOL)isNeedCheckPriceWithShopCarList:(NSArray *)shopcartList ;

//  能否购买
+ (BOOL)isCanBuyWithShopCarList:(NSArray *)shopcartList ;

//获取 永远不能通过核价的 购物车 cid list
+ (NSMutableArray *)getNeverCheckeFinishedProductsCidList:(NSArray *)shopcartList ;



@end







