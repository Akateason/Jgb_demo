//
//  CheckPrice.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CheckPrice.h"
#import "ServerRequest.h"
#import "NSObject+MKBlockTimer.h"
#import <AKATeasonFramework/AKATeasonFramework.h>


@implementation CheckPrice

- (instancetype)initWithDic:(NSDictionary *)diction
{
    self = [super init];
    if (self)
    {
        self.sellerID       = [[diction objectForKey:@"seller_id"] intValue] ;
        
        self.pid            = [diction objectForKey:@"code"] ;
        self.buyStatus      = [[diction objectForKey:@"buy_status"] intValue] ;
        self.ts             = [[diction objectForKey:@"ts"] longLongValue] ;
        self.stock          = [[diction objectForKey:@"stock"] intValue] ;
        
        if ([[diction objectForKey:@"type"] isKindOfClass:[NSNull class]]) {
            self.type           = @[] ;
        }else {
            self.type           = [diction objectForKey:@"type"] ;
        }
        
        if (![[diction objectForKey:@"actual_price"] isKindOfClass:[NSNull class]])
        {
            self.actual_price = [[diction objectForKey:@"actual_price"] floatValue] ;
        }
        
        
        self.promotiom      = [[Promotiom alloc] initWithDic:[diction objectForKey:@"promotiom"]] ;
        self.galleries      = [diction objectForKey:@"galleries"] ;
        

        if ([[diction objectForKey:@"attr"] isKindOfClass:[NSNull class]]) {
            self.attr           = nil ;
        }else {
            self.attr           = [diction objectForKey:@"attr"] ;
        }
        
        
        self.title          = [diction objectForKey:@"title"] ;
        
        
        self.usaPrice       = [[diction objectForKey:@"price"] floatValue] ;
        
        if ( ![[diction objectForKey:@"rmb_price"] isKindOfClass:[NSNull class]] )
        {
            self.rmbPrice = [[diction objectForKey:@"rmb_price"] floatValue] ;
        }
        
        
        self.noteinfo       = [diction objectForKey:@"note"] ;
    }
    
    return self;
}



+ (NSArray *)onceCheckWithList:(NSArray *)productList
{
    NSMutableArray *checkPriceList = [NSMutableArray array] ;

    NSArray *checkArray = [ServerRequest checkPriceWithList:productList] ;
    
    for (NSDictionary *dic in checkArray)
    {
        CheckPrice *checkPrice = [[CheckPrice alloc] initWithDic:dic]    ;
        [checkPriceList addObject:checkPrice] ;
    }

    return checkPriceList ;
}


+ (NSArray *)funcCheckPriceWithList:(NSArray *)productList
{
    NSMutableArray *checkPriceList = [NSMutableArray array] ;
    
    float secSum = 0.0f ;
    
    __block BOOL bOpen = YES ;
    
    while (bOpen)
    {
        [checkPriceList removeAllObjects] ;
        
        __block BOOL bOK = YES ;
        
        __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
            
            NSArray *checkArray = [ServerRequest checkPriceWithList:productList] ;
            for (NSDictionary *dic in checkArray)
            {
                CheckPrice *checkPrice = [[CheckPrice alloc] initWithDic:dic]    ;
                [checkPriceList addObject:checkPrice] ;
                
                bool bHasMustCheck = NO ;
                for (NSString *strSellerNeedCheck in [DigitInformation shareInstance].g_checkPriceSellerList)
                {
                    int sellerIDNeedCheck = [strSellerNeedCheck intValue] ;
                    if (checkPrice.sellerID == sellerIDNeedCheck)
                    {
                        bHasMustCheck = YES ;
                        break ;
                    }
                }
                if (!bHasMustCheck) continue;     //不需要核价的商家, 直接跳过
                
                long long tickNow = [MyTick getTickWithDate:[NSDate date]] ;
                
                //NSLog(@"tickNow - checkPrice.ts : %lld",tickNow - checkPrice.ts)    ;
                //NSLog(@"G_AUTHORIZATION_TIME    : %ld",G_AUTHORIZATION_TIME)        ;
                
                if (tickNow - checkPrice.ts > G_AUTHORIZATION_TIME )    //是否核价过, 在时间范围内?
                {
                    bOK = NO ;
                }
            }
            
            bOpen = ( !bOK ) ? YES : NO ;
            
            sleep(MIN_SENDFLEX)         ;                  //  休息几秒钟
            
        } withPrefix:@"result time"]    ;
        
        float sec = seconds / 1000.0f   ;
        
        secSum += sec ;
        
        //核价  溢出时间
        if (secSum >= MAX_OVERFLOW)
        {
            bOpen = NO ;
        }
        
        NSLog(@"secSum : %f",secSum) ;
    }
    
    return checkPriceList ;
}


