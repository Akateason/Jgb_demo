//
//  Promotiom.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

//优惠
@interface Promotiom : NSObject

@property (nonatomic,assign)    float       price       ;   //打折后的价格
@property (nonatomic,copy)      NSString    *name       ;   //名称
@property (nonatomic)           int         stock       ;

@property (nonatomic,assign)    int         type        ;   //折扣类型: 1百分比  2实际扣除
@property (nonatomic,assign)    float       discount    ;   //折扣率: 当type=1,0代表0折扣,1代表不打折扣 0.9代表 9折。
@property (nonatomic,assign)    float       privilege   ;   //打折,打去了多少钱
@property (nonatomic)           long long   begintime   ;
@property (nonatomic)           long long   endtime     ;
@property (nonatomic,copy)      NSString    *image      ;
@property (nonatomic,copy)      NSString    *code       ;

- (instancetype)initWithDic:(id)sender         ;

@end
