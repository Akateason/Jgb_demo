//
//  DistrictTB.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "DigitInformation.h"
#import "District.h"

@interface DistrictTB : NSObject

+ (DistrictTB *)shareInstance               ;

- (BOOL)creatTable                          ;

- (BOOL)insertDistrict:(District *)district ;

- (void)deleteAll                           ;

- (NSArray *)getDistrictListWithPid:(int)pid    ;

- (District *)getDistrictWithID:(int)ID     ;



- (BOOL)hasInDB ;

@end
