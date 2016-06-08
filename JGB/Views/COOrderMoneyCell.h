//
//  COOrderMoneyCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>



#define CELL_TITLE      @"订单金额"



@interface COOrderMoneyCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>

#pragma mark - attr s
@property(nonatomic,retain) NSMutableArray              *dataSource ;
@property(nonatomic,assign) float                       sumAllPrice ;


#pragma mark - view s
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height ;
@property (weak, nonatomic) IBOutlet UITableView        *tableOrderMoney ;


@end
