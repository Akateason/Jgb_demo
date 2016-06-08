//
//  Goods.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Goods.h"

@implementation Goods

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    
    if (self)
    {
        
        if ( [dic isKindOfClass:[NSNull class]] )
        {
            return self ;
        }
        
        if (![[dic objectForKey:@"jcode"] isKindOfClass:[NSNull class]])
        {
            self.jcode          = [dic objectForKey:@"jcode"]  ;
        }
        
        self.sku            = [dic objectForKey:@"sku"] ;
        self.rating         = [[dic objectForKey:@"rating"] intValue] ;
        self.seller_id      = [[dic objectForKey:@"seller_id"] intValue] ;
        self.code           = [dic objectForKey:@"code"] ;
        self.list_price     = [[dic objectForKey:@"list_price"] floatValue] ;
   
        if (![[dic objectForKey:@"max_price"] isKindOfClass:[NSNull class]])
        {
            self.price_max      = [[dic objectForKey:@"max_price"] floatValue] ;
        }
        
        if (![[dic objectForKey:@"min_price"] isKindOfClass:[NSNull class]]) {
            self.price_min      = [[dic objectForKey:@"min_price"] floatValue] ;
        }
        
        if (![[dic objectForKey:@"rmb_max_price"] isKindOfClass:[NSNull class]])
        {
            self.rmb_max_price  = [[dic objectForKey:@"rmb_max_price"] floatValue] ;
        }
        
        if (![[dic objectForKey:@"rmb_min_price"] isKindOfClass:[NSNull class]]) {
            self.rmb_min_price  = [[dic objectForKey:@"rmb_min_price"] floatValue] ;
        }
        
        
        self.brand_name          = [dic objectForKey:@"brand_name"] ;
        self.rating_count   = [[dic objectForKey:@"rating_count"] intValue] ;
        self.last_updated   = [dic objectForKey:@"last_updated"] ;
        
        if ([[dic objectForKey:@"category"] isKindOfClass:[NSNull class]])
        {
            self.category = @"" ;
        }
        else
        {
            self.category   = [dic objectForKey:@"category"] ;
        }
        
        if (![[dic objectForKey:@"galleries"] isKindOfClass:[NSNull class]]) {
            self.galleries      = [dic objectForKey:@"galleries"] ;
        }
        
        self.weight         = [[dic objectForKey:@"weight"] floatValue] ;
        self.is_cn          = [[dic objectForKey:@"is_cn"] intValue] ;
        self.title          = [dic objectForKey:@"title"] ;
        self.feature_cn     = [dic objectForKey:@"feature_cn"] ;
        self.price          = [[dic objectForKey:@"price"] floatValue] ;
        
        if (![[dic objectForKey:@"rmb_price"] isKindOfClass:[NSNull class]]) {
            self.rmb_price      = [[dic objectForKey:@"rmb_price"] floatValue];
        } else {
            self.rmb_price = 0 ;
        }
        self.stock_count    = [[dic objectForKey:@"stock_count"] integerValue] ;
        
        self.discount_price = [[dic objectForKey:@"discount_price"] floatValue] ;
        self.list_actual_price = [[dic objectForKey:@"list_actual_price"] floatValue] ;
        self.actual_price   = [[dic objectForKey:@"actual_price"] floatValue] ;
        
        self.seller         = [[Seller alloc]    initWithDic:[dic objectForKey:@"seller"]] ;
        
        self.descriptionHtml = [dic objectForKey:@"description"] ;  //descriptionHtml
        self.description_cn = [dic objectForKey:@"description_cn"] ;
        self.feature        = [dic objectForKey:@"feature"];
        self.title_cn       = [dic objectForKey:@"title_cn"] ;
        self.title_en       = [dic objectForKey:@"title_en"] ;
        self.images         = [dic objectForKey:@"images"] ;
        
        if (![[dic objectForKey:@"attr"] isKindOfClass:[NSNull class]]) {
            self.attr = [dic objectForKey:@"attr"] ;
        }
        
        self.attribute      = [dic objectForKey:@"attribute"] ;
        
        if (![[dic objectForKey:@"links"] isKindOfClass:[NSNull class]])
        {
            self.links = [dic objectForKey:@"links"] ;
        }
        else
        {
            self.links = nil ;
        }
        
        if ([[dic objectForKey:@"type"] isKindOfClass:[NSNull class]]) {
            self.type = @[] ;
        }else {
            self.type = [dic objectForKey:@"type"] ;
        }
        
        
        self.buyStatus       = [[dic objectForKey:@"buy_status"] intValue] ;
        
        // ADD 20150106 BEGIN @TEA
        self.seller_freight  = [[dic objectForKey:@"seller_freight"] floatValue] ;
        self.freight         = [[dic objectForKey:@"freight"] floatValue] ;
        self.revenue         = [dic objectForKey:@"revenue"] ;
        self.service_charge  = [[dic objectForKey:@"service_charge"] floatValue] ;
        // ADD 20150106 END   @TEA
        
        // ADD 20150301 BEGIN   @TEA
        if (![[dic objectForKey:@"official"] isKindOfClass:[NSNull class]]) {
            self.official        = [dic objectForKey:@"official"] ;
        }
        // ADD 20150301 BEGIN   @TEA

 
        self.warehouse_id   = [[dic objectForKey:@"warehouse_id"] intValue] ;
        
        self.shelves        = [[dic objectForKey:@"shelves"] intValue] ;
        
        self.vod            = [dic objectForKey:@"vod"] ;

        self.promotiom      = [[Promotiom alloc] initWithDic:[dic objectForKey:@"promotiom"]] ;

        self.size_url       = [dic objectForKey:@"size_url"] ;
    }
    
    return self;
}



- (void)checkingPrice:(CheckPrice *)checkPrice
{
    self.buyStatus = checkPrice.buyStatus ;
    self.stock_count = checkPrice.stock ;
    self.type = checkPrice.type ;
    self.actual_price = checkPrice.actual_price ;
    self.promotiom = checkPrice.promotiom ;
    self.galleries = checkPrice.galleries ;
    self.attr = checkPrice.attr ;
    self.title = checkPrice.title ;
    self.price = checkPrice.usaPrice ;
    self.rmb_price = checkPrice.rmbPrice ;
}

- (void)setPromotiom:(Promotiom *)promotiom
{
    _promotiom = promotiom ;
    
    if (!promotiom)
    {
        return ;
    }
    else if (promotiom.price)
    {
        _price = promotiom.price ;
        _rmb_price = promotiom.price ;
        
        _price_max = 0 ;
        _price_min = 0 ;
        _rmb_max_price = 0 ;
        _rmb_min_price = 0 ;
    }
        
}

@end
