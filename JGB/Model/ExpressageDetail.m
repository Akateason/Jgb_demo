//
//  ExpressageDetail.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-16.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "ExpressageDetail.h"

@implementation ExPressKVO

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _idDetail = [[dictionary objectForKey:@"id"] intValue];
        _key      = [dictionary objectForKey:@"key"] ;
        _value    = [dictionary objectForKey:@"value"] ;
    }
    return self;
}


@end


@implementation ExpressageDetail



+ (NSDictionary *)getDicToPaselWithSellerID:(int)sellerID AndFatherDic:(NSDictionary *)fatherDic
{
    
    NSString *keyStr      = [NSString stringWithFormat:@"%d",sellerID] ;
    NSDictionary *tempDic = [fatherDic objectForKey:keyStr] ;
    
    return tempDic ;
}


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _title = [dic objectForKey:@"title"] ;

        NSMutableArray *array   = [NSMutableArray array] ;
        NSArray *tempArray      = [dic objectForKey:@"kvo"] ;
        for (NSDictionary *tempDic in tempArray)
        {
            ExPressKVO *kvobj = [[ExPressKVO alloc] initWithDictionary:tempDic] ;
            [array addObject:kvobj] ;
        }
        _kvoArr = array ;
    }
    return self;
}

@end
