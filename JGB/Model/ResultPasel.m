//
//  ResultPasel.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ResultPasel.h"

@implementation ResultPasel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        
        _code = [[dictionary objectForKey:@"code"]  intValue] ;
        _info = [dictionary objectForKey:@"info"] ;
        _data = [dictionary objectForKey:@"data"] ;
        
    }
    return self;
}

@end
