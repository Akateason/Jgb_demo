//
//  LSCommonFunc.m
//  DigitMart
//
//  Created by  on 12/12/18.
//  Copyright (c) 2012年 Legensity. All rights reserved.
//

#import "LSCommonFunc.h"
#import "DigitInformation.h"
#import "ServerRequest.h"
#import "SBJson.h"
#import "SDImageCache.h"
#import "MyFileManager.h"


@implementation LSCommonFunc

#pragma mark -- save and login
+ (void)saveAndLoginWithResultDataDiction:(NSDictionary *)dataDic
                    AndWithViewController:(UIViewController *)contoller
                          AndWithFailInfo:(NSString *)failInfo
{
    G_TOKEN = [dataDic objectForKey:KEY_TOKEN];
    
    BOOL b = (G_TOKEN != nil) && (G_TOKEN != NULL) && (![G_TOKEN isEqualToString:@""]) ; // token is exist
    if (b)
    {
        dispatch_queue_t queue = dispatch_queue_create("saveAndLogin", NULL) ;
        dispatch_async(queue, ^{
            
            [[DigitInformation shareInstance] g_currentUser] ;
            
            NSString *homePath = NSHomeDirectory()  ;
            NSString *path = [homePath stringByAppendingPathComponent:PATH_TOKEN_SAVE] ;
            [MyFileManager archiveTheObject:G_TOKEN AndPath:path] ;
            
            NSString *lastLogPath = [homePath stringByAppendingPathComponent:PATH_LAST_TOKEN] ;
            [MyFileManager archiveTheObject:G_TOKEN AndPath:lastLogPath] ;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [contoller dismissViewControllerAnimated:YES completion:^{
                    [DigitInformation showWordHudWithTitle:WD_LOGIN_SUCCESS] ;
                }] ;
            }) ;
            
        }) ;
    }
    else
    {
        if (!failInfo) return ;
        
        [DigitInformation showWordHudWithTitle:failInfo] ;
    }
}


#pragma mark -- login H5
+ (NSString *)getUrlWhenLoginH5WithTick:(long long)tick AndWithOrgUrl:(NSString *)orgUrl
{
    ResultPasel *result = [ServerRequest getTempHashToLoginH5WithUid:[NSString stringWithFormat:@"%d",G_USER_CURRENT.uid] AndWithTime:tick] ;
    if (result.code != 200) return nil ;
    NSString *hash = [result.data objectForKey:@"hash"] ;
    NSString *resultUrlStr = [NSString stringWithFormat:@"%@?hash=%@&time=%lld&user_id=%d",orgUrl,hash,tick,G_USER_CURRENT.uid] ;

    return resultUrlStr ;
}


#define FIRSTLAUNCH             @"firstLaunch"
#define FIRSTPRODUCTDETAIL      @"isFirstGoInProductDetail"
#pragma mark -- isFirstLaunch
// NO
//第一次启动app
+ (BOOL)isNotFirstLaunch
{
    BOOL notFirstLaunch = NO ;
    if(![[NSUserDefaults standardUserDefaults] boolForKey:FIRSTLAUNCH])
    {
        NSLog(@"第一次启动");
        notFirstLaunch = NO ;
        [LSCommonFunc setNotFirstLaunchWithBool:YES] ;
    }
    else
    {
        NSLog(@"已经不是第一次启动了");
        notFirstLaunch = YES ;
    }
    
    return notFirstLaunch ;
}

+ (void)setNotFirstLaunchWithBool:(BOOL)bSwitch
{
    [[NSUserDefaults standardUserDefaults] setBool:bSwitch forKey:FIRSTLAUNCH];
}

#pragma mark -- isFirstGoInProductDetail
+ (BOOL)isNotFirstGoInProductDetail
{
    BOOL notfirstGoinPD = NO ;
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:FIRSTPRODUCTDETAIL])
    {
        NSLog(@"第一次进入商品详情");
        notfirstGoinPD = NO ;
        [LSCommonFunc setNotFirstGoInProductDetail:YES] ;
    }
    else
    {
        NSLog(@"已经不是第一次启动了");
        notfirstGoinPD = YES ;
    }
    
    return notfirstGoinPD ;
}

+ (void)setNotFirstGoInProductDetail:(BOOL)bFirst
{
    [[NSUserDefaults standardUserDefaults] setBool:bFirst forKey:FIRSTPRODUCTDETAIL];
}


#pragma mark --
#pragma mark - NSCalendar

+ (NSDateComponents *)shareComps
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//阳历
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ;
    now = [NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    return comps;
}

+ (int)getYear
{
    NSDateComponents *comps = [self shareComps];
    
    return [comps year];
}

+ (int)getMonth
{
    NSDateComponents *comps = [self shareComps];
    
    return [comps month];
}

+ (int)getDay
{
    NSDateComponents *comps = [self shareComps];
    
    return [comps day];
}

#pragma mark --
#pragma mark - CLLocation  get current location
+ (CLLocationCoordinate2D)getLocation
{
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    [lm setDesiredAccuracy:kCLLocationAccuracyBest];
    lm.distanceFilter = 1000.0f;
    [lm startUpdatingLocation];
    
    CLLocationCoordinate2D orgCoordinate ;
    orgCoordinate.longitude = lm.location.coordinate.longitude;
    orgCoordinate.latitude = lm.location.coordinate.latitude;
    [lm stopUpdatingLocation];
    
    return orgCoordinate;
}

