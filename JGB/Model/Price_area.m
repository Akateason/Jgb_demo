//
//  Price_area.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Price_area.h"

@implementation Price_area

- (instancetype)initWithDiction:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.name      = [dic objectForKey:@"name"] ;
        NSArray *arrP = [dic objectForKey:@"p"] ;        
        self.price_min = [[arrP firstObject] intValue];
        self.price_max = [[arrP objectAtIndex:1] longValue];
    }
    return self;
}

@end
