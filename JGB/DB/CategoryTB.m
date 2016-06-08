//
//  CategoryTB.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//



#define TABLENAME           @"CategoryTB"

#define SQL_CREATETABLE     @"create table CategoryTB (id INT primary key NOT NULL DEFAULT '0', parent_id INT NOT NULL DEFAULT'0', name Nvarchar(40) NOT NULL DEFAULT '' , remark  Nvarchar(256) NOT NULL DEFAULT '' ) "

#define SQL_INSERTTABLE     @"INSERT INTO CategoryTB (id, parent_id , name , remark ) VALUES (?,?,?,?)"



#import "CategoryTB.h"

@implementation CategoryTB



static CategoryTB *instance;

+ (CategoryTB *)shareInstance
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


//


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


- (BOOL)insertCategory:(SalesCatagory *)cata
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
             [NSString stringWithFormat:@"%d",cata.id_],
             [NSString stringWithFormat:@"%d",cata.parent_id],
             cata.name,
             cata.remark
            ];
        
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
        [DB executeUpdate:@"delete from CategoryTB"];
        
    }
}


- (NSMutableArray *)getAllWithParentId:(int)parentID
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
        
        NSMutableArray *Array = [[NSMutableArray alloc] initWithArray:0];

        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from CategoryTB where parent_id = '%d' " , parentID]];
        
        while ([rs next])
        {
            SalesCatagory *cate = [[SalesCatagory alloc] init] ;
            cate.id_ = [rs intForColumn:@"id"] ;
            cate.parent_id = [rs intForColumn:@"parent_id"] ;
            cate.name = [rs stringForColumn:@"name"] ;
            cate.remark = [rs stringForColumn:@"remark"] ;
            
            [Array addObject:cate];
        }
        
        return Array ;
    }
}

- (SalesCatagory *)getCataWithCataID:(int)cataID
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
        
        SalesCatagory *cate = [[SalesCatagory alloc] init] ;

        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from CategoryTB where id = '%d' " , cataID]];
        
        while ([rs next])
        {
            cate.id_ = [rs intForColumn:@"id"] ;
            cate.parent_id = [rs intForColumn:@"parent_id"] ;
            cate.name = [rs stringForColumn:@"name"] ;
            cate.remark = [rs stringForColumn:@"remark"] ;
            
        }
        
        return cate ;
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
        
        //  order by searchSum desc, lastSearchTime desc limit 10
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM CategoryTB"]];
        
        int myCount = 0 ;

        while ([rs next])
        {
            myCount = [rs intForColumn:@"COUNT(*)"] ;
        }
//
        if (myCount > 0) {
            return YES ;
        }else {
            return NO  ;
        }
        
    }
}



- (void)begin
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
        [DB executeUpdate:@"BEGIN"];
        
    }
}


- (void)commit
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
        [DB executeUpdate:@"COMMIT"];
        
    }
}




@end
