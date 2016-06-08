//
//  ChinaData.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ChinaData.h"

@implementation ChinaData

- (instancetype)initWithDiction:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _time       = [dic objectForKey:@"time"] ;
        _content    = [dic objectForKey:@"content"] ;
    }
    return self;
}

@end
