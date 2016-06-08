//
//  SalesProduct.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "SalesProduct.h"

@implementation SalesProduct

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.pid    = [[dic objectForKey:@"pid"] intValue]      ;
        self.actid  = [[dic objectForKey:@"actid"] intValue]    ;
        self.areaid = [[dic objectForKey:@"areaid"] intValue]   ;
        self.productid = [dic objectForKey:@"productid"]        ;
        self.product_name = [dic objectForKey:@"product_name"]  ;
        self.product_image = [dic objectForKey:@"product_image"] ;
        self.productpic    = [dic objectForKey:@"productpic"] ;
        
        if ([dic objectForKey:@"freight"] == nil || [[dic objectForKey:@"freight"] isKindOfClass:[NSNull class]]) {
            self.freight = 0 ;
        } else {
            self.freight = [[dic objectForKey:@"freight"] floatValue] ;
        }
        
        if ([dic objectForKey:@"rmb_price"] == nil || [[dic objectForKey:@"rmb_price"] isKindOfClass:[NSNull class]]) {
            self.rmb_price = 0.0f ;
        }else {
            self.rmb_price = [[dic objectForKey:@"rmb_price"] floatValue] ;
        }

        if ([dic objectForKey:@"actual_price"] == nil || [[dic objectForKey:@"actual_price"] isKindOfClass:[NSNull class]]) {
            self.actual_price = 0.0f ;
        }else {
            self.actual_price = [[dic objectForKey:@"actual_price"] floatValue] ;
        }
        
        if (![[dic objectForKey:@"discount_price"] isKindOfClass:[NSNull class]]) {
            self.discount_price = [[dic objectForKey:@"discount_price"] floatValue] ;
        }
        
        if (![[dic objectForKey:@"list_actual_price"] isKindOfClass:[NSNull class]]) {
            self.list_actual_price = [[dic objectForKey:@"list_actual_price"] floatValue] ;
        }
    }
    
    return self;
}




@end
