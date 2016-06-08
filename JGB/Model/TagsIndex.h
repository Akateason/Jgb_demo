//
//  TagsIndex.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-2.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagsIndex : NSObject

@property (nonatomic)   int         tag_id      ;
@property (nonatomic)   NSString    *tag_name   ;

- (instancetype)initWithDic:(NSDictionary *)dic ;

@end