// 购物车 钩子是否能勾上
- (BOOL)checkBoxCanSelected         //WithAuthorizationtime:(int)authorizationTime ;
{
    // judge ? 是否通过核价 ? 通过:能勾上, 未通过:不能勾上
//    long long tickNow = [MyTick getTickWithDate:[NSDate date]] ;
    
//    NSLog(@"ts %lld",((ShopCarGood *)[arr objectAtIndex:r]).checkPrice.ts) ;
//    NSLog(@"-  %lld",tickNow - ((ShopCarGood *)[arr objectAtIndex:r]).checkPrice.ts) ;
    
    BOOL bCanSelected = NO ;
    
    if (self.buyStatus )  //判断buystatus即可 , 能不能买
    {
        bCanSelected = YES ;
    }

    
    return bCanSelected ;
}


//是否需要再核价
+ (BOOL)isNeedCheckPriceWithShopCarList:(NSArray *)shopcartList
{
    BOOL bNeed = NO ;
    
    for (ShopCarGood *shopCart in shopcartList)
    {
        bool bHasMustCheck = NO ;
        for (NSString *strSellerNeedCheck in [DigitInformation shareInstance].g_checkPriceSellerList) {
            int sellerIDNeedCheck = [strSellerNeedCheck intValue] ;
            if (shopCart.bid == sellerIDNeedCheck) {
                bHasMustCheck = YES ;
                break ;
            }
        }
        if (!bHasMustCheck) continue ;     //不需要核价的商家, 直接跳过
        
//      if (!shopCart.buyStatus) bNeed = YES ;                               //buyStatus只是判断能不能买, 不是判断核价不核价
        
        long long tickNow = [MyTick getTickWithDate:[NSDate date]]      ;
        
        NSLog(@"G_AUTHORIZATION_TIME  : %ld",G_AUTHORIZATION_TIME) ;
        NSLog(@"tickNow - shopCart.ts : %lld",(tickNow - shopCart.ts) ) ;
        if ( tickNow - shopCart.ts > G_AUTHORIZATION_TIME ) bNeed = YES ;
    }
    
    return bNeed ;
}


//获取 永远不能通过核价的 购物车 cid list
+ (NSMutableArray *)getNeverCheckeFinishedProductsCidList:(NSArray *)shopcartList
{
    NSMutableArray *tempCidList = [NSMutableArray array] ;
    
    for (ShopCarGood *shopCart in shopcartList)
    {
        bool bHasMustCheck = NO ;
        for (NSString *strSellerNeedCheck in [DigitInformation shareInstance].g_checkPriceSellerList) {
            int sellerIDNeedCheck = [strSellerNeedCheck intValue] ;
            if (shopCart.bid == sellerIDNeedCheck) {
                bHasMustCheck = YES ;
                break ;
            }
        }
        if (!bHasMustCheck) continue ;     //不需要核价的商家, 直接跳过
        
        
        long long tickNow = [MyTick getTickWithDate:[NSDate date]]      ;
        
        if ( tickNow - shopCart.ts > G_AUTHORIZATION_TIME )
        {
            NSNumber *cidNumber = [NSNumber numberWithInt:shopCart.cid] ;
            [tempCidList addObject:cidNumber] ;
        }
    }
    
    return tempCidList ;
}


//能否购买
+ (BOOL)isCanBuyWithShopCarList:(NSArray *)shopcartList
{
    BOOL bCanBuy = YES ;
    
    for (ShopCarGood *shopCart in shopcartList)
    {
        bCanBuy = shopCart.buyStatus ;                                        //buyStatus 只是判断能不能买,
    }
    
    return bCanBuy ;
}

@end
