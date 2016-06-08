//
//  Brand.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brand : NSObject

//"id": "63",
//"f": "A",
//"brandName": "Aptamil/英国爱他美/",
//"description": null,
//"ishot": "0",
//"category": "0",
//"chinesename": "",
//"anothername": "",
//"brandId": "4292",
//"cateId": "101"

@property (nonatomic)      int       id_            ;
@property (nonatomic,copy) NSString  *f             ;
@property (nonatomic,copy) NSString  *brandName     ;
@property (nonatomic,copy) NSString  *description_  ;
@property (nonatomic)      int       ishot          ;
@property (nonatomic,copy) NSString  *category      ;
@property (nonatomic,copy) NSString  *chinesename   ;
@property (nonatomic,copy) NSString  *anothername   ;
@property (nonatomic)      int       brandId        ;
@property (nonatomic)      int       cateId         ;



- (instancetype)initWithDic:(NSDictionary *)dic ;




@end
