//
//  SellerTB.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#define TABLENAME           @"SellerTB"


#define SQL_CREATETABLE     @"create table SellerTB (name Nvarchar(20) NOT NULL primary key NOT NULL DEFAULT '', logo Nvarchar(128) NOT NULL DEFAULT '', sell INT NOT NULL DEFAULT'0', product_path Nvarchar(128) NOT NULL DEFAULT '' ,seller_id INT  NOT NULL DEFAULT'0') "


#define SQL_INSERTTABLE     @"INSERT INTO SellerTB (name , logo , sell , product_path, seller_id)  VALUES (?,?,?,?,?)"



#import "SellerTB.h"

@implementation SellerTB

static SellerTB *instance;

+ (SellerTB *)shareInstance
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


- (BOOL)insertSeller:(Seller *)seller
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
             seller.name,
             seller.logo,
             @"0",
             @"",
             seller.seller_id
            ] ;
        //             [NSString stringWithFormat:@"%@",seller.sell[0]],
        //        seller.product_path,

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
        [DB executeUpdate:@"delete from SellerTB"];
        
    }
}


- (Seller *)getSellerWithSellerID:(int)sellerID
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
        
//        NSMutableArray *Array = [[NSMutableArray alloc] initWithArray:0];
        
        Seller *seller = [[Seller alloc] init] ;
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from SellerTB where seller_id = '%d'", sellerID]];

        while ([rs next])
        {
            seller.name = [rs stringForColumn:@"name"] ;
            seller.logo = [rs stringForColumn:@"logo"] ;
//            int sellNum = [rs intForColumn:@"sell"]    ;
            seller.seller_id = [NSString stringWithFormat:@"%d",[rs intForColumn:@"seller_id"]] ;
            seller.bid = [seller.seller_id intValue]   ;
            
//            seller.sell = @[[NSString stringWithFormat:@"%d",sellNum],seller.name] ;
//            seller.product_path = [rs stringForColumn:@"product_path"] ;

//            [Array addObject:seller]                  ;
        }
        
        return seller ;
    }
}


- (Seller *)getSellerWithName:(NSString *)name
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
        
        Seller *seller = [[Seller alloc] init] ;
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"select * from SellerTB where name = '%@'", name]];
        
        while ([rs next])
        {
            seller.name = [rs stringForColumn:@"name"] ;
            seller.logo = [rs stringForColumn:@"logo"] ;
//            int sellNum = [rs intForColumn:@"sell"]    ;
//            seller.sell = @[[NSString stringWithFormat:@"%d",sellNum],seller.name] ;
//            seller.product_path = [rs stringForColumn:@"product_path"] ;
            seller.seller_id = [NSString stringWithFormat:@"%d",[rs intForColumn:@"seller_id"]] ;
            seller.bid = [seller.seller_id intValue]   ;
        }
        
        return seller ;
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
        
        FMResultSet *rs = [DB executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM SellerTB"]];
        
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
            return NO    ;
        }
    }
    
}



@end
