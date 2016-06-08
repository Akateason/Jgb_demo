//
//  ChinaData.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChinaData : NSObject

@property (nonatomic,copy)      NSString        *time       ;
@property (nonatomic,copy)      NSString        *content    ;

- (instancetype)initWithDiction:(NSDictionary *)dic         ;

@end
