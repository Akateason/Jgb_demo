//
//  CataSubController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesCatagory.h"
#import "MySearchBar.h"
#import "RootCtrl.h"


@interface CataSubController : RootCtrl<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,retain) SalesCatagory       *myCata        ;

@property (weak, nonatomic) IBOutlet UITableView *tableLeft     ;

@property (weak, nonatomic) IBOutlet UITableView *tableRight    ;

- (IBAction)searchBarButtonClickedAction:(id)sender;

@end
