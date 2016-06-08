//
//  SearchHistoryTB.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-30.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "DigitInformation.h"

//model
@interface SchHistory : NSObject

@property (nonatomic,assign)        int         searchID       ;        //id

@property (nonatomic,copy)          NSString    *searchString  ;        //content
@property (nonatomic,assign)        long long   lastSearchTime ;        //last search time
@property (nonatomic,assign)        int         searchSum      ;        //search sum number

@end


//sql
@interface SearchHistoryTB : NSObject

+ (SearchHistoryTB *)shareInstance;

- (BOOL)creatTable;

- (BOOL)insertSchHistory:(SchHistory *)history;

- (void)deleteAllFromSearchHistoryTB ;

//  order by searchSum desc, lastSearchTime desc limit 10
- (NSMutableArray *)getAll;

- (BOOL)deleteName:(NSString *)name ;

//isExistSelectHistory
- (SchHistory *)isExistSelectHistory:(NSString *)schStr ;

- (int)getMaxCID ;

//update old time  and schNum
- (BOOL)updateTime:(long long)lstime AndWithSum:(int)sum AndWithID:(int)schID ;

@end


