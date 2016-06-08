//
//  Parcels.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-14.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "Parcel.h"

@implementation Parcel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _parcelID = [[dictionary objectForKey:@"id"] intValue] ;
        _oid = [dictionary objectForKey:@"oid"] ;
        _goods_nums = [[dictionary objectForKey:@"goods_nums"] intValue] ;
        _total_prices = [[dictionary objectForKey:@"total_prices"] floatValue] ;
        _date = [[dictionary objectForKey:@"date"] longLongValue] ;
        _status = [[dictionary objectForKey:@"status"] intValue] ;
        
        //
        if (![[dictionary objectForKey:@"product"] isKindOfClass:[NSNull class]])
        {
            NSMutableArray *proList = [NSMutableArray array] ;
            NSArray *tempProList = [dictionary objectForKey:@"product"] ;
            for (NSDictionary *tempDic in tempProList)
            {
                OrderProduct *tempPro = [[OrderProduct alloc] initWithDic:tempDic] ;
                [proList addObject:tempPro] ;
            }
            _product = proList ;
        }
        
        
        //
        if (![[dictionary objectForKey:@"bags"] isKindOfClass:[NSNull class]]) {
            NSMutableArray *bagList = [NSMutableArray array] ;
            NSArray *tempBagList = [dictionary objectForKey:@"bags"] ;
            for (NSDictionary *tempBagDic in tempBagList)
            {
                Bag *abag = [[Bag alloc] initWithDic:tempBagDic] ;
                [bagList addObject:abag] ;
            }
            _bags = bagList ;
        }
        

        //
        if (![[dictionary objectForKey:@"warehouse_id"] isKindOfClass:[NSNull class]])
        {
            _warehouse_id = [[dictionary objectForKey:@"warehouse_id"] intValue] ;
        }
    }
    
    return self;
}

@end
