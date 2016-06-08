//
//  salesCatagory.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "SalesCatagory.h"
#import "CategoryTB.h"
#import "ServerRequest.h"

@implementation SalesCatagory

- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    if (self) {
        self.id_ = [[diction objectForKey:@"id"] integerValue] ;
        self.parent_id = [[diction objectForKey:@"parent_id"] intValue] ;
        self.name = [diction objectForKey:@"name"] ;
        self.remark = [diction objectForKey:@"remark"] ;
        
    }
    return self;
}

- (instancetype)initWithCata:(SalesCatagory *)cata
{
    self = [super init];
    if (self)
    {
        self.id_ = cata.id_ ;
        self.parent_id = cata.parent_id ;
        self.name = cata.name ;
        self.remark = cata.remark ;
    }
    return self;
}


+ (void)setupCataIfNeeded
{
    if ([[CategoryTB shareInstance] hasInDB]) {
        return ;
    }
    
    NSArray *array = [ServerRequest getAllCataTB] ;
    int num = 0 ;
    for (NSDictionary *dic in array)
    {
        SalesCatagory *catag1 = [[SalesCatagory alloc] initWithDic:dic] ;
        [[CategoryTB shareInstance] insertCategory:catag1] ;
        num ++ ;
    }
    
    NSLog(@"num cate : %d",num) ;
}

@end
