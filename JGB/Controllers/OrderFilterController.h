//
//  OrderFilterController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "RootCtrl.h"

#define NOTIFICATION_ORDER_FILTER_POST  @"NOTIFICATION_ORDER_FILTER_POST"


@interface OrderFilterController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic)                int         orderStatus ;

@property (weak, nonatomic) IBOutlet UITableView *table ;

@end
