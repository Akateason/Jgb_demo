//
//  PopMenuView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_BT_USER       650
#define TAG_BT_MYLIST     651
#define TAG_BT_SHOPCAR    652
#define TAG_BT_SIGHIN     653
#define TAG_BT_BACKHOME   654

#define STR_MYLIST      @"我的订单"
#define STR_SHOPCAR     @"购物车"
#define STR_SIGNIN      @"每日签到"
#define STR_HOMEBACK    @"返回首页"

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageManagerDelegate.h"


@protocol PopMenuViewDelegate <NSObject>
//点击 menu 外部
- (void)clickOutSide ;

- (void)goToContollerWithTag:(int)tag ;


@end


@interface PopMenuView : UIView     //<SDWebImageDownloaderDelegate>


@property (nonatomic,retain) id <PopMenuViewDelegate> delegate ;

/*
 * POP MENU GLOBAL FUNTION *
 * flag yes表示 一定删除menu
 *      no 表示 常规处理
**/
+ (void)showHidePopMenuWithVC:(UIViewController *)vc AndWithMustRemove:(BOOL)flag;



@property (weak, nonatomic) IBOutlet UIImageView *headPicView;  //头像

@property (weak, nonatomic) IBOutlet UILabel *name_lb;          //姓名
//@property (weak, nonatomic) IBOutlet UILabel *level_lb;         //等级



@property (nonatomic,weak) IBOutlet UILabel *lb_howManyShopCar ;
@property (nonatomic,weak) IBOutlet UILabel *lb_signInOrNo ;
 ;

@property (weak, nonatomic) IBOutlet UIView *v1;
@property (weak, nonatomic) IBOutlet UIView *v2;
@property (weak, nonatomic) IBOutlet UIView *v3;
@property (weak, nonatomic) IBOutlet UIView *v4;
@property (weak, nonatomic) IBOutlet UIView *v5;


- (IBAction)pressedPopMenuAction:(id)sender;

- (IBAction)tapWhite:(id)sender;

@end
