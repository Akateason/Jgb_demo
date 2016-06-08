//
//  BagStatus.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BagStatus : NSObject

@property (nonatomic) int idStatus          ;
@property (nonatomic,copy) NSString *name   ;

- (instancetype)initWithDic:(NSDictionary *)diction ;

+ (NSArray *)getBagStatusList:(NSDictionary *)config ;


@end
