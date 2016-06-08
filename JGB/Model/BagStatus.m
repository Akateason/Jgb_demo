//
//  BagStatus.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "BagStatus.h"

@implementation BagStatus

- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    if (self)
    {
        _idStatus = [[diction objectForKey:@"id"] integerValue] ;
        _name     = [diction objectForKey:@"name"] ;
    }
    return self;
}

+ (NSArray *)getBagStatusList:(NSDictionary *)config
{
    NSMutableArray  *bagStatus             = [NSMutableArray array] ;
    NSArray         *bagStatusInfoArr   = [config objectForKey:@"BAG_STATUS"] ;
    for (NSDictionary *dic in bagStatusInfoArr)
    {
        BagStatus *bag = [[BagStatus alloc] initWithDic:dic] ;
        [bagStatus addObject:bag] ;
    }
    
    return bagStatus ;
}



@end
