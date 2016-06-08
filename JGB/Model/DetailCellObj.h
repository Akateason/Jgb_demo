//
//  DetailCellObj.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-10.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//


//chinese keys
#define KEYS_PRO_PRICE          @"商品售价:"
#define KEYS_INSICE_FREIGHT     @"境内运费:"
#define KEYS_NATIONAL_FREIGHT   @"国际运费:"
#define KEYS_TAX                @"关税:"
#define KEYS_HELP_BUY           @"代购费:"
#define KEYS_COUPSONS           @"优惠券:"
#define KEYS_POINTS             @"积分抵扣:"
#define KEYS_ALLPRICE           @"合计:"

#define KEYS_PRIVIGE_FREIGHT    @"运费优惠:"


#import <Foundation/Foundation.h>
#import "CheckOut.h"
#import "OrderInfo.h"
#import "Goods.h"

/******
 *
 *  DetailCellObj 处理展开 cell中的数据
 *
 ******/
@interface DetailCellObj : NSObject

@property (nonatomic)           int             order           ;       //顺序
@property (nonatomic,copy)      NSString        *keyChinese     ;       //中文标题
@property (nonatomic,copy)      NSString        *valDescrip     ;       //详情
@property (nonatomic)           float           price           ;       //价格


// Initial
- (instancetype)initWithKey:(NSString *)key AndWithPrice:(float)price AndWithOrder:(int)order ;

/*
 *  good detail 中
 *  价格详情
 *  get obj list with good detail
 */
- (NSMutableArray *)getObjListWithGoodDetail:(Goods *)good ;


/*
 *  order confirm 中
 *  价格详情
 *  get obj list with checkout ---- in order / confirm
 */
- (NSArray *)getObjListWithCheckOut:(CheckOut *)checkout ;

/*
 *  订单详情中
 *  价格详情
 */
- (NSArray *)getObjListWithOrderInfo:(OrderInfo *)orderinfo ;



@end
