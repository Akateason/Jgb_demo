//
//  Select_val.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Price_area.h"
#import "Seller.h"
#import "SalesCatagory.h"
#import "Brand.h"

//筛选
@interface Select_val : NSObject

//价位区间
@property (nonatomic,retain) NSArray        *priceAreaArray      ;
//卖家们(供应商)
@property (nonatomic,retain) NSArray        *sellersArray        ;
//子类们
//@property (nonatomic,retain) NSArray        *salesCatagoryArray  ;
//热门品牌list
@property (nonatomic,retain) NSArray        *hotBrandArray       ;      //a list of STR (Hot BrandList)


//当前下标
//@property (nonatomic,copy)  NSString        *cataStrCache        ;

@property (nonatomic,assign) int            currentPriceArea     ;
@property (nonatomic,assign) int            currentSellers       ;
//@property (nonatomic,assign) int            currentCatagory      ;

@property (nonatomic,copy)  NSString        *currentBrandSTR     ;



//促销,中文说明
@property (nonatomic,assign) int            isOnSales            ;      //-1 noting , 0->no , 1->yes
@property (nonatomic,assign) int            isChinese            ;      //-1 noting , 0->no , 1->yes



- (instancetype)initWithDictionary:(NSDictionary *)dic           ;

- (instancetype)initWithSelectVal:(Select_val *)selectVal        ;

@end
