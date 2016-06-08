//
//  Seller.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>


//单个卖家, 供应商

@interface Seller : NSObject

@property (nonatomic,copy) NSString *name       ;           //买家名称
@property (nonatomic,copy) NSString *logo       ;           //logo img
@property (nonatomic,copy) NSString *seller_id  ;           //seller id


//@property (nonatomic,retain)NSArray *sell       ;           //[35,美国amazon.com]
//@property (nonatomic,copy) NSString *product_path ;

@property (nonatomic)   int bid ;   //seller id 

- (instancetype)initWithDic:(NSDictionary *)dic ;
- (instancetype)init ;
- (instancetype)initLoseEfficientSeller ;


@end
