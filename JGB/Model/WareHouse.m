//
//  WareHouse.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-6.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "WareHouse.h"
#import "WarehouseTB.h"
#import "DigitInformation.h"

@implementation WareHouse

- (instancetype)initWithDic:(NSDictionary *)dic AndWithID:(int)idWH
{
    self = [super init];
    if (self)
    {
        _name = [dic objectForKey:@"name"] ;
        
        _url = [dic objectForKey:@"url"] ;
        
        _content = [dic objectForKey:@"content"] ;
        
        _idWarehouse = idWH ;
        
    }
    return self;
}



+ (NSArray *)getAllWarehouseFromDB
{
    NSArray *warelist = [[WarehouseTB shareInstance] getAllWarehouse] ;
    
    return warelist ;
}

+ (WareHouse *)getWarehouseWithID:(int)idWarehouse 
{
    
    for (WareHouse *warehouseTemp in [DigitInformation shareInstance].g_wareHouseList)
    {
        if (idWarehouse == warehouseTemp.idWarehouse)
        {
            return warehouseTemp ;
        }
    }
    
    return nil ;
}

@end
