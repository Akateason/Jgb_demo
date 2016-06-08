//
//  IdCard.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

// 身份证

@interface IdCard : NSObject

@property (nonatomic,assign)    int                 idcardID    ;

@property (nonatomic,copy)      NSString            *front      ;
@property (nonatomic,copy)      NSString            *back       ;
@property (nonatomic,assign)    long long           time        ;

@property (nonatomic,copy)      NSString            *name       ;       //收货人姓名
@property (nonatomic,copy)      NSString            *idNumber   ;       //身份证号
@property (nonatomic,copy)      NSString            *address    ;       //收货地址



- (instancetype)initWithDic:(NSDictionary *)dictionary ;


@end
