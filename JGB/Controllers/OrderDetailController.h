//
//  OrderDetailController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"

@interface OrderDetailController : RootCtrl <UITableViewDelegate,UITableViewDataSource>

//  attrs

@property (nonatomic,copy) NSString     *orderIDStr ;


//  views

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@end
