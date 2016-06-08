//
//  CouponsController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "Coupon.h"

#define NOTIFICATION_COUPSON_CODE   @"NOTIFICATION_COUPSON_CODE"

@protocol CouponsControllerDelegate <NSObject>

- (void)sendSelectedCousonList:(NSArray *)coupsonList ;

@end

#pragma mark --

@interface CouponsController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

//  attrs
@property (nonatomic,retain) NSArray        *cidLists    ; // 购物车id list

@property (nonatomic,retain) id <CouponsControllerDelegate> delegate ;

@property (nonatomic,assign) BOOL           LookOrSelect ;          // NO--only look,, YES--edit & select

@property (nonatomic,retain) NSMutableArray *coupsonList ;

//  views
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
