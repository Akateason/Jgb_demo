//
//  ShopCarFreight.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-8.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "ShopCarFreight.h"

@implementation ShopCarFreight

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _inter_freight = [[dictionary objectForKey:@"inter_freight"] floatValue]    ;
        _usa_freight   = [[dictionary objectForKey:@"usa_freight"] floatValue]      ;
    }
    return self;
}

@end
