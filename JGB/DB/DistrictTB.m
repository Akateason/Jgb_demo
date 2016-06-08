//
//  DistrictTB.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//



#define TABLENAME           @"DistrictTB"

#define SQL_CREATETABLE     @"create table DistrictTB (districtID INT NOT NULL primary key  DEFAULT '0', name Nvarchar(128) NOT NULL DEFAULT '', upid INT NOT NULL DEFAULT '0', sort INT NOT NULL DEFAULT '0', zip INT NOT NULL DEFAULT '0') "

#define SQL_INSERTTABLE     @"INSERT INTO DistrictTB (districtID , name , upid , sort , zip)  VALUES (?,?,?,?,?)"


#import "DistrictTB.h"

@implementation DistrictTB


static DistrictTB *instance;

+ (DistrictTB *)shareInstance
{
    if (instance == nil)
    {
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

- (BOOL)creatTable
{
    @synchronized(DB){
        BOOL b ;
        if (!DB) {
            [self creatDatabase];
        }
        if (![DB open]) {
            NSLog(@"数据库打开失败");
            return NO;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            b = [DB executeUpdate:SQL_CREATETABLE];
            if (b) NSLog(@"创建完成");
            
            return b ;
        }
    }
    
    return NO ;
}


- (BOOL)insertDistrict:(District *)district
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
        
        b = [DB executeUpdate:SQL_INSERTTABLE,
             [NSString stringWithFormat:@"%d",district.districtID],
             district.name,
             [NSString stringWithFormat:@"%d",district.upid],
             [NSString stringWithFormat:@"%d",district.sort],
             [NSString stringWithFormat:@"%d",district.zip]
             ] ;
        
        return b ;
    }
    
    return false ;
}



- (void)deleteAll
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
        
        if(![DB tableExists:TABLENAME])
        {
            return;
        }
        [DB executeUpdate:[NSString stringWithFormat:@"delete from %@",TABLENAME]];
        
    }
}


- (NSArray *)getDistrictListWithPid:(int)pid
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
        
        NSMutableArray *_array = [[NSMutableArray alloc] initWithArray:0];
        
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from %@ where upid = '%d'",TABLENAME,pid]];
        
        while ([rs next])
        {
            District *dist = [[District alloc] init] ;

            dist.districtID = [rs intForColumn:@"districtID"] ;
            dist.name       = [rs stringForColumn:@"name"] ;
            dist.upid       = [rs intForColumn:@"upid"] ;
            dist.sort       = [rs intForColumn:@"sort"] ;
            dist.zip        = [rs intForColumn:@"zip"] ;
  
            [_array addObject:dist]                  ;
        }
        
        return _array ;
    }
}

- (District *)getDistrictWithID:(int)ID
{
    @synchronized(DB)
    {
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
        
        District *dist = [[District alloc] init] ;

        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from %@ where districtID = '%d'",TABLENAME,ID]];
        
        while ([rs next])
        {
            dist.districtID = [rs intForColumn:@"districtID"] ;
            dist.name       = [rs stringForColumn:@"name"] ;
            dist.upid       = [rs intForColumn:@"upid"] ;
            dist.sort       = [rs intForColumn:@"sort"] ;
            dist.zip        = [rs intForColumn:@"zip"] ;
            
        }
        
        return dist ;
    }
}



- (BOOL)hasInDB
{
    @synchronized(DB){
        if (!DB) {
            [self creatDatabase];
        }
        
        if (![DB open]) {
            NSLog(@"数据库打开失败");
            return YES;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return YES;
        }
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",TABLENAME]];
        
        int myCount = 0 ;
        
        while ([rs next])
        {
            myCount = [rs intForColumn:@"COUNT(*)"] ;
        }

        if (myCount > 0)
        {
            return YES ;
        }
        else
        {
            return NO  ;
        }
    }
}








@end
