//
//  Coupon.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Coupon.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@implementation Coupon

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.isChoosen = NO ;
        
        self.coupon_id = [[dic objectForKey:@"coupon_id"] intValue] ;
        self.name      = [dic objectForKey:@"name"] ;
        self.coupon_type = [[dic objectForKey:@"coupon_type"] intValue] ;
        self.coupon_money = [[dic objectForKey:@"coupon_money"] floatValue] ;
        self.coupon_money_limit = [[dic objectForKey:@"coupon_money_limit"] floatValue] ;
      
        long long beginT = [[dic objectForKey:@"begintime"] longLongValue] ;
        long long endT   = [[dic objectForKey:@"endtime"] longLongValue]   ;
        
        self.begintime  = [MyTick getDateWithTick:beginT AndWithFormart:TIME_STR_FORMAT_5] ; //[[beginT componentsSeparatedByString:@" "]    objectAtIndex:0] ;
        self.endtime    = [MyTick getDateWithTick:endT AndWithFormart:TIME_STR_FORMAT_5] ;//[[endT componentsSeparatedByString:@" "]      objectAtIndex:0] ;

    }
    
    return self;
}


- (instancetype)initFromCoupsonListWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.isChoosen = NO ;

        self.coupon_id = [[dic objectForKey:@"id"] intValue] ;
        self.name      = [dic objectForKey:@"name"] ;
        self.coupon_type = [[dic objectForKey:@"coupon_type"] intValue] ;
        self.coupon_money = [[dic objectForKey:@"coupon_money"] floatValue] ;
        self.coupon_money_limit = [[dic objectForKey:@"coupon_money_limit"] floatValue] ;
        
        long long beginT = [[dic objectForKey:@"begintime"] longLongValue] ;
        long long endT   = [[dic objectForKey:@"endtime"] longLongValue]   ;
        
        self.begintime  = [MyTick getDateWithTick:beginT AndWithFormart:TIME_STR_FORMAT_5] ; //[[beginT componentsSeparatedByString:@" "]    objectAtIndex:0] ;
        self.endtime    = [MyTick getDateWithTick:endT AndWithFormart:TIME_STR_FORMAT_5] ;//[[endT componentsSeparatedByString:@" "]      objectAtIndex:0] ;
    }
    
    return self;
}


@end
