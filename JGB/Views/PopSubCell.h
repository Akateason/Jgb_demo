//
//  PopSubCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCellObj.h"
#import "ExpressageDetail.h"

@interface PopSubCell : UITableViewCell

//  attrs
@property (nonatomic,retain) DetailCellObj *cellObj ;

@property (nonatomic,retain) ExPressKVO    *cellKvo ;

//@property (nonatomic)        BOOL          isLastLine ; //yes : is last line

//  views
@property (nonatomic,retain) UILabel *lb_solidLine ;

@property (weak, nonatomic) IBOutlet UILabel *lb_left;
@property (weak, nonatomic) IBOutlet UILabel *lb_right;

@end
