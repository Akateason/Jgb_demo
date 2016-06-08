//
//  salesCatagory.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

//商品分类

@interface SalesCatagory : NSObject

@property (nonatomic,assign)int id_ ;               //  商品分类id
@property (nonatomic,assign)int parent_id ;         //  parent商品分类id
@property (nonatomic,copy)NSString *name;           // name
@property (nonatomic,copy)NSString *remark;         // remark



- (instancetype)initWithDic:(NSDictionary *)diction ;
- (instancetype)initWithCata:(SalesCatagory *)cata  ;


+ (void)setupCataIfNeeded ;



@end
