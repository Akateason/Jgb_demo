//
//  LikeProduct.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-19.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "LikeProduct.h"

@implementation LikeProduct

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        _id_like = [[dictionary objectForKey:@"id"] intValue] ;
        _pid     = [dictionary objectForKey:@"pid"] ;
        _date    = [[dictionary objectForKey:@"date"] longLongValue] ;
        _product = [[Goods alloc] initWithDic:[dictionary objectForKey:@"product"]] ;
    }
    
    return self;
}

@end
