//
//  UseScoreController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "RootCtrl.h"

@protocol UseScoreControllerDelegate <NSObject>

- (void)sendWritedScore:(int)score ;

@end


@interface UseScoreController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) id <UseScoreControllerDelegate> delegate ;

@property (nonatomic)       int     scoreWrited ;

@property (weak, nonatomic) IBOutlet UITableView *table;

@end
