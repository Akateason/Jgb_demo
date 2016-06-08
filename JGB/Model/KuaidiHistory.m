//
//  KuaidiHistory.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "KuaidiHistory.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@implementation KuaidiHistory

- (instancetype)initWithDiction:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        
        _idHistory      = [[dictionary objectForKey:@"id"] intValue] ;
        _idKuaidi       = [[dictionary objectForKey:@"kuaidi_id"] intValue] ;
        _content        = [dictionary objectForKey:@"content"] ;
        _status         = [[dictionary objectForKey:@"status"] intValue] ;
        _create_time    = [[dictionary objectForKey:@"create_time"] longLongValue] ;
        
    }
    return self;
}


- (instancetype)initWithChinaData:(ChinaData *)data
{
    self = [super init];
    if (self)
    {
        _content = data.content ;
        _create_time = [MyTick getTickWithDate:[MyTick getNSDateWithDateStr:data.time AndWithFormat:TIME_STR_FORMAT_3]] ;
    }
    return self;
}


@end
