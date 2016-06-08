//
//  CategoryTB.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "DigitInformation.h"
#import "SalesCatagory.h"


@interface CategoryTB : NSObject

+ (CategoryTB *)shareInstance ;




- (BOOL)creatTable;

- (BOOL)insertCategory:(SalesCatagory *)cata;


- (void)deleteAll ;

- (NSMutableArray *)getAllWithParentId:(int)parentID ;

- (SalesCatagory *)getCataWithCataID:(int)cataID ;


- (BOOL)hasInDB ;

- (void)begin   ;

- (void)commit  ;

@end
