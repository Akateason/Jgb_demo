//
//  Bag.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Bag.h"

@implementation Bag

- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    
    if (self)
    {
        _parcelID = [[diction objectForKey:@"parcel_id"] intValue] ;
        
        _bagID  = [[diction objectForKey:@"bag_id"] intValue] ;
        
        _status = [[diction objectForKey:@"status"] intValue] ;

        NSMutableArray *productList = [NSMutableArray array] ;
        NSArray *tempProList = [diction objectForKey:@"product"] ;
        for (NSDictionary *tempdic in tempProList)
        {
            OrderProduct *pro = [[OrderProduct alloc] initWithBagDic:tempdic] ;
            [productList addObject:pro] ;
        }
        _productArray = productList ;
        
        
        if (![[diction objectForKey:@"trans_info"] isKindOfClass:[NSNull class]])
        {
            NSMutableArray *transList = [NSMutableArray array] ;
            NSArray *tempTransList = [diction objectForKey:@"trans_info"] ;
            for (NSDictionary *tempDic in tempTransList)
            {
                TransInfo *tran = [[TransInfo alloc] initWithDic:tempDic] ;
                [transList addObject:tran] ;
            }
            _transInfoArray = transList ;
        }
        
        // ADD BY @TEA 20150326 START
        if (![[diction objectForKey:@"logistics_company_id"] isKindOfClass:[NSNull class]])
        {
            _logistics_company_id = [[diction objectForKey:@"logistics_company_id"] intValue] ;

        }
        if (![[diction objectForKey:@"logistics_number"] isKindOfClass:[NSNull class]])
        {
            _logistics_number = [diction objectForKey:@"logistics_number"] ;

        }
        if (![[diction objectForKey:@"logistics_company_name"] isKindOfClass:[NSNull class]])
        {
            _logistics_company_name = [diction objectForKey:@"logistics_company_name"] ;
        }
        if (![[diction objectForKey:@"express_company_id"] isKindOfClass:[NSNull class]])
        {
            _express_company_id = [[diction objectForKey:@"express_company_id"] intValue] ;

        }
        if (![[diction objectForKey:@"express_domestic_id"] isKindOfClass:[NSNull class]])
        {
            _express_domestic_id = [diction objectForKey:@"express_domestic_id"] ;

        }
        if (![[diction objectForKey:@"express_company_name"] isKindOfClass:[NSNull class]])
        {
            _express_company_name = [diction objectForKey:@"express_company_name"] ;

        }        
        // ADD BY @TEA 20150326 START

    }
    
    return self;
}


/*
 *  包裹状态 0 没有签收 1 已经签收
 */
+ (NSString *)getBagStatusStrWithStatus:(int)status
{
    return (status == 0) ? @"未签收" : @"已签收" ;
}


@end


