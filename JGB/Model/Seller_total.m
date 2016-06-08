//
//  Seller_total.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-23.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Seller_total.h"

@implementation Seller_total

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
