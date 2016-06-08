//
//  BrandTB.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-19.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "DigitInformation.h"
#import "Brand.h"


@interface BrandTB : NSObject

+ (BrandTB *)shareInstance ;

- (BOOL)creatTable;

- (BOOL)insertBrand:(Brand *)brand;


- (void)deleteAll ;

- (NSMutableArray *)getAllWithFirstLetter:(NSString *)firstLetter
                           AndWithCateNum:(int)cateNum ;

- (BOOL)isNeedDownLoad ;


@end
