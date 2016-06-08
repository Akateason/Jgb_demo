//
//  ShopCarGood.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-24.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ShopCarGood.h"
#import "ServerRequest.h"
#import "YXSpritesLoadingView.h"


@implementation ShopCarGood

static ShopCarGood *instance;

+ (ShopCarGood *)shareInstance
{
    if (instance == nil) {
        instance = [[[self class] alloc] init];
    }
    
    return instance;
}



- (instancetype)initWithDiction:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        //
        _ts = [[dic objectForKey:@"ts"] longLongValue] ;
        
        _buyStatus = [[dic objectForKey:@"buy_status"] boolValue] ;
        //
        _is_bitcoin = [[dic objectForKey:@"is_bitcoin"] boolValue] ;
        //
        _jcode = [dic objectForKey:@"jcode"] ;
        
        //
        _cid = [[dic objectForKey:@"cid"] intValue] ;
        _bid = [[dic objectForKey:@"bid"] intValue] ;
        _pid = [dic objectForKey:@"pid"]            ;
    
        _weight = [[dic objectForKey:@"weight"] floatValue] ;
        _nums   = [[dic objectForKey:@"nums"] intValue] ;
        _total_prices = [[dic objectForKey:@"total_prices"] floatValue] ;
        _total_weight = [[dic objectForKey:@"total_weight"] floatValue] ;
        _date = [[dic objectForKey:@"date"] longLongValue] ;
        
        _isSelectedInShopCar = NO ;
        
        _price = [[dic objectForKey:@"prices"] floatValue] ;
        
        
        if ([[dic objectForKey:@"guige"] isKindOfClass:[NSDictionary class]])
        {
            _guige  = [dic objectForKey:@"guige"] ;
            
            NSString *tempStr = @"" ;
            NSArray *allkeys = [_guige allKeys] ;
            for (NSString *theKey in allkeys)
            {
                NSString *thrStr = [NSString stringWithFormat:@"%@:%@ ",theKey,[_guige objectForKey:theKey]] ;
                tempStr = [tempStr stringByAppendingString:thrStr]  ;
            }
            _feature = tempStr ;
        }
        else
        {
            _guige = nil ;
            
            _feature = @"" ;
        }
        
        if (! [[dic objectForKey:@"title"] isKindOfClass:[NSNull class]])
        {
            _title  = [dic objectForKey:@"title"] ;
        }
        
        _images = [dic objectForKey:@"images"] ;
        _sku    = [dic objectForKey:@"sku"] ;
        
        _good   = [[Goods alloc] initWithDic:[dic objectForKey:@"product"]] ;

    }
    
    return self;
}

#pragma mark --
#pragma mark - Setter
- (void)setCheckPrice:(CheckPrice *)checkPrice
{
    _price = checkPrice.rmbPrice ;
    
    Goods *agood = [[Goods alloc] init] ;
    agood.code   = checkPrice.pid ;
    agood.stock_count = checkPrice.stock ;
    agood.type   = checkPrice.type ;
    agood.galleries = checkPrice.galleries ;
    agood.actual_price = checkPrice.actual_price ;
    agood.promotiom = checkPrice.promotiom ;
    agood.attr = checkPrice.attr ;
    agood.title = checkPrice.title ;
    
    _good = agood ;
    _checkPrice = checkPrice ;
    
    //20150108 ADD
    _ts             = checkPrice.ts;
    _buyStatus      = checkPrice.buyStatus ;
    
    self.isLoseEfficient = !_buyStatus ;
}

- (void)setIsLoseEfficient:(bool)isLoseEfficient
{
    _isLoseEfficient = isLoseEfficient ;
    
    if (isLoseEfficient)
    {   //若失效, 则不能选中
        self.isSelectedInShopCar = NO ;
    }
}



#pragma mark --

+ (void)getShopCartCount
{
    dispatch_queue_t queue = dispatch_queue_create("getCartCountQueue", NULL) ;
    dispatch_async(queue, ^{
        NSDictionary *cartInfoDic   = [ServerRequest getCartCount]                      ;
        
        
        G_SHOP_CAR_COUNT            = [[cartInfoDic objectForKey:@"count"] intValue]    ;
        G_SHOP_CAR_NUM              = [[cartInfoDic objectForKey:@"number"] intValue]   ;

    }) ;
    
}


