//
//  PriceDetail.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-10.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "PriceDetail.h"

@implementation PriceDetail

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _international_freight      = [[dictionary objectForKey:@"international_freight"] floatValue] ;
        _overseas_freight           = [[dictionary objectForKey:@"overseas_freight"] floatValue] ;
        _product_price              = [[dictionary objectForKey:@"product_price"] floatValue] ;
        
        if (![[dictionary objectForKey:@"privilege_freight"] isKindOfClass:[NSNull class]]) {
            _privilege_freight          = [[dictionary objectForKey:@"privilege_freight"] floatValue] ;
        }
        
        _total_international_price  = [[dictionary objectForKey:@"total_international_price"] floatValue] ;
        _total_price                = [[dictionary objectForKey:@"total_price"] floatValue] ;
    }
    
    return self;
}

@end
