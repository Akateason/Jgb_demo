//
//  Price_area.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

//价位

@interface Price_area : NSObject


@property (nonatomic,copy)      NSString *name          ;   //0-4990
@property (nonatomic,assign)    int      price_min      ;   //0
@property (nonatomic,assign)    int      price_max      ;   //499

- (instancetype)initWithDiction:(NSDictionary *)dic     ;

@end
