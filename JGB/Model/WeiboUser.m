//
//  WeiboUser.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "WeiboUser.h"

@implementation WeiboUser

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        
        _idstr          = [dic objectForKey:@"idstr"]          ;       //微博用户id
        _userName       = [dic objectForKey:@"screen_name"]    ;       //用户名
        _location       = [dic objectForKey:@"location"]       ;       //上海 浦东
        _avatar_large   = [dic objectForKey:@"avatar_large"]   ;       //大头图
        
        
        _gender = 0                                            ;       //性别
        NSString *genderStr = [dic objectForKey:@"gender"] ;
        if ([genderStr hasPrefix:@"m"])
        {
            _gender = 1 ;
        }
        else if ([genderStr hasPrefix:@"f"])
        {
            _gender = 2 ;
        }
        
    }
    
    
    return self;
}


@end
