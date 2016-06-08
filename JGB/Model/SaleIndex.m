//
//  SaleIndex.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-26.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "SaleIndex.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@implementation SaleIndex

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        if (![[dic objectForKey:@"app_image"] isKindOfClass:[NSNull class]]) {
            _images     = [dic objectForKey:@"app_image"]       ;   //图片
        }
        
        _url        = [dic objectForKey:@"url"]             ;   //链接
        _url_type   = [[dic objectForKey:@"url_type"] intValue] ;
        _name       = [dic objectForKey:@"name"]            ;   //名字
        _discount   = [dic objectForKey:@"discount"]        ;
        _title      = [dic objectForKey:@"title"]           ;   //名字
        _category   = [[dic objectForKey:@"category"] intValue] ;
        _addTime    = [[dic objectForKey:@"add_time"] longLongValue] ;
        
        if (![[dic objectForKey:@"tag"] isKindOfClass:[NSNull class]]) _tagList = [dic objectForKey:@"tag"] ;
    }
    
    return self;
}


@end
