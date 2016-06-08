//
//  SearchHistoryTB.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-30.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//



#define TABLENAME           @"SearchHistoryTB"

#define SQL_CREATETABLE     @"create table SearchHistoryTB (searchID int primary key NOT NULL,searchString Nvarchar(256) NOT NULL, lastSearchTime Bigint NOT NULL, searchSum int NOT NULL)"

#define SQL_INSERTTABLE     @"INSERT INTO SearchHistoryTB (searchID ,searchString , lastSearchTime , searchSum ) VALUES (?,?,?,?)"



#import "SearchHistoryTB.h"

@implementation SchHistory

@end

static SearchHistoryTB *instance;

@implementation SearchHistoryTB

+ (SearchHistoryTB *)shareInstance
{
    if (instance == nil) {
        instance = [[[self class] alloc] init];
    }
    
    return instance;
}


- (NSString *)databaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:SQLITEPATH];
    
    return dbFilePath;
}


- (void)creatDatabase
{
    @synchronized(DB){
        DB = [FMDatabase databaseWithPath:[self databaseFilePath]];
    }
}

//创建表
- (BOOL)creatTable
{
    @synchronized(DB){
        BOOL b ;
        //先判断数据库是否存在，如果不存在，创建数据库
        if (!DB) {
            [self creatDatabase];
        }
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![DB open]) {
            NSLog(@"数据库打开失败");
            return NO;
        }
        
        //为数据库设置缓存，提高查询效率
        [DB setShouldCacheStatements:YES];
        
        //判断数据库中是否已经存在这个表，如果不存在则创建该表
        if(![DB tableExists:TABLENAME])
        {
            b = [DB executeUpdate:SQL_CREATETABLE];
            if (b) NSLog(@"创建完成");
            
            return b ;
        }
    }
    
    return NO ;
}

//5、增加表数据
- (BOOL)insertSchHistory:(SchHistory *)history
{
    
    @synchronized(DB){
        BOOL b = NO;

        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"数据库打开失败");
            return false;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            [self creatTable];
        }
//@"INSERT INTO SearchHistoryTB (searchID ,searchString , lastSearchTime , searchSum ) VALUES (?,?,?,?)"
        //向数据库中插入一条数据
        b = [DB executeUpdate:SQL_INSERTTABLE,
                  [NSString stringWithFormat:@"%d",history.searchID],
                  history.searchString,
                  [NSString stringWithFormat:@"%lld",history.lastSearchTime],
                  [NSString stringWithFormat:@"%d",history.searchSum]
                  ];
        return b ;
    }
    
    return false ;
}


//6、删除数据

- (void)deleteAllFromSearchHistoryTB
{
    @synchronized(DB){
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"数据库打开失败");
            return;
        }
        
        [DB setShouldCacheStatements:YES];
        
        //判断表中是否有指定的数据， 如果没有则无删除的必要，直接return
        if(![DB tableExists:TABLENAME])
        {
            return;
        }
        //删除操作
        [DB executeUpdate:@"delete from SearchHistoryTB"];
        
    }
}



- (BOOL)deleteName:(NSString *)name
{
    @synchronized(DB)
    {
        if (!DB)
        {
            [self creatDatabase];
        }
        
        if (![DB open])
        {
            NSLog(@"数据库打开失败");
            return NO;
        }
        
        [DB setShouldCacheStatements:YES];
        
        //判断表中是否有指定的数据， 如果没有则无删除的必要，直接return
        if(![DB tableExists:TABLENAME])
        {
            return NO;
        }
        
        //删除操作
        NSString *sqlStr = [NSString stringWithFormat:@"delete from SearchHistoryTB where searchString = '%@'",name] ;
    
       return  [DB executeUpdate:sqlStr] ;
    }
}


//7、修改操作与增加操作的步骤一致
//
//8、查询
//  order by searchSum desc, lastSearchTime desc limit 10
- (NSMutableArray *)getAll
{
    @synchronized(DB){
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"数据库打开失败");
            return nil;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return nil;
        }
        
        NSMutableArray *Array = [[NSMutableArray alloc] initWithArray:0];
        //  order by searchSum desc, lastSearchTime desc limit 10
        FMResultSet *rs = [DB executeQuery:@"select * from SearchHistoryTB order by searchSum desc, lastSearchTime desc"];//limit 10

        while ([rs next])
        {
            SchHistory *history = [[SchHistory alloc] init] ;
            history.searchID = [rs intForColumn:@"searchID"] ;
            history.searchString = [rs stringForColumn:@"searchString"] ;
            history.lastSearchTime = [rs longLongIntForColumn:@"lastSearchTime"] ;
            history.searchSum = [rs intForColumn:@"searchSum"] ;
            
            [Array addObject:history];
        }
        
        return Array ;
    }
}


//isExistSelectHistory
- (SchHistory *)isExistSelectHistory:(NSString *)schStr
{
    @synchronized(DB){
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"数据库打开失败");
            return false;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return false;
        }
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from SearchHistoryTB where searchString = '%@'",schStr]];
        
        SchHistory *schHistory = [[SchHistory alloc] init] ;
        
        while ([rs next])
        {
            schHistory.searchID = [rs intForColumn:@"searchID"] ;
            schHistory.searchString = [rs stringForColumn:@"searchString"] ;
            schHistory.lastSearchTime = [rs longLongIntForColumn:@"lastSearchTime"] ;
            schHistory.searchSum = [rs intForColumn:@"searchSum"] ;        }
        
        return schHistory;
    }
}


- (int)getMaxCID
{
	@synchronized(DB){
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"数据库打开失败");
            return 0;
        }
        
        //	[DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return 0;
        }
        
        //定义一个可变数组，用来存放查询的结果，返回给调用者
        int _maxCID = 0;
        //定义一个结果集，存放查询的数据
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select max(searchID) from SearchHistoryTB"]];
        //判断结果集中是否有数据，如果有则取出数据
        while ([rs next]) {
            _maxCID = [rs intForColumn:@"max(searchID)"];
        }
        return _maxCID ;
    }
}

//update old time  and schNum
- (BOOL)updateTime:(long long)lstime
        AndWithSum:(int)sum
         AndWithID:(int)schID
{
    @synchronized(DB){
        BOOL b = NO;
        
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"数据库打开失败");
            return false;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            [self creatTable];
        }

        b = [DB executeUpdate:
             [NSString stringWithFormat:@"UPDATE SearchHistoryTB set lastSearchTime = '%lld', searchSum = '%d'  where searchID = '%d'",lstime,sum,schID]
             ];
        
        return b ;
    }
    
    return false ;
}


@end
