//
//  GoodsCommentsController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"

@interface GoodsCommentsController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

// attr
@property (nonatomic,copy) NSString *productCode ;


// views
//@property (weak, nonatomic) IBOutlet UIView *headView;
//@property (weak, nonatomic) IBOutlet UIView *segView;

@property (weak, nonatomic) IBOutlet UITableView *table;


@end
