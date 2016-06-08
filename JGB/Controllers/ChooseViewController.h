//
//  ChooseViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "Goods.h"

@protocol ChooseViewControllerDelegate <NSObject>

- (void)alreadyChooseStyle:(NSDictionary *)attrDic AndGood:(Goods *)good AndWithBuyNums:(int)num;

@end


@interface ChooseViewController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) id <ChooseViewControllerDelegate> delegate         ;

// properties
@property (nonatomic,retain) NSDictionary *attr ;       // default goods attr  ----  model , my select attr of goods


//@property (nonatomic,retain) NSDictionary *attribute ;  // all attrbutes
@property (nonatomic,copy)   NSString     *defaultPic ; // defaultPic path
@property (nonatomic,retain) Goods        *goods;       // current goods info
@property (nonatomic,assign) int          m_numBuy ;    // buy num ;



// my views
@property (weak, nonatomic) IBOutlet UITableView    *table                      ;
@property (weak, nonatomic) IBOutlet UIView         *headView                   ;
@property (weak, nonatomic) IBOutlet UIImageView    *imgGood                    ;

@property (weak, nonatomic) IBOutlet UILabel        *lb_actualPrice             ;
@property (weak, nonatomic) IBOutlet UILabel        *lb_stockNum                ;
@property (weak, nonatomic) IBOutlet UILabel        *lb_selectGoodInfomation    ;

@property (weak, nonatomic) IBOutlet UIView         *bottomView                 ;

@property (weak, nonatomic) IBOutlet UIButton       *bt_buyNow                  ;
- (IBAction)buyNowAction:(id)sender     ;

@property (weak, nonatomic) IBOutlet UIButton       *bt_shopcar                 ;
- (IBAction)go2shopCar:(id)sender       ;


//进入购物车界面
@property (weak, nonatomic) IBOutlet UIButton *bt_openShopCar;
- (IBAction)openShopCarAction:(id)sender;

@end
