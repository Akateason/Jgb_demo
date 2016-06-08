//
//  SellerTB.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "DigitInformation.h"
#import "Seller.h"

@interface SellerTB : NSObject

+ (SellerTB *)shareInstance ;

- (BOOL)creatTable;

- (BOOL)insertSeller:(Seller *)seller;


- (void)deleteAll ;

- (Seller *)getSellerWithSellerID:(int)sellerID ;

- (Seller *)getSellerWithName:(NSString *)name ;



- (BOOL)hasInDB ;



@end
