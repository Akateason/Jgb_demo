//
//  WarehouseTB.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-6.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "DigitInformation.h"
#import "WareHouse.h"

//  仓库

@interface WarehouseTB : NSObject


+ (WarehouseTB *)shareInstance ;

- (BOOL)creatTable;

- (BOOL)insertWarehouse:(WareHouse *)warehouse;

- (WareHouse *)getWarehouseWithId:(int)wareHouseID ;

- (WareHouse *)getWarehouseWithName:(NSString *)name  ;

- (BOOL)hasInDB ;

- (NSMutableArray *)getAllWarehouse ;

@end
