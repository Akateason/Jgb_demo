//
//  ShipViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-14.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "RootCtrl.h"

@interface ShipViewController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

//  attrs
@property (nonatomic)       int         parcelID    ;   //子订单id
@property (nonatomic, copy) NSString    *orderIdStr ;   //子订单id code


//  views
@property (weak, nonatomic) IBOutlet UITableView    *table  ;

@end
