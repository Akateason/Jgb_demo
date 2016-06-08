//
//  Select_val.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Select_val.h"

@implementation Select_val

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
//    NSLog(@"Select_val : %@", dic) ;
    
    self = [super init] ;
    
    if (self) {
        //  priceAreaArray
        NSDictionary *priceArray = [dic objectForKey:@"price_area"] ;
        NSArray *allkeys_price = [priceArray allKeys] ;
        NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:2] ;
        for (int i = 1; i <= allkeys_price.count; i++)
        {
            NSDictionary *dic = [priceArray objectForKey:[NSString stringWithFormat:@"%d",i]] ;
            Price_area *priceArea = [[Price_area alloc] initWithDiction:dic] ;
            [array1 addObject:priceArea] ;
        }
        self.priceAreaArray = array1 ;
        //  sellersArray
        NSDictionary *sellerDiction = [dic objectForKey:@"sellers"] ;
        NSArray *sellerArray = [sellerDiction allValues] ;
        NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:1] ;
        
        for (int i = 0; i < sellerArray.count; i++)
        {
            Seller *seller = [[Seller alloc] initWithDic:(NSDictionary *)[sellerArray objectAtIndex:i]] ;
            if (seller != nil) [array2 addObject:seller] ;
        }
        self.sellersArray = array2 ;
        //  salesCatagoryArray
        NSArray *cateArray = [dic objectForKey:@"categorys"] ;
        if (![cateArray isKindOfClass:[NSNull class]]) {
            NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:5] ;
            for (int i = 0; i < cateArray.count; i++)
            {
                SalesCatagory *cata = [[SalesCatagory alloc] initWithDic:(NSDictionary *)[cateArray objectAtIndex:i]] ;
                [array3 addObject:cata] ;
            }
//            self.salesCatagoryArray = array3 ;
        } else {
//            self.salesCatagoryArray = [NSMutableArray array] ;
        }
        
       
        
        //  hot brand array
        NSMutableArray *hotList = [NSMutableArray array] ;
        NSArray *hotArr = [dic objectForKey:@"hotbrand"] ;
        if (![hotArr isKindOfClass:[NSNull class]])
        {
            for (int i = 0; i < hotArr.count; i++)
            {
                Brand *brand = [[Brand alloc] initWithDic:[hotArr objectAtIndex:i]] ;
                [hotList addObject:brand]                                           ;
            }
            self.hotBrandArray = hotList ;
        }
        
        //  current index initial < 0
//        self.currentCatagory    = -1 ;
        self.currentPriceArea   = -1 ;
        self.currentSellers     = -1 ;
        self.currentBrandSTR    = @"";
        
//        self.cataStrCache       = @"";
        
        self.isChinese          = NO ;
        self.isOnSales          = NO ;
    }
    
    return self;
}


- (instancetype)initWithSelectVal:(Select_val *)selectVal
{
    self = [super init] ;
    
    if (self)
    {
        self.currentPriceArea   = selectVal.currentPriceArea ;
        self.currentSellers     = selectVal.currentSellers ;
        self.currentBrandSTR    = selectVal.currentBrandSTR ;
        
        self.isChinese          = selectVal.isChinese ;
        self.isOnSales          = selectVal.isOnSales ;
    }
    
    return self;

}



@end
