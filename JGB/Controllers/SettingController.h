//
//  SettingController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"

@interface SettingController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;

- (IBAction)exitUserAction:(id)sender ;

@end
