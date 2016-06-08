//
//  TagsIndex.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-2.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "TagsIndex.h"

@implementation TagsIndex

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _tag_id     = [[dic objectForKey:@"tag_id"] intValue] ;
        _tag_name   = [dic objectForKey:@"tag_name"] ;
    }
    
    return self;
}

@end
