//
//  NoteCantBuy.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteCantBuy : NSObject

@property (nonatomic)       int             idNote  ;

@property (nonatomic,copy)  NSString        *name   ;

- (instancetype)initWithDic:(NSDictionary *)dic     ;

+ (NSArray *)getNoteList:(NSDictionary *)config ;

@end
