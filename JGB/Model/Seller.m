//
//  Seller.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Seller.h"

@implementation Seller

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"";
        self.logo = @"";
        self.seller_id = @"";
        
        
//        self.sell = @[] ;
//        self.product_path = @"" ;
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (![dic isKindOfClass:[NSNull class]])
        {
            self.name       = [dic objectForKey:@"name"]                          ;
            self.logo       = [[dic objectForKey:@"logo"] objectForKey:@"109_33"] ;
            self.seller_id  = [dic objectForKey:@"seller_id"]                     ;
            
        }
        else
        {
            return nil ;
        }
    }
    
    return self;
}

- (instancetype)initLoseEfficientSeller
{
    self = [super init];
    if (self) {
        self.name = @"失效";
        self.logo = @"";
        self.seller_id = @"-1";
//        self.sell = @[] ;
//        self.product_path = @"" ;
        self.bid = -1 ;
    }
    return self;
}
@end