- (void)imidiatelyBuyNowWithGood:(Goods *)good AndWithNums:(int)number
{

    // 已登录, 判断商家来源
//    if ( (good.seller_id != -1) && (good.seller_id != 0) )
    if ( 1 )
    {
        
        __block BOOL            bHas = NO   ;
        __block int             cid  = 0    ;
        __block NSDictionary    *dictionary ;
        
        [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
        [DigitInformation showHudWhileExecutingBlock:^{
            
            NSDictionary *dataDic       = [ServerRequest showShopCars]      ;
            NSDictionary *productDic    = [dataDic objectForKey:@"product"] ;
            
            NSArray *keyarr = [productDic allKeys] ;
            
            for (NSString *key in keyarr)
            {
                NSArray *pList = [productDic objectForKey:key] ;
                
                for (NSDictionary *pDic in pList)
                {
                    ShopCarGood *shopCar = [[ShopCarGood alloc] initWithDiction:pDic] ;
                    if ([shopCar.sku isEqualToString:good.code])
                    {
                        bHas = YES ;
                        cid  = shopCar.cid ;
                    }
                }
            }
            
            NSArray *cidList = [NSArray array] ;
            
            if (!bHas)
            {
                // not exist cart num
                //1 . add into cart and checkout
                ResultPasel *result = [ServerRequest add2ShopCarWithProductID:good.code AndWithNums:number] ;
                if (result.code == 200) {
                    //加入购物车成功
                    cid = [[result.data objectForKey:@"cid"] intValue] ;
                }
                else {
                    //加入购物车失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [DigitInformation showWordHudWithTitle:result.info] ;
                        
                    }) ;

                    return ;
                }
            }
            
            NSNumber *number = [NSNumber numberWithInt:cid] ;
            cidList = @[number] ;
            
            //判断是否需要核价
            [CheckPrice onceCheckWithList:@[good.code]] ;
            
            //提交订单
            dictionary  = [ServerRequest getCheckOutListWithCidList:cidList]   ;

        } AndComplete:^{
            
            [YXSpritesLoadingView dismiss] ;
            
            if ( ([[dictionary objectForKey:@"code"] intValue] == 200) && cid )
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.delegate goToCheckOutViewCallBackWithDic:dictionary] ;
                    
                }) ;
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSString *info = [dictionary objectForKey:@"info"] ;
                    if (info) {
                        [DigitInformation showWordHudWithTitle:info] ;
                    }
                    
                }) ;
            }
            
        } AndWithMinSec:0] ;
        
    }
//    else
//    {
//        NSLog(@"该商品来自亚马逊第三方,暂时不能购买哦~") ;
//        // 不是亚马逊和自营,不能加入购物车
//        [DigitInformation showWordHudWithTitle:WD_HUD_NOT_SELL_BY_US] ;
//    }
//    
}



- (void)addToShopCarWithGoods:(Goods *)good AndWithNumber:(int)buyNumber
{
    // 已登录, 判断商家来源
//    if ( (good.seller_id != -1) && (good.seller_id != 0) )
    if ( 1 )
    {
        
        __block ResultPasel *result ;
        
        [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:YES] ;
        [DigitInformation showHudWhileExecutingBlock:^{
            
            // 能够加入
            result = [ServerRequest add2ShopCarWithProductID:good.code AndWithNums:buyNumber] ; //code不用传, num要传来

        } AndComplete:^{
            
            [YXSpritesLoadingView dismiss] ;
            
            if (result.code == 200) {
                //  加入购物车成功
                int cid = [[result.data objectForKey:@"cid"] intValue] ;
                
                NSLog(@"加入购物车成功 : %d",cid) ;
                
                [ShopCarGood getShopCartCount] ;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate addToShopCarSuccessCallBack] ;
                }) ;
            }
            else {
                //  加入购物车失败
                NSLog(@"加入购物车失败 info : result.info") ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DigitInformation showWordHudWithTitle:result.info] ;
                }) ;
            }
            
            if (!result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK] ;
                }) ;
            }

        } AndWithMinSec:0] ;
        
    }
//    else
//    {
//        NSLog(@"该商品来自亚马逊第三方,暂时不能购买哦~") ;
//        // 不是亚马逊和自营,不能加入购物车
//        [DigitInformation showWordHudWithTitle:WD_HUD_NOT_SELL_BY_US] ;
//    }
}




// 获取购物车list , 参数, 全部或者选中的
+ (NSMutableArray *)getShopCartListWithAllOrSelected:(BOOL)bAllOrSelected
                                    AndWithDataSouce:(NSMutableDictionary *)dicDataSource
                                     AndWithKeyArray:(NSMutableArray *)keyArray
{
    NSMutableArray *tempShopCarList = [NSMutableArray array] ;
    
    for (int sec = 0; sec < keyArray.count; sec ++)
    {
        NSString *key = ((Seller *)[keyArray objectAtIndex:sec]).name ;
        NSMutableArray *arr = (NSMutableArray *)[dicDataSource objectForKey:key] ;
        
        for (int r = 0 ; r < arr.count; r ++)
        {
            ShopCarGood *shopCarG = ((ShopCarGood *)[arr objectAtIndex:r]) ;
            
            if (bAllOrSelected) {
                //全部
                [tempShopCarList addObject:shopCarG] ;
            } else {
                //仅选中
                //是否需要核价, 当前商家商品, 仅选中的商品
                if (shopCarG.isSelectedInShopCar)
                {
                    [tempShopCarList addObject:shopCarG] ;
                }
            }
        }
    }

    
    return tempShopCarList ;
}





@end
