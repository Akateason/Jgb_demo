//
//  Coupon.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property (nonatomic)       BOOL            isChoosen ;             //是否已选择 ( couponlist中处理, )


@property (nonatomic)       int             coupon_id ;             //优惠券id，
@property (nonatomic,copy)  NSString        *name ;                 //优惠券名字,
@property (nonatomic)       int             coupon_type ;           //1,百分比，2,实际扣除，3,满X扣除Y,
@property (nonatomic)       float           coupon_money ;          //优惠的金额, Y
@property (nonatomic)       float           coupon_money_limit ;    //类型3优惠券使用的条件, X
@property (nonatomic,copy)  NSString        *begintime  ;           //开始时间
@property (nonatomic,copy)  NSString        *endtime    ;           //结束时间

@property (nonatomic,copy)  NSString        *couponStr ;            //优惠券上面显示的类型


- (instancetype)initWithDic:(NSDictionary *)dic ;

- (instancetype)initFromCoupsonListWithDic:(NSDictionary *)dic ;


@end
