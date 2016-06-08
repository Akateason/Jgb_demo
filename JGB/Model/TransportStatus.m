//
//  TransportStatus.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "TransportStatus.h"

@implementation TransportStatus

- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    if (self)
    {
        _idTransport = [[diction objectForKey:@"id"] integerValue] ;
        _name        = [diction objectForKey:@"name"] ;
    }
    return self;
}

+ (NSArray *)getTransportList:(NSDictionary *)config
{
    NSMutableArray  *tranStatus             = [NSMutableArray array] ;
    NSArray         *transStatusInfoArr   = [config objectForKey:@"TRANSPORT_STATUS"] ;
    for (NSDictionary *dic in transStatusInfoArr)
    {
        TransportStatus *tran = [[TransportStatus alloc] initWithDic:dic] ;
        [tranStatus addObject:tran] ;
    }
    
    return tranStatus ;
}



@end
