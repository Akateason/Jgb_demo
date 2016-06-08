//
//  PaySuccessController.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-20.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "RootCtrl.h"


@interface PaySuccessController : RootCtrl <UITableViewDataSource,UITableViewDelegate>
//  attrs
//@property (nonatomic,copy)  NSString    *orderStrID ;

//  views
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
