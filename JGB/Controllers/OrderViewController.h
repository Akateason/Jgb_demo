//
//  OrderViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "RootCtrl.h"

@interface OrderCurrentSort : NSObject

@property (nonatomic) int page      ;
@property (nonatomic) int number    ;
@property (nonatomic) int status    ;

- (instancetype)initWithPage:(int)page
               AndWithNumber:(int)number
               AndWithStatus:(int)status        ;


@end






//查看  订单列表

@interface OrderViewController : RootCtrl <UITableViewDataSource,UITableViewDelegate,EGORefreshTableFooterDelegate>
{
    EGORefreshTableFooterView *refreshView;
    BOOL reloading;
}

@property (weak, nonatomic) IBOutlet UIView *segView;

@property (weak, nonatomic) IBOutlet UITableView *table;



@end
