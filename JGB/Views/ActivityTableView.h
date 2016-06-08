//
//  ActivityTableView.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-10.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#define NOTIFICATION_INDEXFIRST     @"NOTIFICATION_INDEXFIRST"

@interface ActivityTableView : UITableView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,EGORefreshTableFooterDelegate>
{
    EGORefreshTableHeaderView   *_refreshHeaderView ;
    BOOL                        _reloadingHead      ;
    EGORefreshTableFooterView   *_refreshFooterView ;
    BOOL                        _reloadingFoot      ;
}

- (instancetype)initWithMyFrame:(CGRect)frame ;

- (void)reFreshAllMyViewsManuallyWithTagID:(int)tagID ;

@end
