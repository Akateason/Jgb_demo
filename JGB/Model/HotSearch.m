//
//  HotSearch.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-9.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "HotSearch.h"

@implementation HotSearch

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _type   = [[dic objectForKey:@"type"] intValue] ;
        _name   = [dic objectForKey:@"name"] ;
        _value  = [dic objectForKey:@"value"] ;
    }
    
    return self;
}

- (instancetype)initWithType:(int)type
                 AndWithName:(NSString *)name
                AndWithValue:(NSString *)value
{
    self = [super init];
    if (self)
    {
        
        _type   = type ;
        _name   = name ;
        _value  = value ;

    }
    
    return self;
}

@end
