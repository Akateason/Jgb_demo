//
//  Brand.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Brand.h"

@implementation Brand

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        self.brandId = [[dic objectForKey:@"brandId"] intValue] ;
        self.brandName = [dic objectForKey:@"brandName"] ;
        self.cateId  = [[dic objectForKey:@"cateId"] intValue] ;
        
        self.id_    = [[dic objectForKey:@"id"] intValue] ;
        self.f      = [dic objectForKey:@"f"] ;
        self.description_ = [dic objectForKey:@"description"] ;
        
        if( (self.description == nil)||([self.description isKindOfClass:[NSNull class]]) )
        {
            self.description_ = @"";
        }
        
        self.ishot = [[dic objectForKey:@"ishot"] intValue] ;
        self.category = [dic objectForKey:@"category"] ;
        self.chinesename = [dic objectForKey:@"chinesename"] ;
        self.anothername = [dic objectForKey:@"anothername"] ;
    }
    
    return self;
}

@end
