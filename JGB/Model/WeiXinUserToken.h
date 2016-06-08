//
//  WeiXinUserToken.h
//  JGB
//
//  Created by JGBMACMINI01 on 15/4/24.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiXinUserToken : NSObject

@property (nonatomic,copy) NSString *accessToken ;
@property (nonatomic)      long     expiresIn ;
@property (nonatomic,copy) NSString *refreshToken ;
@property (nonatomic,copy) NSString *openID ;
@property (nonatomic,copy) NSString *scope ;
@property (nonatomic,copy) NSString *unionID ;

- (instancetype)initWithDic:(NSDictionary *)dic ;

@end
