//
//  SaleIndex.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-26.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
//  最新特卖 (首页) 活动, banner

#import "HotSearch.h"

/*
typedef enum
{
    typeKeywords = 1 ,
    typeCatagory = 2 ,
    typeHtml5    = 3
} mode_HotSearchType ;
*/

@interface SaleIndex : NSObject

@property (nonatomic,copy)      NSString    *images     ;   //图片
@property (nonatomic,copy)      NSString    *url        ;   //链接
@property (nonatomic) mode_HotSearchType    url_type    ;   //url形式 ?
@property (nonatomic,copy)      NSString    *name       ;   //名字
@property (nonatomic,copy)      NSString    *discount   ;   //折扣str
@property (nonatomic,copy)      NSString    *title      ;   //title
@property (nonatomic)           int         category    ;   //category
@property (nonatomic)           long long   addTime     ;   //添加时间
@property (nonatomic,retain)    NSArray     *tagList    ;   //tag[]

//  initail
- (instancetype)initWithDic:(NSDictionary *)dic         ;

@end
