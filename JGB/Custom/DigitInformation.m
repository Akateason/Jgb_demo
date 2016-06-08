





#import "DigitInformation.h"
#import "Reachability.h"
#import "YXSpritesLoadingView.h"
#import "NSObject+MKBlockTimer.h"
#import "ServerRequest.h"
#import "HotSearch.h"
#import "PayType.h"
#import "WarehouseTB.h"
#import "TagsIndex.h"

static DigitInformation *instance ;

@implementation DigitInformation


+ (DigitInformation *)shareInstance
{
    if (instance == nil) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}


#pragma mark --
#pragma mark - Setter
- (void)setG_shopCarCount:(int)g_shopCarCount
{
    _g_shopCarCount = g_shopCarCount ;
    
    [_delegate setMyTabBarItemChange] ;
}

#pragma mark --
#pragma mark - Getter




- (NSString *)g_servericeIP
{
    if (!_g_servericeIP) {
        _g_servericeIP = STR_APP_API_LOCAL ;
    }
    
    return _g_servericeIP ;
}

- (NSArray *)g_checkPriceSellerList
{
    if (!_g_checkPriceSellerList)
    {
        ResultPasel *result = [ServerRequest getCheckPriceSeller] ;
        if (result.code == 200)
        {
            NSString *resultCommaStr = (NSString *)(result.data) ;
            NSArray  *sellerArray    = [resultCommaStr componentsSeparatedByString:@","] ;
            
            _g_checkPriceSellerList  = sellerArray ;
        }
    }
    
    return _g_checkPriceSellerList ;
}


- (Configure *)g_configure
{
    if (!_g_configure)
    {
        ResultPasel *result = [ServerRequest getConfigList] ;
        if (result.code == 200)
        {
            _g_configure = [[Configure alloc] initWithDic:result.data] ;
        }
    }
    
    return _g_configure ;
}

- (NSArray *)g_wareHouseList
{
    if (!_g_wareHouseList)
    {
        NSMutableArray *templist = [NSMutableArray array] ;
        
        for (NSString *strKey in [DigitInformation shareInstance].g_configure.wareHouseDic)
        {
            int idWareHouse = [strKey intValue] ;
            
            // get mode
            NSDictionary *tempDic = [[DigitInformation shareInstance].g_configure.wareHouseDic objectForKey:strKey] ;
            WareHouse *wh = [[WareHouse alloc] initWithDic:tempDic AndWithID:idWareHouse] ;
            [[WarehouseTB shareInstance] insertWarehouse:wh] ;
            
            [templist addObject:wh] ;
        }
        
        _g_wareHouseList = templist ;
    }
    
    return _g_wareHouseList ;
}

- (NSArray *)g_hotSearchList
{
    if (!_g_hotSearchList)
    {
        NSMutableArray *tempList = [NSMutableArray array] ;
        ResultPasel *result = [ServerRequest getHotSearchList] ;
        if ( result.code == 200 )
        {
            NSArray *list = [result.data objectForKey:@"list"] ;
            
            for (NSDictionary *dic in list)
            {
                HotSearch *hotSch = [[HotSearch alloc] initWithDic:dic] ;
                [tempList addObject:hotSch] ;
            }
        }
        
        _g_hotSearchList = tempList ;
    }
    
    return _g_hotSearchList ;
}


- (NSArray *)g_payTypeList
{
    if (!_g_payTypeList)
    {
        NSMutableArray *tempList = [NSMutableArray array] ;

        for (NSDictionary *dic in [DigitInformation shareInstance].g_configure.payTypeList)
        {
            PayType *paytype = [[PayType alloc] initWithDiction:dic] ;
            [tempList addObject:paytype] ;
        }
    
        _g_payTypeList = tempList ;
    }
    
    return _g_payTypeList ;
}

- (User *)g_currentUser
{
    if (!_g_currentUser)
    {
        if (!G_TOKEN) return nil ;
        
        ResultPasel *result = [ServerRequest getMyUserInfo] ;
        if (result.code == 200)
        {
            User *memberUser = [[User alloc] initWithDictionary:(NSDictionary *)(result.data)] ;
            _g_currentUser = memberUser ;
        }
    }
    
    return _g_currentUser ;
}


- (NSArray *)g_topTagslist
{
    if (!_g_topTagslist || _g_topTagslist.count == 1)
    {
        @synchronized (_g_topTagslist)
        {
            _g_topTagslist = [NSArray array] ;
            NSMutableArray *tempArray = [NSMutableArray array] ;
            
            ResultPasel *result = [ServerRequest getTopicTags] ;
            
            NSArray *tempTagsList = [result.data objectForKey:@"tags"] ;
            
            TagsIndex *tagFirst = [[TagsIndex alloc] init] ;
            tagFirst.tag_id = 0 ;
            tagFirst.tag_name = @"全部" ;
            [tempArray addObject:tagFirst] ;
            
            for (NSDictionary *dic in tempTagsList)
            {
                TagsIndex *tagI = [[TagsIndex alloc] initWithDic:dic] ;
                [tempArray addObject:tagI] ;
            }
            
            _g_topTagslist = tempArray ;
        }
    }
    
    return _g_topTagslist ;
}

//- (NSString *)g_urlSizeGuige
//{
//    if (!_g_urlSizeGuige) {
//        ResultPasel *result = [ServerRequest getSizeType] ;
//        if (result.code == 200) {
//            _g_urlSizeGuige = [result.data objectForKey:@"content"];
//        }
//    }
//    
//    return _g_urlSizeGuige ;
//}


#pragma mark --
#pragma mark - SHOW HUD
+ (void)showWordHudWithTitle:(NSString *)title
{
    //自定义view
    if (![DigitInformation shareInstance].HUD)
    {
        [DigitInformation shareInstance].HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:[DigitInformation shareInstance].HUD];
    }
    
    [[DigitInformation shareInstance].HUD show:YES] ;
    
    //常用的设置
    [DigitInformation shareInstance].HUD.detailsLabelText = title ;
    [DigitInformation shareInstance].HUD.dimBackground = NO ;
    [DigitInformation shareInstance].HUD.mode = MBProgressHUDModeText ;
    [[DigitInformation shareInstance].HUD hide:YES afterDelay:1.95f] ;
}



+ (void)showHudWhileExecutingBlock:(dispatch_block_t)block AndComplete:(dispatch_block_t)complete AndWithMinSec:(float)sec
{

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0) ;
    dispatch_async(queue, ^{
        
        __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
            block();
        } withPrefix:@"result time"] ;
        
        float smallsec = seconds / 1000.0f ;
        if (sec > smallsec) {
            float stayTime = sec - smallsec ;
            dispatch_async(dispatch_get_main_queue(), ^() {
                sleep(stayTime) ;
                complete();
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^() {
                complete();
            });
        }
    });
}




#pragma mark --
//是否联网
+ (int) isConnectionAvailable
{
    
    int isExistenceNetwork = 0;
    Reachability *reach = [Reachability reachabilityWithHostName:@"wap.baidu.com"];
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:
        isExistenceNetwork = 0;
        NSLog(@"notReachable");
        break;
        case ReachableViaWiFi:
        isExistenceNetwork = 1;
        NSLog(@"WIFI");
        break;
        case ReachableViaWWAN:
        isExistenceNetwork = 2;
        NSLog(@"3G");
        break;
    }
    
    return isExistenceNetwork;
}



@end


