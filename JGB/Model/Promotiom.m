//
//  Promotiom.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Promotiom.h"

@implementation Promotiom

- (instancetype)initWithDic:(id)sender
{
    NSDictionary *dic ;
    if ( [sender isKindOfClass:[NSDictionary class]] ) {
        dic = (NSDictionary *)sender ;
    }else {
        return nil ;
    }
    
    self = [super init];
    if (self)
    {
        self.type = [[dic objectForKey:@"type"] intValue] ;
        self.discount = [[dic objectForKey:@"discount"] floatValue];
        self.name = [dic objectForKey:@"name"] ;
        self.privilege = [[dic objectForKey:@"privilege"] floatValue];
        self.price = [[dic objectForKey:@"price"] floatValue] ;
        
        self.begintime = [[dic objectForKey:@"begintime"] longLongValue] ;
        self.endtime = [[dic objectForKey:@"endtime"] longLongValue] ;
        
        self.image  = [dic objectForKey:@"image"] ;
        
        self.stock  = [[dic objectForKey:@"stock"] intValue];
        
        self.code   = [dic objectForKey:@"id"] ;
    }
    
    return self;
}



@end
