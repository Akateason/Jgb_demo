//
//  LikeViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "EGORefreshTableFooterView.h"

@interface LikeViewController : RootCtrl<EGORefreshTableFooterDelegate>
{
    EGORefreshTableFooterView *refreshView;
    BOOL reloading;
}

@property (weak, nonatomic) IBOutlet UITableView *table;


@end
