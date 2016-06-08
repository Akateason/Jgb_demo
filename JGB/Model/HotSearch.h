//
//  HotSearch.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-9.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    typeKeywords = 1 ,
    typeCatagory = 2 ,
    typeHtml5    = 3
} mode_HotSearchType ;


@interface HotSearch : NSObject

@property (nonatomic)       mode_HotSearchType  type    ;
@property (nonatomic,copy)  NSString            *name   ;
@property (nonatomic,copy)  NSString            *value  ;


- (instancetype)initWithDic:(NSDictionary *)dic         ;


- (instancetype)initWithType:(int)type
                 AndWithName:(NSString *)name
                AndWithValue:(NSString *)value          ;

@end
