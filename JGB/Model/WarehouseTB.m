//
//  WarehouseTB.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-6.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "WarehouseTB.h"

#define TABLENAME           @"WarehouseTB"

#define SQL_CREATETABLE     @"create table WarehouseTB (wareHouseID INT NOT NULL primary key DEFAULT '0' , name Nvarchar(64) NOT NULL DEFAULT '', url Nvarchar(256) NOT NULL DEFAULT '' , content TEXT NOT NULL DEFAULT '')"

#define SQL_INSERTTABLE     @"INSERT INTO WarehouseTB (wareHouseID , name , url , content)  VALUES (?,?,?,?)"



@implementation WarehouseTB

static WarehouseTB *instance;


+ (WarehouseTB *)shareInstance
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

- (BOOL)insertWarehouse:(WareHouse *)warehouse
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
             [NSString stringWithFormat:@"%d",warehouse.idWarehouse],
             warehouse.name,
             warehouse.url,
             warehouse.content
             ] ;
        
        return b ;
    }
    
    return false ;
}

- (WareHouse *)getWarehouseWithId:(int)wareHouseID
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
            return nil;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return nil;
        }
        
        WareHouse *wareHouse = [[WareHouse alloc] init] ;
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from WarehouseTB where wareHouseID = '%d'", wareHouseID]];
        
        while ([rs next])
        {
            wareHouse.idWarehouse = [rs intForColumn:@"wareHouseID"] ;
            wareHouse.name        = [rs stringForColumn:@"name"] ;
            wareHouse.url         = [rs stringForColumn:@"url"] ;
            wareHouse.content     = [rs stringForColumn:@"content"] ;
        }
        
        return wareHouse ;
    }

}


- (WareHouse *)getWarehouseWithName:(NSString *)name
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
            return nil;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return nil;
        }
        
        WareHouse *wareHouse = [[WareHouse alloc] init] ;
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from WarehouseTB where name = '%@'", name]];
        
        while ([rs next])
        {
            wareHouse.idWarehouse = [rs intForColumn:@"wareHouseID"] ;
            wareHouse.name        = [rs stringForColumn:@"name"] ;
            wareHouse.url         = [rs stringForColumn:@"url"] ;
            wareHouse.content     = [rs stringForColumn:@"content"] ;
        }
        
        return wareHouse ;
    }
}



- (NSMutableArray *)getAllWarehouse
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
            return nil;
        }
        
        [DB setShouldCacheStatements:YES];
        
        if(![DB tableExists:TABLENAME])
        {
            return nil;
        }
        
        NSMutableArray *tempList = [NSMutableArray array] ;
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from WarehouseTB"]];
        
        while ([rs next])
        {
            WareHouse *wareHouse = [[WareHouse alloc] init] ;

            wareHouse.idWarehouse = [rs intForColumn:@"wareHouseID"] ;
            wareHouse.name        = [rs stringForColumn:@"name"] ;
            wareHouse.url         = [rs stringForColumn:@"url"] ;
            wareHouse.content     = [rs stringForColumn:@"content"] ;
            
            [tempList addObject:wareHouse] ;
        }
        
        return tempList ;
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
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM WarehouseTB"]];
        
        int myCount = 0 ;
        
        while ([rs next])
        {
            myCount = [rs intForColumn:@"COUNT(*)"] ;
        }
        
        //暂时 两家
        //美国亚马逊
        //自营
        if (myCount > 0)
        {
            return YES   ;
        }
        else
        {
            return NO  ;
        }
    }
}






@end
