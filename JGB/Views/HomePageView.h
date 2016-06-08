//
//  HomePageView.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-10.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "ResultPasel.h"

#define NOTIFICATION_INDEXFIRST     @"NOTIFICATION_INDEXFIRST"


@protocol HomePageViewDelegate <NSObject>

- (void)shutDownApp ;

@end

@interface HomePageView : UITableView <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,EGORefreshTableFooterDelegate>
{
    EGORefreshTableHeaderView   *_refreshHeaderView ;
    BOOL                        _reloadingHead      ;
    EGORefreshTableFooterView   *_refreshFooterView ;
    BOOL                        _reloadingFoot      ;
}

@property (nonatomic,retain) id <HomePageViewDelegate> shutDowndelegate ;

- (instancetype)initWithMyFrame:(CGRect)frame ;

- (void)setMyResult:(ResultPasel *)result ;

@end
