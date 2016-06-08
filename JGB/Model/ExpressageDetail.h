//
//  ExpressageDetail.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-16.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExPressKVO : NSObject
@property (nonatomic)           int         idDetail    ;
@property (nonatomic,copy)      NSString    *key        ;
@property (nonatomic,copy)      NSString    *value      ;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary ;
@end


@interface ExpressageDetail : NSObject

@property (nonatomic,copy)      NSString    *title      ;
@property (nonatomic,retain)    NSArray     *kvoArr     ;

/*
 *****************************************************************
 *  @params:
 *      fatherDic : G_EXPRESSDETAIL_DIC
 *      sellerID  : 1,2, 1000
 *  @return:
 *      return    : sub dic to parsel get ExpressageDetail final.
 *****************************************************************
**/
+ (NSDictionary *)getDicToPaselWithSellerID:(int)sellerID AndFatherDic:(NSDictionary *)fatherDic ;


//  initial
- (instancetype)initWithDic:(NSDictionary *)dic ;

@end
