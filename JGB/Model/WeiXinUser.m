//
//  WeiXinUser.m
//  JGB
//
//  Created by JGBMACMINI01 on 15/4/24.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "WeiXinUser.h"

@implementation WeiXinUser


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _openid = [dic objectForKey:@"openid"] ;
        _nickname = [dic objectForKey:@"nickname"] ;
        _sex = [[dic objectForKey:@"sex"] intValue] ;
        _headimgurl = [dic objectForKey:@"headimgurl"] ;
    }
    
    return self;
}

@end
