//
//  Bag.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderProduct.h"
#import "TransInfo.h"


@interface Bag : NSObject

// ADD BY @TEA 20150326 START
@property (nonatomic)           int         logistics_company_id ; // 美国快递公司id

@property (nonatomic,copy)      NSString    *logistics_number ; // 美国快递号码

@property (nonatomic,copy)      NSString    *logistics_company_name ; // 美国快递公司名称

@property (nonatomic)           int         express_company_id ; // 国内快递公司id

@property (nonatomic,copy)      NSString    *express_domestic_id ; // 国内快递号码

@property (nonatomic,copy)      NSString    *express_company_name ; // 国内快递公司名称
// ADD BY @TEA 20150326 START

@property (nonatomic)           int         parcelID ;  //子订单id

@property (nonatomic)           int         bagID ;     //包裹id

@property (nonatomic)           int         status ;    //包裹状态 0 没有签收 1 已经签收

@property (nonatomic,retain)    NSArray     *productArray ;     //商品list

@property (nonatomic,retain)    NSArray     *transInfoArray ;   //物流list

- (instancetype)initWithDic:(NSDictionary *)diction ;

/*
 *  包裹状态 0 没有签收 1 已经签收
 */
+ (NSString *)getBagStatusStrWithStatus:(int)status ;


@end


