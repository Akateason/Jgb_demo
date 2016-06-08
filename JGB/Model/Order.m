//
//  Order.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Order.h"

@implementation Order

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        //1.order info
        _orderInfo = [[OrderInfo alloc] initWithDictionary:[dictionary objectForKey:@"orderInfo"]] ;
        
        //2.products list
        BOOL b = [[dictionary objectForKey:@"product"] isKindOfClass:[NSNull class]] || ![dictionary objectForKey:@"product"] ;
        if (!b) {
            NSMutableArray *proResultList = [NSMutableArray array] ;
            NSArray *tempProductList = [dictionary objectForKey:@"product"] ;
            for (NSDictionary *proDic in tempProductList)
            {
                OrderProduct *orderPro = [[OrderProduct alloc] initWithDic:proDic] ;
                [proResultList addObject:orderPro] ;
            }
            _product = proResultList ;
        }
        
        
        //3.bag
        if (![[dictionary objectForKey:@"bag"] isKindOfClass:[NSNull class]])
        {
            NSMutableArray *bagResultList = [NSMutableArray array] ;
            NSArray *tempBagList = [dictionary objectForKey:@"bag"] ;
            for (NSDictionary *bagDic in tempBagList)
            {
                Bag *bagTemp = [[Bag alloc] initWithDic:bagDic] ;
                [bagResultList addObject:bagTemp] ;
            }
            _bagArray = bagResultList ;
        }
        
        //4.address
        _address = [[ReceiveAddress alloc] initWithDic:[dictionary objectForKey:@"address"]] ;
        
        //5.parcels
        NSMutableArray *parcelResultList = [NSMutableArray array] ;
        NSArray *tempParcelList = [dictionary objectForKey:@"parcels"] ;
        for (NSDictionary *parcelDic in tempParcelList)
        {
            Parcel *parcelTemp = [[Parcel alloc] initWithDictionary:parcelDic] ;
            [parcelResultList addObject:parcelTemp] ;
        }
        _parcelArray = parcelResultList ;
    }
    
    return self;
}


@end


/*
- (instancetype)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        
        NSDictionary *orderDiction = [dictionary objectForKey:@"orders"]    ;
        
        _orderId  = [[orderDiction objectForKey:@"orderId"] intValue]       ;
        _date     = [[orderDiction objectForKey:@"date"] longLongValue]     ;
        _status   = [[orderDiction objectForKey:@"status"] intValue]        ;
        _total    = [[orderDiction objectForKey:@"total"] floatValue]       ;
        _code     = [orderDiction  objectForKey:@"code"]                    ;
        _payType  = [orderDiction  objectForKey:@"payType"]                 ;
        
        if ([[orderDiction objectForKey:@"rate"] isKindOfClass:[NSNull class]]) {
            _rate       = 0 ;
        }else {
            _rate       = [[orderDiction objectForKey:@"rate"] intValue] ;
        }
        
        //      product dic
        NSMutableArray  *multiProList   = [NSMutableArray array] ;
        
        NSDictionary    *tempProDic     = [dictionary objectForKey:@"product"] ;
        NSArray         *allkeyTempPro  = [tempProDic allKeys] ;
        NSMutableDictionary *multiDic   = [NSMutableDictionary dictionary] ;
        for (NSString  *key in allkeyTempPro)
        {
            NSArray *plist = [tempProDic objectForKey:key] ;
            NSMutableArray  *proList        = [NSMutableArray array] ;
            
            for (NSDictionary *dicP in plist) {
                OrderProduct *product = [[OrderProduct alloc] initWithDic:dicP] ;
                [proList addObject:product] ;
                
                [multiProList addObject:product] ;
                [multiDic setObject:proList forKey:key] ;
            }
        }
        _productDiction = multiDic ;
        
        
        //      product list
        _productList = multiProList ;
        
        
        //      addr
        _address = [[ReceiveAddress alloc] initWithDic:[dictionary objectForKey:@"address"]] ;
        
        // ----------------------
        _type   = [[orderDiction objectForKey:@"type"] intValue] ;
        
        
        //
        
        _kuaidi = [[orderDiction objectForKey:@"kuaidi"] intValue] ;
        
        //
        _bag_status = [[orderDiction objectForKey:@"bag_status"] intValue] ;
        //
        if (! _bag_status)
        {
            _bagArray = @[] ;
        }
        else
        {
            NSMutableArray *baglist = [NSMutableArray array] ;
            NSArray *bagInfoArr = [orderDiction objectForKey:@"bag"] ;
            for (NSDictionary *bagDic in bagInfoArr)
            {
                Bag *bag    = [[Bag alloc] initWithDic:bagDic] ;
                [baglist addObject:bag] ;
            }
            _bagArray = baglist ;
        }
        
        
        //
        _residual_status = [[orderDiction objectForKey:@"residual_status"] intValue] ;
        //
        if (! _residual_status)
        {
            _residualArray = @[] ;
        }
        else
        {
            NSMutableArray *residualList = [NSMutableArray array] ;
            NSArray *residualInfoArr = [orderDiction objectForKey:@"residual"] ;
            for (NSDictionary *residualDic in residualInfoArr)
            {
                OrderProduct *orderPro = [[OrderProduct alloc] initWithDic:residualDic] ;
                [residualList addObject:orderPro] ;
            }
            _residualArray = residualList;
        }
        
        
        
    }
    return self;
}
*/
