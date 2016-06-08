//
//  OrderProduct.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "OrderProduct.h"

@implementation OrderProduct

- (instancetype)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        
        if ([dictionary isKindOfClass:[NSNull class]]) return nil ;
            
        
        _orders_id      = [[dictionary objectForKey:@"id"] intValue] ;
        _bag_id         = [[dictionary objectForKey:@"bag_id"] intValue] ;
        _uid            = [[dictionary objectForKey:@"uid"] intValue] ;
        _bid            = [[dictionary objectForKey:@"bid"] intValue] ;
        _pid            = [dictionary objectForKey:@"pid"] ;
        
        _prices         = [[dictionary objectForKey:@"prices"] floatValue] ;
        _nums           = [[dictionary objectForKey:@"nums"] intValue] ;
        _total_prices   = [[dictionary objectForKey:@"total_prices"] floatValue] ;
        _commment       = [[dictionary objectForKey:@"comment"] intValue] ;
        _date           = [[dictionary objectForKey:@"date"] longLongValue] ;
        
        if (![[dictionary  objectForKey:@"title"] isKindOfClass:[NSNull class]])
        {
            _title          = [dictionary  objectForKey:@"title"] ;
        }
        
        _images         = [dictionary  objectForKey:@"images"] ;
        
        _guige          = [dictionary objectForKey:@"guige"] ;
        
        NSString  *string = @"" ;
        if ( ![[dictionary objectForKey:@"guige"] isKindOfClass:[NSNull class]] && [[dictionary objectForKey:@"guige"] count] )
        {
            NSArray *guigeAllkeys = [_guige allKeys] ;
            for (NSString *key in guigeAllkeys)
            {
                NSString *shuxing = [NSString stringWithFormat:@"%@ : %@ ",key,[_guige objectForKey:key]] ;
                string = [string stringByAppendingString:shuxing] ;
            }
        }
        
        _features = string ;
    }
    
    return self;
}

- (instancetype)initWithBagDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _pid         = [dic objectForKey:@"product_code"] ;
        _sku         = [dic objectForKey:@"sku"] ;
        _title       = [dic objectForKey:@"title"] ;
        _nums         = [[dic objectForKey:@"num"] intValue] ;
        _images       = [dic objectForKey:@"image"] ;
        
        
        if (![[dic objectForKey:@"specifications"] isKindOfClass:[NSNull class]])
        {
            _guige = [dic objectForKey:@"specifications"] ;
        }
        
        
        NSString  *string = @"" ;
        if ( ![[dic objectForKey:@"specifications"] isKindOfClass:[NSNull class]] && !([dic objectForKey:@"specifications"] != 0) )
        {
            NSArray *guigeAllkeys = [_guige allKeys] ;
            for (NSString *key in guigeAllkeys)
            {
                NSString *shuxing = [NSString stringWithFormat:@"%@ : %@ ",key,[_guige objectForKey:key]] ;
                string = [string stringByAppendingString:shuxing] ;
            }
        }
        _features = string ;
    }
    return self;
}



@end
