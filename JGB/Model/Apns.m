//
//  Apns.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-11.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "Apns.h"
#import "GoodsDetailViewController.h"
#import "MyWebController.h"
#import "DigitInformation.h"

@implementation Apns

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _apnsMode = [[dic objectForKey:@"apnsMode"] intValue] ;
        _value    = [dic objectForKey:@"value"]     ;
    }
    return self;
}

+ (Apns *)getApnsWithUserInfoDiction:(NSDictionary *)diction
{
    NSDictionary *apnsDic = [diction objectForKey:@"apns"] ;
    
    Apns *apns = [[Apns alloc] initWithDic:apnsDic] ;
    
    return apns ;
}

+ (void)goToDestinationFromController:(UIViewController *)controller WithApns:(Apns *)apns
{
    switch (apns.apnsMode) {
        case normalMode:
        {
            //无为
        }
            break;
        case productMode:
        {
            //商品详情
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
            GoodsDetailViewController *goodDetailVC = [story instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"] ;
            goodDetailVC.codeGoods = apns.value ;
            [controller.navigationController pushViewController:goodDetailVC animated:YES ] ;
            [goodDetailVC setHidesBottomBarWhenPushed:YES];

        }
            break;
        case activityMode:
        {
            //活动页
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyWebController *mywebCtrller = (MyWebController *)[storyboard instantiateViewControllerWithIdentifier:@"MyWebController"];
            mywebCtrller.urlStr = apns.value ;
            mywebCtrller.isActivity = YES ;
            [controller.navigationController pushViewController:mywebCtrller animated:YES] ;
            [mywebCtrller setHidesBottomBarWhenPushed:YES];

        }
            break;
        default:
            break;
    }
    
    
    
}


@end
