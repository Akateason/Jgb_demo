//
//  ChinaKuaidi.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ChinaKuaidi.h"
#import "KuaidiHistory.h"


@implementation ChinaKuaidi

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _chinaKuaidiID = [[dic objectForKey:@"id"] intValue] ;
        _name          = [dic objectForKey:@"name"] ;
        _order         = [dic objectForKey:@"order"] ;
        _num           = [[dic objectForKey:@"num"] intValue] ;
        _updateTime    = [dic objectForKey:@"updateTime"] ;
        _message       = [dic objectForKey:@"message"] ;
        _errCode       = [dic objectForKey:@"errCode"] ;
        _status        = [[dic objectForKey:@"status"] intValue] ;
        
        
        NSMutableArray *list = [NSMutableArray array] ;
        NSArray *tempArray = [dic objectForKey:@"data"] ;
        for (NSDictionary *tempDic in tempArray)
        {
            ChinaData *data = [[ChinaData alloc] initWithDiction:tempDic] ;
            KuaidiHistory *history = [[KuaidiHistory alloc] initWithChinaData:data] ;
            [list addObject:history] ;
        }
        _dataArray = list ;
        
    }
    return self;
}

@end
