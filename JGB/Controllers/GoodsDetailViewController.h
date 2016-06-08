//
//  GoodsDetailViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
//#import <libDoubanAPIEngine/DOUService.h>
#import "NLMainTableViewController.h"

@interface GoodsDetailViewController : NLMainTableViewController

@property (nonatomic,assign) int            m_buyNums ;   //购买数量

@property (nonatomic,retain)NSDictionary    *attrDic                    ;

@property (nonatomic,copy)  NSString        *codeGoods                  ;

@property (nonatomic,copy)  NSString        *category                   ;

@property (nonatomic,retain)NSDictionary    *attr                       ;     //已选择的尺码

@property (weak, nonatomic) IBOutlet UITableView *tableMain;




//@property (weak, nonatomic) IBOutlet UIView *bottomView;
//@property (weak, nonatomic) IBOutlet UIButton *addShopCart;
//@property (weak, nonatomic) IBOutlet UIButton *buyNow;
//@property (weak, nonatomic) IBOutlet UIButton *bottomShopCar;

@property (weak, nonatomic) IBOutlet UIImageView *img_shopCar;

- (IBAction)addShopCartAction:(id)sender;

//- (IBAction)buyNowAction:(id)sender;

- (IBAction)go2ShopCarAction:(id)sender;




@end




