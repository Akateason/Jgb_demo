//
//  MessageCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBorderView.h"

@interface MessageCell : UITableViewCell
//  attrs

// line_Is_FME
/*
 **********
 *  0->middle
 * -1->first line
 *  1->last line
 **********
 */
@property (nonatomic,assign) int    line_Is_FME         ;

//是否有border
@property (nonatomic,assign) BOOL   isHavingBorder      ;

//是否首个point
@property (nonatomic,assign) BOOL   isFirstPoint        ;


//  views
@property (weak, nonatomic) IBOutlet LBorderView *borderView;

@property (weak, nonatomic) IBOutlet UIView *upLine;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet UILabel *lb_choujiang;

@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UIView *corner;

@property (weak, nonatomic) IBOutlet UIView *bgView;



@end




