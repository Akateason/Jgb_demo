//
//  ReceiveAddress.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "District.h"

//收货地址

@interface ReceiveAddress : NSObject

//是否默认地址
@property (nonatomic,assign)   BOOL         isDefault ; //是否默认
@property (nonatomic)           int         addressId ; //地址id
@property (nonatomic)           int         uid ;       //用户id
@property (nonatomic,copy)      NSString    *uname ;    //用户名
@property (nonatomic)           int         province ;  //省份id
@property (nonatomic)           int         city ;      //城市id
@property (nonatomic)           int         area ;      //地区id
@property (nonatomic,copy)      NSString    *address ;  //地址
@property (nonatomic)           int         areacode ;  //邮编
@property (nonatomic,copy)      NSString    *phone ;    //手机
@property (nonatomic,copy)      NSString    *tel ;      //电话
@property (nonatomic,copy)      NSString    *email ;    //邮箱
@property (nonatomic,copy)      NSString    *idcard ;   //身份证
@property (nonatomic,copy)      NSString    *location ;
@property (nonatomic,copy)      NSString    *front  ;
@property (nonatomic,copy)      NSString    *back   ;

@property (nonatomic)           BOOL        idcard_status ; //是否已经上传了身份证 .

- (instancetype)initWithDic:(NSDictionary *)diction ;

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
                   AndWithTel:(NSString *)tel       ;

//拿到详细地址
- (NSString *)getDetailAddress ;


@end
