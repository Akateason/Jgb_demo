//
//  CheckOutController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "PinkButton.h"
#import "ResultCheckOut.h"


@interface CheckOutController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

// properties
//@property (nonatomic,retain) NSArray *cidList                   ;

@property (nonatomic,retain)    NSDictionary *resultDiction     ;

// views
@property (weak, nonatomic) IBOutlet UITableView *table         ;

@property (weak, nonatomic) IBOutlet UIView *bottomView         ;

@property (weak, nonatomic) IBOutlet PinkButton *bt_confirm       ;

@property (weak, nonatomic) IBOutlet UILabel *lb_allMoneyValue  ;
@property (weak, nonatomic) IBOutlet UILabel *lb_youNeedPay;


- (IBAction)confrimAction:(id)sender;

@end
