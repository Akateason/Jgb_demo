//
//  Configure.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-5.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "Configure.h"

#import "NoteCantBuy.h"
#import "OrderStatus.h"
#import "BagStatus.h"
#import "TransportStatus.h"


@implementation Configure

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        
        _EXCHANGE_RATE           = [[dic objectForKey:@"EXCHANGE_RATE"] floatValue] ;

        _FREIGHT_EXCHANGE_RATE   = [[dic objectForKey:@"FREIGHT_EXCHANGE_RATE"] floatValue] ;
        
        _ADDON                   = [[[dic objectForKey:@"ADDON"] objectForKey:@"price"] floatValue] ;
        
        _FREIGHT                 = [[dic objectForKey:@"FREIGHT"] floatValue] ;
        
        _AUTHORIZATION_TIME      = [[dic objectForKey:@"AUTHORIZATION_TIME"] floatValue] ;
        
        _ORDERS_STATUS           = [OrderStatus getOrderStatusList:dic] ;
        
        _PRODUCT_STATUS_INFO     = [NoteCantBuy getNoteList:dic]        ;
        
        _BAG_STATUS              = [BagStatus getBagStatusList:dic]     ;
        
        _TRANSPORT_STATUS        = [TransportStatus getTransportList:dic] ;
        
        _EXPRESSAGE_DETAILS      = [dic objectForKey:@"EXPRESSAGE_DETAILS"] ;      //sellerid为key的大字典
        
        
        _payTypeList             = [dic objectForKey:@"PAY_TYPE"] ;
        
        
        _wareHouseDic            = [dic objectForKey:@"WAREHOUSE"] ;
        
    }
    
    
    return self;
}


@end
