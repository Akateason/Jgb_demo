//
//  Activity.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goods.h"

// apns


@interface Activity : NSObject

@property (nonatomic)        int         activities_discounttype ;
@property (nonatomic)        float       activities_discount ;
@property (nonatomic)        int         area_discounttype ;
@property (nonatomic)        float       area_discount ;
@property (nonatomic)        int         product_discounttype ;
@property (nonatomic)        float       product_discount ;

@property (nonatomic,copy)   NSString    *productid ;

@property (nonatomic,copy)   NSString    *productpic ;

@property (nonatomic,copy)   NSString    *lastupdate ;

@property (nonatomic,retain) Goods       *goods ;


- (instancetype)initWithDic:(NSDictionary *)dictionary ;


@end
