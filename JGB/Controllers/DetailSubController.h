//
//  DetailSubController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-1.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLSubTableViewController.h"
#import "Goods.h"


@protocol DetailSubControllerDelegate <NSObject>

- (void)seeMoreCommment ;   //查看更多评论

@end


typedef enum {
    DetailMode = 0,
    SizeMode , 
    CommentMode
} ModeDetailSub ;


@interface DetailSubController : NLSubTableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,retain) id <DetailSubControllerDelegate> delegate ;

@property (nonatomic,retain) Goods *currentGood ;

//  @property (nonatomic,retain) UITableView *table ;

@end
