//
//  IdCard.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "IdCard.h"

@implementation IdCard

- (instancetype)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        _idcardID = [[dictionary objectForKey:@"id"] intValue] ;
        _idNumber = [dictionary objectForKey:@"number"] ;
        
        _front    = [dictionary objectForKey:@"front"] ;
        _back     = [dictionary objectForKey:@"back"] ;
        
        _time     = [[dictionary objectForKey:@"time"] longLongValue] ;
        
    }
    return self;
}

@end
