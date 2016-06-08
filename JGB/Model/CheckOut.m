//
//  CheckOut.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CheckOut.h"
#import "ServerRequest.h"

@implementation CheckOut

- (instancetype)initWithDiction:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        // 1
        if (![[dic objectForKey:@"address"] isKindOfClass:[NSNull class]])
        {
            NSMutableArray *addrList = [NSMutableArray array] ;
            NSArray *addressDicList = [dic objectForKey:@"address"] ;
            for (NSDictionary *addDic in addressDicList) {
                ReceiveAddress *address = [[ReceiveAddress alloc] initWithDic:addDic] ;
                [addrList addObject:address] ;
            }
            self.addressList = addrList ;
        }
        
        // 2
        self.payType = [dic objectForKey:@"pay_type"] ;
        
        // 3
        self.productDic = [dic objectForKey:@"product"] ;
        
        // 4
        self.totalDiction = [dic objectForKey:@"seller_total"] ;
        
        self.totalWarehouseDiction = [dic objectForKey:@"warehouse_total"] ;
        
        // 5
        if (![[dic objectForKey:@"coupons"] isKindOfClass:[NSNull class]])
        {
            NSMutableArray *coupList = [NSMutableArray array] ;
            NSArray *coupDicList = [dic objectForKey:@"coupons"] ;
            for (NSDictionary *coupDic in coupDicList)
            {
                Coupon *coup = [[Coupon alloc] initWithDic:coupDic] ;
                [coupList addObject:coup] ;
            }
            self.couponList = coupList ;
        }
       
        
//      20150109 ADD BY @TEA
        // 6
        if (![[dic objectForKey:@"credit"] isKindOfClass:[NSNull class]])
        {
            self.credit = [[dic objectForKey:@"credit"] intValue] ;
        }
        
        // 7
        self.bitcoin_favorable = [[dic objectForKey:@"bitcoin_favorable"] boolValue] ;
        
        // 8
        NSDictionary *tempPriceDic = [dic objectForKey:@"price"] ;
        self.priceDetail = [[PriceDetail alloc] initWithDictionary:tempPriceDic] ;
//      20150109 END BY @TEA
        
    }
    
    return self;
}











@end
