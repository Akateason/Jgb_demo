//
//  Area.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Area.h"
#import "SalesProduct.h"

@implementation Area

- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    if (self)
    {
        self.code   = [diction objectForKey:@"code"]    ;
        self.title  = [diction objectForKey:@"title"]   ;
        NSArray *array = [diction objectForKey:@"product_list"] ;
        NSMutableArray *resultArray = [NSMutableArray array]    ;
        for (NSDictionary *dicProduct in array)
        {
            SalesProduct *product = [[SalesProduct alloc] initWithDic:dicProduct] ;
            [resultArray addObject:product] ;
        }
        
        self.product_list = resultArray ;
        
    }
    return self;
}

@end
