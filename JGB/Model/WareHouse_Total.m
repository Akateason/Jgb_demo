//
//  WareHouse_Total.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-6.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "WareHouse_Total.h"

@implementation WareHouse_Total

- (instancetype)initWithDiction:(NSDictionary *)diction
{
    self = [super init];
    if (self)
    {
        
        self.price      = [[diction objectForKey:@"price"] floatValue] ;
        self.low_price  = [[diction objectForKey:@"low_price"] floatValue] ;
        self.need_price = [[diction objectForKey:@"need_price"] floatValue] ;
        self.freight    = [[diction objectForKey:@"freight"] floatValue] ;
        self.nums       = [[diction objectForKey:@"nums"] intValue] ;
    }
    return self;
}


@end
