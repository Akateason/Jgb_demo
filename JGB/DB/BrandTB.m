//
//  BrandTB.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-19.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//



#define TABLENAME           @"BrandTB"

#define SQL_CREATETABLE     @"create table BrandTB (id INT  NOT NULL DEFAULT '0', f Nvarchar(2) NOT NULL DEFAULT '0', brandName Nvarchar(128) DEFAULT'' NOT NULL, description Nvarchar(256) NOT NULL DEFAULT '', ishot INT DEFAULT '0' NOT NULL, category Nvarchar(30) DEFAULT '' NOT NULL, chinesename Nvarchar(50) DEFAULT '' NOT NULL,anothername Nvarchar(50) DEFAULT '' NOT NULL,  brandId INT DEFAULT '0' NOT NULL, cateId INT DEFAULT '0' NOT NULL ,primary key (id,cateId) )"

#define SQL_INSERTTABLE     @"INSERT INTO BrandTB (id , f , brandName  , description , ishot , category , chinesename ,anothername , brandId  , cateId  ) VALUES (?,?,?,?,?,?,?,?,?,?)"





#import "BrandTB.h"

@implementation BrandTB

static BrandTB *instance;

+ (BrandTB *)shareInstance
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


- (BOOL)insertBrand:(Brand *)brand
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
             [NSString stringWithFormat:@"%d",brand.id_],
             brand.f,
             brand.brandName,
             brand.description,
             [NSString stringWithFormat:@"%d",brand.ishot],
             brand.category,
             brand.chinesename,
             brand.anothername,
             [NSString stringWithFormat:@"%d",brand.brandId],
             [NSString stringWithFormat:@"%d",brand.cateId]
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
        [DB executeUpdate:@"delete from BrandTB"];
        
    }
}


- (NSMutableArray *)getAllWithFirstLetter:(NSString *)firstLetter
                           AndWithCateNum:(int)cateNum
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
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from BrandTB where f = '%@' and cateId = '%d'",firstLetter,cateNum]];
        
        while ([rs next])
        {
            Brand *brand = [[Brand alloc] init] ;
            
            brand.id_ = [rs intForColumn:@"id"];
            brand.f   = [rs stringForColumn:@"f"];
            brand.brandName = [rs stringForColumn:@"brandName"];
            brand.description_ = [rs stringForColumn:@"description"];
            brand.ishot = [rs intForColumn:@"ishot"];
            brand.category = [rs stringForColumn:@"category"];
            brand.chinesename = [rs stringForColumn:@"chinesename"];
            brand.anothername = [rs stringForColumn:@"anothername"];
            brand.brandId = [rs intForColumn:@"brandId"];
            brand.cateId = [rs intForColumn:@"cateId"];
            
            [Array addObject:brand];
        }
        
        return Array ;
    }
}

- (BOOL)isNeedDownLoad
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
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM BrandTB "]];
        
        int myCount = 0 ;

        
        while ([rs next])
        {
            myCount = [rs intForColumn:@"COUNT(*)"] ;
        }
        //线上66条数据
        if (myCount > 170) {
            return NO ;
        }else {
            return YES  ;
        }
    
    }
}


@end
