//
//  PayType.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-11.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "PayType.h"
#import "DigitInformation.h"

@implementation PayType

- (instancetype)initWithDiction:(NSDictionary *)dic
{
    self = [super init];

    if (self)
    {
        _name = [dic objectForKey:@"name"] ;
        _key = [dic objectForKey:@"key"] ;
        _images = [dic objectForKey:@"images"] ;
    }
    
    return self;
}

+ (PayType *)getPaytypeWithKey:(NSString *)key
{
    for (PayType *pt in [DigitInformation shareInstance].g_payTypeList)
    {
        if ([pt.key isEqualToString:key])
        {
            return pt ;
        }
    }
    
    return nil ;
}


@end
