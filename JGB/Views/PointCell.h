//
//  PointCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Score.h"

typedef enum {
    isUp    =   - 1 ,
    isMiddle ,
    isBottom
} MyPointCellMode;


@interface PointCell : UITableViewCell

//  attrs
@property (nonatomic)        Score            *theScore     ;

@property (nonatomic,assign) MyPointCellMode  pointMode ;


//  views
@property (weak, nonatomic) IBOutlet UIView *roundView;

@property (weak, nonatomic) IBOutlet UIView *upLine;

@property (weak, nonatomic) IBOutlet UIView *bottonLine;


@property (weak, nonatomic) IBOutlet UILabel *lb_time;//时间

@property (weak, nonatomic) IBOutlet UILabel *lb_detaPoints;//加减分

@property (weak, nonatomic) IBOutlet UILabel *lb_content;//内容

@end
