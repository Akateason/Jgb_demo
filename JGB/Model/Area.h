//
//  Area.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject


@property (nonatomic,copy)NSString  *code    ;
@property (nonatomic,copy)NSString  *title   ;
@property (nonatomic,retain)NSArray *product_list ;


- (instancetype)initWithDic:(NSDictionary *)diction ;


@end
