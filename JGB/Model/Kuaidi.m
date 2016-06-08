//
//  Kuaidi.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Kuaidi.h"

@implementation Kuaidi

- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    if (self)
    {

        if ([diction isKindOfClass:[NSNull class]])
        {
            return nil ;
        }
        
        _idKuaidi       = [[diction objectForKey:@"id"] intValue] ;
        _name           = [diction objectForKey:@"name"] ;
        _number         = [diction objectForKey:@"number"]  ;
        _status         = [[diction objectForKey:@"status"] intValue] ;
        _create_time    = [[diction objectForKey:@"create_time"] longLongValue] ;
        
        
        NSMutableArray *historyList = [NSMutableArray array] ;
        NSArray *historyDicList = [diction objectForKey:@"history"] ;
        
        for (NSDictionary *dic in historyDicList)
        {
            KuaidiHistory *history = [[KuaidiHistory alloc] initWithDiction:dic] ;
            [historyList addObject:history] ;
        }
        _historyArr = historyList ;
    }
    
    return self;
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if ([dictionary isKindOfClass:[NSNull class]])
        {
            return nil ;
        }
        
        _idKuaidi       = [[dictionary objectForKey:@"id"] intValue] ;
        _name           = [dictionary objectForKey:@"name"] ;
        _number         = [dictionary objectForKey:@"number"] ;
        _status         = [[dictionary objectForKey:@"status"] intValue] ;
        _create_time    = [[dictionary objectForKey:@"time"] longLongValue] ;
        _key            = [dictionary objectForKey:@"key"] ;

    }
    return self;
}


@end
