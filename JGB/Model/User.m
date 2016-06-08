//
//  User.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithWeboUser:(WeiboUser *)weiboUser
{
    self = [super init];
    if (self) {
        self.uid = [weiboUser.idstr intValue] ;
        self.nickName = weiboUser.userName ;
        self.imageUrl = weiboUser.avatar_large ;
        self.sex = weiboUser.gender ;
    }
    return self;
}


- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.uid            = [[dic objectForKey:@"uid"] intValue] ;
        self.login          = [dic objectForKey:@"login"] ;
        self.nickName       = [dic objectForKey:@"uname"] ;
        self.realName       = [dic objectForKey:@"truename"] ;
        self.sex            = [[dic objectForKey:@"sex"] intValue] ;
        self.phone          = [dic objectForKey:@"phone"] ;
        self.location       = [dic objectForKey:@"location"] ;
        self.is_audit       = [[dic objectForKey:@"is_audit"] intValue];
        self.is_active      = [[dic objectForKey:@"is_active"] intValue] ;
        self.province       = [[dic objectForKey:@"province"] intValue] ;
        self.city           = [[dic objectForKey:@"city"] intValue] ;
        self.area           = [[dic objectForKey:@"area"] intValue] ;
        self.idcard         = [dic objectForKey:@"idcard"];
        self.birth          = [[dic objectForKey:@"birthday"] longLongValue];
        self.email          = [dic objectForKey:@"email"] ;
    
        self.gold           = [[dic objectForKey:@"gold"] intValue] ;
//        self.countList  = [dic objectForKey:@"countList"] ;
//        self.follow     = [dic objectForKey:@"follow"] ;
        self.fans           = [dic objectForKey:@"fans"] ;
        self.avatar         = [dic objectForKey:@"avatar"];
        
        self.coupons_number = [[dic objectForKey:@"coupons_number"] intValue] ;
        
        if (![[dic objectForKey:@"score"] isKindOfClass:[NSNull class]])
        {
            self.score      = [[dic objectForKey:@"score"] intValue] ;
        }
        
    }
    return self;
}

@end
