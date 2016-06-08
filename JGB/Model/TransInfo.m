//
//  TransInfo.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-17.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "TransInfo.h"

@implementation TransInfo

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _bag_logistics_id = [[dic objectForKey:@"bag_logistics_id"] intValue];
        _bag_id           = [[dic objectForKey:@"bag_id"] intValue] ;
        _uid              = [[dic objectForKey:@"uid"] intValue] ;
        _type             = [[dic objectForKey:@"type"] intValue] ;
        _shipment         = [dic objectForKey:@"shipment"] ;
        _create_time      = [dic objectForKey:@"create_time"] ;
    }
    return self;
}


@end
