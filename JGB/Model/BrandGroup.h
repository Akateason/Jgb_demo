//
//  BrandGroup.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brand.h"

// 品牌 list 首字母


@interface BrandGroup : NSObject

@property (nonatomic,copy)      NSString     *prefix        ;
@property (nonatomic,retain)    NSArray      *preBrandList  ;       // list of obj brand

@end
