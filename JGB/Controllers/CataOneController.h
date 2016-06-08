//
//  CataOneController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatagoryCell.h"
#import "MySearchBar.h"
#import "RootCtrl.h"




@interface CataOneController : RootCtrl <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table     ;

- (IBAction)searchBarButtonClickedAction:(id)sender;

@end
