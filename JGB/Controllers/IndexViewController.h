//
//  IndexViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-1.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "MenuHrizontal.h"
#import "ScrollPageView.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"



@interface IndexViewController : RootCtrl <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,EGORefreshTableFooterDelegate>
{
    EGORefreshTableHeaderView   *_refreshHeaderView ;
    BOOL                        _reloadingHead      ;
    EGORefreshTableFooterView   *_refreshFooterView ;
    BOOL                        _reloadingFoot      ;
}


//@property (retain, nonatomic)  MenuHrizontal    *upView;
//@property (retain, nonatomic)  ScrollPageView   *contentView;

@property (weak, nonatomic) IBOutlet MenuHrizontal    *upView;
@property (weak, nonatomic) IBOutlet ScrollPageView   *contentView;

@end

