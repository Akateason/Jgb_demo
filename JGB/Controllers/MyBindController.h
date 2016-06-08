//
//  MyBindController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"

@interface BindCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_bind;


@end



@interface MyBindController : RootCtrl <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *table;


@end
