//
//  TransInfo.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-17.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransInfo : NSObject

@property (nonatomic)           int         bag_logistics_id ;
@property (nonatomic)           int         bag_id ;
@property (nonatomic)           int         uid ;
@property (nonatomic)           int         type ;
@property (nonatomic,copy)      NSString    *shipment ;
@property (nonatomic,copy)      NSString    *create_time ;

- (instancetype)initWithDic:(NSDictionary *)dic         ;

@end
