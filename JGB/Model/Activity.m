//
//  Activity.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Activity.h"

@implementation Activity

- (instancetype)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _activities_discounttype = [[dictionary objectForKey:@"activities_discounttype"] intValue] ;
        _activities_discount = [[dictionary objectForKey:@"activities_discount"] floatValue] ;
        _area_discounttype = [[dictionary objectForKey:@"area_discounttype"] intValue] ;
        _area_discount = [[dictionary objectForKey:@"area_discount"] floatValue] ;
        _product_discounttype = [[dictionary objectForKey:@"product_discounttype"] intValue] ;
        _product_discount = [[dictionary objectForKey:@"product_discount"] floatValue] ;
        
        _productid = [dictionary objectForKey:@"productid"] ;
        
        _productpic = [dictionary objectForKey:@"productpic"] ;
        
        _lastupdate = [dictionary objectForKey:@"lastupdate"] ;
        
        _goods = [[Goods alloc] initWithDic:[dictionary objectForKey:@"product"]] ;
        
    }
    
    return self;
}

@end
