//
//  NoteCantBuy.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "NoteCantBuy.h"

@implementation NoteCantBuy


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _idNote = [[dic objectForKey:@"id"] integerValue] ;
        _name   = [dic objectForKey:@"name"] ;
    }
    
    return self;
}

+ (NSArray *)getNoteList:(NSDictionary *)config
{
    NSMutableArray  *noteStatus             = [NSMutableArray array] ;
    NSArray         *productStatusInfoArr   = [config objectForKey:@"PRODUCT_STATUS_INFO"] ;
    for (NSDictionary *dic in productStatusInfoArr)
    {
        NoteCantBuy *note = [[NoteCantBuy alloc] initWithDic:dic] ;
        [noteStatus addObject:note] ;
    }
    
    return noteStatus ;
}

@end
