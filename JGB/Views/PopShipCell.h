//
//  PopShipCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-2-27.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressageDetail.h"


@interface PopShipCell : UITableViewCell

//  attrs
@property (nonatomic)   BOOL   isSelfSold ;// 是否自营
@property (nonatomic,retain) ExpressageDetail *expressDetail ;
//  views
@property (weak, nonatomic) IBOutlet UILabel *lb_comeFrom;

@property (weak, nonatomic) IBOutlet UILabel *lb_day1;

@property (weak, nonatomic) IBOutlet UILabel *lb_day2;

@property (weak, nonatomic) IBOutlet UILabel *lb_day3;

@property (weak, nonatomic) IBOutlet UILabel *lb_day4;

@property (weak, nonatomic) IBOutlet UILabel *lb_1;

@property (weak, nonatomic) IBOutlet UILabel *lb_2;

@property (weak, nonatomic) IBOutlet UILabel *lb_3;

@property (weak, nonatomic) IBOutlet UILabel *lb_4;


@end
