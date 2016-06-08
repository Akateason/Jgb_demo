//
//  Seller_total.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-23.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Seller_total : NSObject

@property (nonatomic,assign) float price ;
@property (nonatomic,assign) float low_price ;
@property (nonatomic,assign) float need_price ;
@property (nonatomic,assign) float freight ;
@property (nonatomic)        int   nums ;

- (instancetype)initWithDiction:(NSDictionary *)diction ;

@end
