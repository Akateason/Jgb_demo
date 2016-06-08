//
//  WareHouse_Total.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-6.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WareHouse_Total : NSObject

@property (nonatomic,assign) float price ;
@property (nonatomic,assign) float low_price ;
@property (nonatomic,assign) float need_price ;
@property (nonatomic,assign) float freight ;
@property (nonatomic)        int   nums ;

- (instancetype)initWithDiction:(NSDictionary *)diction ;

@end
