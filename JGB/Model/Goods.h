//
//  Goods.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Promotiom.h"
#import "Seller.h"
#import "CheckPrice.h"

//商品

@interface Goods : NSObject

@property (nonatomic,copy)      NSString    *jcode ;           //jgb.cn 后面拼得code

@property (nonatomic,copy)      NSString    *code  ;           //产品的code           **
@property (nonatomic,copy)      NSString    *sku   ;           //亚马逊产品code
@property (nonatomic,assign)    int         rating ;           //评价等级
@property (nonatomic,assign)    int         seller_id ;        //发货商id买家id
@property (nonatomic,copy)      NSString    *brand_name ;      //品牌名
@property (nonatomic,assign)    float       list_price ;       //市场价

@property (nonatomic,assign)    float       price_max ;        //最高价美元
@property (nonatomic,assign)    float       price_min ;        //最低价美元

@property (nonatomic,assign)    float       rmb_max_price ;    //最高价中元
@property (nonatomic,assign)    float       rmb_min_price ;    //最低价中元


@property (nonatomic,assign)    float       price ;            //价
@property (nonatomic,assign)    int         rating_count ;     //评价总数
@property (nonatomic,copy)      NSString    *last_updated ;    //最后更新时间
@property (nonatomic,copy)      NSString    *category   ;      //分类       形如"106,1011"
@property (nonatomic,retain)    NSArray     *galleries  ;      //图片
@property (nonatomic,assign)    float       weight      ;      //重量
@property (nonatomic,assign)    int         is_cn       ;      //是否有中文
@property (nonatomic,copy)      NSString    *title      ;      //title
@property (nonatomic,copy)      NSString    *feature_cn ;      //特征, cn


@property (nonatomic,assign)    float       rmb_price  ;       //人名币显示的价格
@property (nonatomic,assign)    float       discount_price;    //商品的差价
@property (nonatomic,assign)    float       list_actual_price; //商品的差价含运费

//  20150120 UPDATE BEGIN
@property (nonatomic,assign)    float       actual_price ;     //到手价
//  20150120 UPDATE END

@property (nonatomic,retain)    Promotiom   *promotiom ;       //优惠
@property (nonatomic,retain)    Seller      *seller ;          //卖家商家


@property (nonatomic,copy)      NSString    *descriptionHtml ; //描述 eng     //descriptionHtml
@property (nonatomic,copy)      NSString    *description_cn ;  //中文描述
@property (nonatomic,retain)    NSArray     *feature ;         //特征 eng
@property (nonatomic,assign)    int         stock_count ;      //库存
@property (nonatomic,copy)      NSString    *title_cn ;        //中文标题
@property (nonatomic,copy)      NSString    *title_en ;        //E文标题
@property (nonatomic,retain)    NSArray     *images ;          //图片们

@property (nonatomic,retain)    NSArray     *type ;            //addon, prime


/*
 * 可能根本没有这几个key
 */
@property (nonatomic,retain)    NSDictionary *attr ;           //当前的属性啊
@property (nonatomic,retain)    NSDictionary *attribute ;      //所有属性(供选择)
@property (nonatomic,retain)    NSDictionary *links ;          //所有配对的商品

@property (nonatomic)           BOOL          buyStatus ;

// ADD 20150106 BEGIN @TEA
@property (nonatomic)           float        seller_freight ;  //价格详情，卖家运费，亚马逊就是美国境内运费（字体背景为一种颜色是一组数据）
@property (nonatomic)           float        freight ;         //价格详情，国际运费
@property (nonatomic)           NSString     *revenue ;        //价格详情，关税
@property (nonatomic)           float        service_charge ;  //价格详情，代购费
// ADD 20150106 END   @TEA

// ADD 20150301 BEGIN   @TEA
@property (nonatomic,copy)      NSString     *official ;       //美亚原网址链接
// ADD 20150301 END     @TEA

@property (nonatomic,copy)      NSArray      *vod  ;            //视频


@property (nonatomic)           int          warehouse_id ;    //仓库id

@property (nonatomic)           int          shelves ;      //是否上架, 0表示下家 ;

@property (nonatomic,copy)      NSString     *size_url ;     //尺码说明链接

- (instancetype)initWithDic:(NSDictionary *)dic        ;


//核价更新商品
- (void)checkingPrice:(CheckPrice *)checkPrice         ;

@end


