//
//  District.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "District.h"

@implementation District

- (instancetype)initWithDic:(NSDictionary *)diciton
{
    self = [super init];
    if (self)
    {
        self.districtID = [[diciton objectForKey:@"id"] intValue] ;
        self.name       = [diciton objectForKey:@"name"] ;
        self.upid       = [[diciton objectForKey:@"upid"] intValue] ;
        self.sort       = [[diciton objectForKey:@"sort"] intValue] ;
        self.zip        = [[diciton objectForKey:@"zip"] intValue] ;
    }
    
    return self;
}

@end
