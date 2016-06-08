//
//  FilterViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "Select_val.h"


@interface FilterViewController : RootCtrl <UITableViewDataSource,UITableViewDelegate>



@property (nonatomic,retain) NSArray          *m_brandList   ;

@property (nonatomic,assign)int               cateNum        ;          //大类. eg: 101

@property (nonatomic,retain) Select_val       *m_selectValue ;          //当前筛选

@property (nonatomic,copy) NSString           *flag           ;          //flag

@property (weak, nonatomic) IBOutlet UITableView *table      ;



@end
