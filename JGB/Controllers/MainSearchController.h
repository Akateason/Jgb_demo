//
//  MainSearchController.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-2-17.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "MySearchBar.h"

@interface MainSearchController : RootCtrl

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet MySearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *searchBackView;

@end
