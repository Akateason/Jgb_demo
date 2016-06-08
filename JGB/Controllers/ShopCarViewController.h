//
//  ShopCarViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "EGORefreshTableHeaderView.h"

#define NOTIFICATION_HIDE_SHOPCAR_BACK      @"NOTIFICATION_HIDE_SHOPCAR_BACK"

@interface ShopCarViewController : RootCtrl <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView   *_refreshHeaderView ;
    
//  Reloading var should really be your tableviews datasource
//  Putting it here for demo purposes
    BOOL                        _reloading          ;
}


#pragma mark - attrs
/**
 *  isPop  *
 *  DEFAULT is NO , which means in tabbar controller , from tabbaritems
 *  when it becomes YES, it should be pop to last controller in isNothing Call Back Function
 */
@property (nonatomic)       BOOL    isPop ;



#pragma mark - views

@property (weak, nonatomic) IBOutlet UITableView *table_shopCar;

@property (weak, nonatomic) IBOutlet UILabel *lb_price_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_price_value;

@property (weak, nonatomic) IBOutlet UIButton *button_checkout;

- (IBAction)goToCheckOutAction:(id)sender   ;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

//全选
//@property (weak, nonatomic) IBOutlet UIImageView *img_allSelect;
//@property (weak, nonatomic) IBOutlet UIButton *bt_allSelect;
//- (IBAction)allSelectAction:(id)sender;

//商家运费,国际运费
@property (weak, nonatomic) IBOutlet UILabel *lb_sellerFreight;
@property (weak, nonatomic) IBOutlet UILabel *lb_interFreight;

//竖线
//@property (weak, nonatomic) IBOutlet UIView *lineSeperate;


//处理核价后的 放到购物车
- (void)putCheckListIntoShopCarListWith:(NSArray *)checkedList ;


@end


