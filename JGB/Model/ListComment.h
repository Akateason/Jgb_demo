//
//  ListComment.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-15.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListComment : NSObject

@property (nonatomic,copy)      NSString        *image ;
@property (nonatomic,copy)      NSString        *title ;
@property (nonatomic)           int             orderProductId ;
@property (nonatomic,copy)      NSString        *code ;
@property (nonatomic)           int             status ;
@property (nonatomic)           float           price  ;
@property (nonatomic)           int             nums   ;
@property (nonatomic)           float           totalPrice  ;

- (instancetype)initWithDic:(NSDictionary *)dic         ;

@end