#pragma mark --
#pragma mark - dealNavigationPushOrPopWithViewControllers
/*
 * vc  : 表示当前是哪一个vc
 * tag : 表示想push到哪一个ctrl
**/
+ (void)dealNavigationPushOrPopWithViewControllers:(UIViewController *)vc
                                        AndWithTag:(int)tag
{
    UIViewController *_destinationVC ;
    switch (tag) {
        case TAG_BT_USER://用户中心
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            _destinationVC = (MemberCenterController *)[storyboard instantiateViewControllerWithIdentifier:@"MemberCenterController"];

        }
            break;
        case TAG_BT_MYLIST://我的订单
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            _destinationVC = (OrderViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];

        }
            break;
        case TAG_BT_SHOPCAR://购物车
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            _destinationVC = (ShopCarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ShopCarViewController"];
        }
            break;
        case TAG_BT_SIGHIN://每日签到
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            _destinationVC = (LoginFirstController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginFirstController"];
        }
            break;
        case TAG_BT_BACKHOME://返回首页
        {
            // nothing ...
        }
            break;
            
        default:
            break;
    }

    if ([vc isKindOfClass:[_destinationVC class]]) {
        return ;
    }
    
    
    
    
    NSArray *arr_viewCtrls = vc.navigationController.viewControllers;   // ctrl's stack
    
    
    switch (tag) {
        case TAG_BT_USER://用户中心
        {
            //  Get the destination controller
            for (UIViewController *_vc1 in arr_viewCtrls) {
                if ([_vc1 isKindOfClass:[MemberCenterController class]]) {
                    [vc.navigationController popToViewController:_vc1 animated:YES] ;
                    break ;
                }
            }
            // if destination not in the stack , just push to new one ...
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MemberCenterController *ctrl = (MemberCenterController *)[storyboard instantiateViewControllerWithIdentifier:@"MemberCenterController"];
            [vc.navigationController pushViewController:ctrl animated:YES] ;
        }
            break;
        case TAG_BT_MYLIST://我的订单
        {
            //  Get the destination controller
            for (UIViewController *_vc1 in arr_viewCtrls) {
                if ([_vc1 isKindOfClass:[OrderViewController class]]) {
                    [vc.navigationController popToViewController:_vc1 animated:YES] ;
                    break ;
                }
            }
            // if destination not in the stack , just push to new one ...
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OrderViewController *ctrl = (OrderViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
            [vc.navigationController pushViewController:ctrl animated:YES] ;
        }
            break;
        case TAG_BT_SHOPCAR://购物车
        {
            //  Get the destination controller
            for (UIViewController *_vc1 in arr_viewCtrls) {
                if ([_vc1 isKindOfClass:[ShopCarViewController class]]) {
                    [vc.navigationController popToViewController:_vc1 animated:YES] ;
                    break ;
                }
            }
            // if destination not in the stack , just push to new one ...
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ShopCarViewController *ctrl = (ShopCarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ShopCarViewController"];
            [vc.navigationController pushViewController:ctrl animated:YES] ;
        }
            break;
        case TAG_BT_SIGHIN://每日签到, 暂且是登录
        {
            //  Get the destination controller
            for (UIViewController *_vc1 in arr_viewCtrls) {
                if ([_vc1 isKindOfClass:[LoginFirstController class]]) {
                    [vc.navigationController popToViewController:_vc1 animated:YES] ;
                    break ;
                }
            }
            // if destination not in the stack , just push to new one ...
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginFirstController *ctrl = (LoginFirstController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginFirstController"];
            [vc.navigationController pushViewController:ctrl animated:YES] ;        }
            break;
        case TAG_BT_BACKHOME://返回首页
        {
            [vc.navigationController popToRootViewControllerAnimated:YES] ;
        }
            break;
            
        default:
            break;
    }
}




#pragma mark -- 男女切换  0无, 1 男 , 2 女
+ (NSString *)boyGirlNum2Str:(int)num
{
    NSString *result = @"" ;
    switch (num) {
        case 1:
            result = @"男" ;
            break;
        case 2:
            result = @"女" ;
            break;
        default:
            break;
    }
    
    return result ;
}

+ (int)boyGirlStr2Num:(NSString *)str
{
    int num = 0;
    if ([str isEqualToString:@"男"]) {
        num = 1 ;
    }else if ([str isEqualToString:@"女"]) {
        num = 2 ;
    }
    
    return num ;
}

#pragma mark -- 数组切换字符串
+ (NSString *)getCommaStringWithArray:(NSArray *)array
{
    NSString *strResult = @"" ;
    
    for (int i = 0; i < array.count; i++)
    {
        if (i == array.count - 1)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@",array[i]] ;
            strResult = [strResult stringByAppendingString:tempStr];
        }
        else
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@,",array[i]] ;
            strResult = [strResult stringByAppendingString:tempStr];
        }
    }
    
    return strResult ;
}

#pragma mark -- modal搜索页
+ (void)popModalSearchViewWithCurrentController:(UIViewController *)controller
{
    UIStoryboard         *story         = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    NavSearchController  *searchCtrl    = [story instantiateViewControllerWithIdentifier:@"NavSearchController"] ;
    [controller presentViewController:searchCtrl animated:YES completion:nil] ;
}


#pragma mark -- 去掉小数点后面的0
+ (NSString *)changeFloat:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String] ;
    NSUInteger length = [stringFloat length] ;
    NSUInteger zeroLength = 0 ;
    int i = length - 1 ;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/)
        {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0" ;
    } else {
        returnString = [stringFloat substringToIndex:i+1] ;
    }
    return returnString;
}


#pragma mark -- 关闭应用
+ (void)shutDownAppWithCtrller:(UIViewController *)ctrller
{
    [UIView animateWithDuration:0.65f animations:^{
        ctrller.view.window.alpha = 0;
        ctrller.view.window.frame = CGRectMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

@end



