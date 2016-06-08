//
//  ReceiveAddress.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ReceiveAddress.h"
#import "District.h"
#import "DistrictTB.h"


@implementation ReceiveAddress

- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    if (self)
    {
        self.addressId = [[diction objectForKey:@"id"] isKindOfClass:[NSNull class]] ? 0 : [[diction objectForKey:@"id"] intValue] ;
        
        self.isDefault = [[diction objectForKey:@"isdefault"] intValue] ;
        self.uid       = [[diction objectForKey:@"uid"] intValue] ;
        self.uname     = [diction objectForKey:@"uname"] ;
        self.province  = [[diction objectForKey:@"province"] intValue] ;
        self.city      = [[diction objectForKey:@"city"] intValue] ;
        self.area      = [[diction objectForKey:@"area"] intValue] ;
        self.address   = [diction objectForKey:@"address"] ;
        self.areacode  = [[diction objectForKey:@"areacode"] intValue] ;
        self.phone     = [diction objectForKey:@"phone"] ;
        self.email     = [diction objectForKey:@"email"] ;
        self.idcard    = [diction objectForKey:@"idcard"] ;
        
        if (![[diction objectForKey:@"location"] isKindOfClass:[NSNull class]]) {
            self.location  = [diction objectForKey:@"location"] ;
        }
        
        if (![[diction objectForKey:@"tel"] isKindOfClass:[NSNull class]])
        {
            self.tel       = [diction objectForKey:@"tel"] ;
        }
        
        self.front = [diction objectForKey:@"front"] ;
        self.back = [diction objectForKey:@"back"] ;
        
        self.idcard_status = [[diction objectForKey:@"idcard_status"] intValue];
    }
    
    
    return self;
}


- (instancetype)initWithUname:(NSString *)uname
            AndWithProvinceID:(int)provinceID
                AndWithCityID:(int)cityID
                AndWithAreaID:(int)areaID
               AndWithAddress:(NSString *)address
            AndWithPostalCode:(int)postalCode
                 AndWithPhone:(NSString *)phone
                 AndWithEmail:(NSString *)email
                AndWithIdCard:(NSString *)idcard
               AndWithDefault:(int)isdefault
             AndWithAddressID:(int)addressID
                   AndWithUid:(int)uID
                   AndWithTel:(NSString *)tel
{
    self = [super init];
    if (self)
    {
        self.isDefault = isdefault ;
        self.uname     = uname ;
        self.province  = provinceID;
        self.city      = cityID ;
        self.area      = areaID ;
        self.address   = address ;
        self.areacode  = postalCode ;
        self.phone     = phone ;
        self.email     = email ;
        self.idcard    = idcard ;
        self.addressId = addressID ;
        self.uid       = uID ;
        self.tel       = tel ;
    }
    
    return self;
}

- (NSString *)getDetailAddress
{
    District *districtProvince = [[DistrictTB shareInstance] getDistrictWithID:self.province] ;
    District *districtCity     = [[DistrictTB shareInstance] getDistrictWithID:self.city] ;
    District *districtArea     = [[DistrictTB shareInstance] getDistrictWithID:self.area] ;
    
    NSString *resultStr = [NSString stringWithFormat:@"%@ %@ %@ %@",districtProvince.name,districtCity.name,districtArea.name,self.address] ;
    
    return resultStr ;
}

@end
