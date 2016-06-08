//
//  CataSecondController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-29.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesCatagory.h"
#import "RootCtrl.h"
@interface CataSecondController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

//  values
@property (nonatomic,retain) SalesCatagory *currentCata ;


//  views
@property (weak, nonatomic) IBOutlet UITableView *leftTable     ;

@property (weak, nonatomic) IBOutlet UITableView *rightTable;


- (IBAction)searchBarButtonClickedAction:(id)sender;

@end
